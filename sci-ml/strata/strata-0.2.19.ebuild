# Copyright 2023 Ferdinand Kuhl

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
ROCM_VERSION="6.3"

inherit cmake cuda python-single-r1 rocm

DESCRIPTION="Qwen3.8-Flash-Next on any consumer hardware: one-click install for Windows / Linux. Strata inference engine, OpenAI/Anthropic API on localhost, optional image input."
HOMEPAGE="https://github.com/Niko1221/Strata"
# since 0.2.16 the checkout carries ggml in engine/third_party/strata-ggml (frozen at the llama.cpp commit
# named by engine/third_party/ggml/VERSION.txt), so the sources alone are enough: nothing else to download
SRC_URI="https://github.com/Niko1221/Strata/archive/v${PV}.tar.gz -> strata-${PV}.tar.gz"
S="${WORKDIR}/Strata-${PV}"
# since 0.2.16 the checkout has one folder per part (app/ engine/ terminal/ docs/ tools/): the engine's
# CMake tree is in engine/, the Terminal to install is in terminal/
CMAKE_USE_DIR="${S}/engine"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+cuda hip"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	^^ ( cuda hip )
	hip? ( ${ROCM_REQUIRED_USE} )
"

# TODO: vision encoder (strata-vision). It has its own CMake tree in terminal/tools/vision (strata-vision is
# Strata's own reader now: no llama.cpp source, no -DLLAMA_DIR), built for the engine's architectures and shipped
# inside the engine package; see tools/packaging/build_cuda_linux.sh and tools/packaging/build_hip_linux.sh.
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
		# ggml comes from the tree vendored in engine/third_party/strata-ggml: nothing to fetch, and no
		# -DSTRATA_GGML_DIR needed (it only still exists as an override for a llama.cpp checkout)
		-DSTRATA_BUILD_TESTS=OFF
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
		)
	fi

	if use hip; then
		local hipclangpath
		hipclangpath=$(hipconfig --hipclangpath) || die "hipconfig --hipclangpath failed"
		mycmakeargs+=(
			-DCMAKE_HIP_COMPILER="${hipclangpath}/clang++"
			-DCMAKE_HIP_ARCHITECTURES="$(get_amdgpu_flags)"
		)
	fi

	cmake_src_configure
}

src_compile() {
	# since 0.2.16 llama.cpp's MMQ and the strata_kq library (libstrata_kq.so) left the tree: one engine
	# target for both GPU backends
	cmake_src_compile strata strata-gguf strata-dequant strata-plan
}

src_install() {
	local app_dir="/usr/$(get_libdir)/${PN}"

	# The application, as upstream's terminal archive ships it (tools/packaging/package_terminal.py):
	# since 0.2.16 the Terminal has its own folder in the checkout, docs/ stays the repository's
	insinto "${app_dir}"
	doins terminal/strata.py terminal/setup.py terminal/requirements.txt terminal/requirements-monitor.txt
	doins -r terminal/strata_cli terminal/strata_control terminal/serve terminal/data
	echo "${PV}" > "${T}/VERSION" || die
	doins "${T}/VERSION"
	insinto "${app_dir}/ref"
	doins terminal/ref/load.py
	insinto "${app_dir}/docs"
	doins docs/MANAGEMENT_PROTOCOL.md docs/TERMINAL_LAUNCH.md
	insinto "${app_dir}/bench/prompts"
	doins -r terminal/bench/prompts/standard-v1
	insinto "${app_dir}/tools"
	doins terminal/tools/*.py
	# the model preparation tools import llama.cpp's vendored gguf-py and HF converter: in the checkout it
	# sits in engine/third_party/strata-gguf-py, and the Terminal archive ships it beside the Terminal's
	# tools under third_party/, which is where tools/_paths.py looks for it at run time
	insinto "${app_dir}/third_party"
	doins -r engine/third_party/strata-gguf-py
	find "${ED}${app_dir}" \( -name 'test_*.py' -o -name '*_test.py' -o -name 'fixtures' \) \
		-exec rm -rf {} + || die
	exeinto "${app_dir}/bin"
	doexe terminal/bin/strata

	# The engine, as a component package in the layout strata_control/engine_component.py expects. Only
	# strata goes in: there is no libstrata_kq.so any more (llama.cpp's MMQ left the tree in 0.2.16)
	local stage="${T}/engine-stage" backend=$(usex cuda cuda hip) arch archs=()
	mkdir -p "${stage}" || die
	cp "${BUILD_DIR}/strata" "${stage}/" || die
	if use cuda; then
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
	"${EPYTHON}" tools/packaging/package_engine.py --src "${stage}" --backend "${backend}" --version "${PV}" \
		--out "${ED}${app_dir}/components/engine" --platform linux-x86_64 --build-id "gentoo-${PF}" \
		"${archs[@]}" || die "packaging the engine failed"
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
