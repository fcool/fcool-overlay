# Copyright 2023 Ferdinand Kuhl

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
ROCM_VERSION="6.3"

inherit cmake cuda python-single-r1 rocm

# llama.cpp commit pinned by Strata (third_party/ggml/VERSION.txt)
LLAMA_COMMIT="3cf03257f219afbe7334045ff7c6a06ac68c627d"

DESCRIPTION="Qwen3.8-Flash-Next on any consumer hardware: one-click install for Windows / Linux. Strata inference engine, OpenAI/Anthropic API on localhost, optional image input."
HOMEPAGE="https://github.com/Niko1221/Strata"
SRC_URI="https://github.com/Niko1221/Strata/archive/v${PV}.tar.gz -> strata-${PV}.tar.gz
	https://github.com/ggml-org/llama.cpp/archive/${LLAMA_COMMIT}.tar.gz -> llama.cpp-${LLAMA_COMMIT}.tar.gz"
S="${WORKDIR}/Strata-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+cuda hip"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	^^ ( cuda hip )
	hip? ( ${ROCM_REQUIRED_USE} )
"

# TODO: vision encoder (strata-vision). It has its own CMake tree in tools/vision, built against
# llama.cpp (-DLLAMA_DIR=..., -DSTRATA_VISION_CUDA=ON / -DSTRATA_VISION_HIP=ON) and is shipped
# inside the engine package; see packaging/build_cuda_linux.sh and packaging/build_hip_linux.sh.
# TODO: the hip backend is untested.

COMMON_DEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	hip? (
		>=dev-util/hip-${ROCM_VERSION}:=
		>=sci-libs/hipBLAS-${ROCM_VERSION}:=[${ROCM_USEDEP}]
		>=sci-libs/rocBLAS-${ROCM_VERSION}:=[${ROCM_USEDEP}]
	)
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="
	${COMMON_DEPEND}
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/textual[${PYTHON_USEDEP}]
		dev-python/jinja2[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/regex[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/truststore[${PYTHON_USEDEP}]
	')
"
BDEPEND="${PYTHON_DEPS}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	use cuda && cuda_src_prepare
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# Use the vendored llama.cpp instead of fetching it via FetchContent
		-DSTRATA_GGML_DIR="${WORKDIR}/llama.cpp-${LLAMA_COMMIT}"
		-DSTRATA_BUILD_TESTS=OFF
		# Safety net: never download anything during configure
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DSTRATA_NATIVE_EXPERTS=ON
		-DSTRATA_ENABLE_CUDA=$(usex cuda)
		-DSTRATA_ENABLE_HIP=$(usex hip)
	)

	if use cuda; then
		cuda_add_sandbox -w
		# Build everything with the gcc nvcc supports: mixing a newer host g++ with nvcc's one
		# links against the older libstdc++ and fails with undefined std::atomic wait symbols
		local gccdir
		gccdir=$(cuda_gccdir) || die "no gcc supported by nvcc found"
		export CC="${gccdir}/gcc" CXX="${gccdir}/g++" CUDAHOSTCXX="${gccdir}/g++"
		# Same default as upstream's release builds; override with CUDAARCHS (e.g. "120")
		mycmakeargs+=(
			-DCMAKE_CUDA_ARCHITECTURES="${CUDAARCHS:-75;80;86;89;120}"
			-DSTRATA_Q6K_EXPERTS=ON
			-DSTRATA_MMQ_KQUANTS=ON
		)
	fi

	if use hip; then
		local hipclangpath
		hipclangpath=$(hipconfig --hipclangpath) || die "hipconfig --hipclangpath failed"
		mycmakeargs+=(
			-DCMAKE_HIP_COMPILER="${hipclangpath}/clang++"
			-DCMAKE_HIP_ARCHITECTURES="$(get_amdgpu_flags)"
			-DSTRATA_PREFILL_MMQ=ON
		)
	fi

	cmake_src_configure
}

src_compile() {
	local targets=( strata strata-gguf strata-dequant strata-plan )
	use cuda && targets+=( strata_kq )
	cmake_src_compile "${targets[@]}"
}

src_install() {
	local app_dir="/usr/$(get_libdir)/${PN}"

	# The application, as upstream's terminal archive ships it (packaging/package_terminal.py)
	insinto "${app_dir}"
	doins strata.py setup.py requirements.txt requirements-monitor.txt
	doins -r strata_cli strata_control serve data
	echo "${PV}" > "${T}/VERSION" || die
	doins "${T}/VERSION"
	insinto "${app_dir}/ref"
	doins ref/load.py
	insinto "${app_dir}/docs"
	doins docs/MANAGEMENT_PROTOCOL.md docs/TERMINAL_LAUNCH.md
	insinto "${app_dir}/bench/prompts"
	doins -r bench/prompts/standard-v1
	insinto "${app_dir}/tools"
	doins tools/*.py
	find "${ED}${app_dir}" \( -name 'test_*.py' -o -name '*_test.py' -o -name 'fixtures' \) \
		-exec rm -rf {} + || die
	exeinto "${app_dir}/bin"
	doexe bin/strata

	# The engine, as a component package in the layout strata_control/engine_component.py expects
	local stage="${T}/engine-stage" backend=$(usex cuda cuda hip) arch archs=()
	mkdir -p "${stage}" || die
	cp "${BUILD_DIR}/strata" "${stage}/" || die
	if use cuda; then
		cp "${BUILD_DIR}/libstrata_kq.so" "${stage}/" || die
		local cuda_archs="${CUDAARCHS:-75;80;86;89;120}"
		for arch in ${cuda_archs//;/ }; do
			archs+=( --arch "sm_${arch}" )
		done
	else
		local amdgpu_archs="$(get_amdgpu_flags)"
		for arch in ${amdgpu_archs//;/ }; do
			archs+=( --arch "${arch}" )
		done
	fi
	# The GPU runtime libraries come from the system (see DEPEND), not bundled as upstream does
	local lib
	for lib in $(scanelf -qF '%n#F' "${stage}"/* | tr ',' ' '); do
		archs+=( --allow-lib "${lib}" )
	done
	mkdir -p "${ED}${app_dir}/components/engine" || die
	"${EPYTHON}" packaging/package_engine.py --src "${stage}" --backend "${backend}" --version "${PV}" \
		--out "${ED}${app_dir}/components/engine" --platform linux-x86_64 --build-id "gentoo-${PF}" \
		--include 'libstrata_kq*' "${archs[@]}" || die "packaging the engine failed"
	# Stripping would change the files and break the SHA-256 sums in the package manifest
	dostrip -x "${app_dir}/components"

	dobin "${BUILD_DIR}"/strata-{gguf,dequant,plan}

	sed -e "s|@APP_DIR@|${EPREFIX}${app_dir}|" -e "s|@PYTHON@|${PYTHON}|" \
		"${FILESDIR}/strata-wrapper.sh" > "${T}/strata" || die
	dobin "${T}/strata"

	python_optimize "${ED}${app_dir}"
	einstalldocs
}

pkg_postinst() {
	elog "Start Strata with 'strata launch'. On first use the wrapper links the engine installed"
	elog "by portage into \${XDG_DATA_HOME:-~/.local/share}/strata/components/engine, so no engine"
	elog "is downloaded. Models are still downloaded into your home directory on request."
	elog "Avoid 'strata update': it would download a newer upstream engine next to the system one."
}
