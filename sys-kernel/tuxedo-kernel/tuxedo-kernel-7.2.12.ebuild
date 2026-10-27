# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KERNEL_IUSE_GENERIC_UKI=1

inherit kernel-build toolchain-funcs verify-sig

BASE_P=linux-${PV%.*}
PATCH_PV=${PV%_p*}
PATCHSET=linux-gentoo-patches-7.1.9
# https://koji.fedoraproject.org/koji/packageinfo?packageID=8
# forked to git.gentoo.org:fork/fedora/kernel
CONFIG_VER=7.2.10-gentoo
GENTOO_CONFIG_P=gentoo-kernel-config-g19
SHA256SUM_DATE=20261021
# Debian kconfig commit from:
# https://salsa.debian.org/kernel-team/linux/-/tree/debian/latest/debian/
DEBIAN_COMMIT=31e70f1f469ef1ce4c910df1d12b7de09da561d1
# TUXEDO's own delta over the base: four bugfix patches plus one KConfig
# fragment, pinned to their newest tag for this release.  Bumping this
# package means taking the matching gentoo-kernel ebuild and touching only
# the three TUX_ lines marked DELTA (TUX_REV, the file names, TUX_CONFIG).
TUX_REV="debian%2F${PV}-1%2Btux1"
TUX_RAW="https://gitlab.com/tuxedocomputers/development/packages/linux/-/raw/${TUX_REV}/debian"
SRC_URI+="
	${TUX_RAW}/patches-tuxedo/0001-drm-i915-display-Add-quirk-to-force-backlight-type-o.patch
		-> tuxedo-0001.patch
	${TUX_RAW}/patches-tuxedo/0002-drm-i915-rc6-Disable-RC6-for-TUXEDO-InfinityBook-Pro.patch
		-> tuxedo-0002.patch
	${TUX_RAW}/patches-tuxedo/0003-drm-ensure-that-vblank-diff-is-never-negative.patch
		-> tuxedo-0003.patch
	${TUX_RAW}/patches-tuxedo/0004-ALSA-hda-realtek-Add-quirk-for-ASRock-NUC-BOX-358H.patch
		-> tuxedo-0004.patch
	${TUX_RAW}/config/amd64/config.tuxedo
		-> tuxedo-config-amd64.config
		"
TUX_FILES=( tuxedo-0001.patch tuxedo-0002.patch tuxedo-0003.patch tuxedo-0004.patch )
TUX_CONFIG="tuxedo-config-amd64.config"

DESCRIPTION="Linux kernel built with Gentoo patches plus TUX's delta"
HOMEPAGE="
	https://wiki.gentoo.org/wiki/Project:Distribution_Kernel
	https://www.kernel.org/
"
SRC_URI+="
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${BASE_P}.tar.xz
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/patch-${PATCH_PV}.xz
	https://distfiles.gentoo.org/pub/proj/dist-kernel/patchsets/7.1/${PATCHSET}.tar.xz
	https://gitweb.gentoo.org/proj/dist-kernel/gentoo-kernel-config.git/snapshot/${GENTOO_CONFIG_P}.tar.bz2
	https://distfiles.gentoo.org/pub/proj/dist-kernel/config/fedora-kernel-config-${CONFIG_VER}.tar.xz
	https://salsa.debian.org/kernel-team/linux/-/archive/${DEBIAN_COMMIT}/linux-${DEBIAN_COMMIT}.tar.bz2
	verify-sig? (
		https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/sha256sums.asc
			-> linux-$(ver_cut 1).x-sha256sums-${SHA256SUM_DATE}.asc
	)
"
S=${WORKDIR}/${BASE_P}

KEYWORDS="~amd64"
IUSE="debug hardened"
REQUIRED_USE="
	hppa? ( savedconfig )
	mips? ( savedconfig )
"

# Keeping the provider role for virtual/dist-kernel-<PV> unique: without this
# portage re-pulls another kernel flavour whenever @module-rebuild is resolved.
RDEPEND="
		!sys-kernel/gentoo-kernel:${SLOT}
		!sys-kernel/gentoo-kernel-bin:${SLOT}
		!sys-kernel/vanilla-kernel:${SLOT}
		"
BDEPEND="
	debug? ( dev-util/pahole )
	verify-sig? ( >=sec-keys/openpgp-keys-kernel-20250702 )
"
PDEPEND="
	>=virtual/dist-kernel-${PV}
"

QA_FLAGS_IGNORED="
	usr/src/linux-.*/scripts/gcc-plugins/.*.so
	usr/src/linux-.*/vmlinux
	usr/src/linux-.*/arch/powerpc/kernel/vdso.*/vdso.*.so.dbg
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/kernel.org.asc

src_unpack() {
	if use verify-sig; then
		cd "${DISTDIR}" || die
		verify-sig_verify_signed_checksums \
			"linux-$(ver_cut 1).x-sha256sums-${SHA256SUM_DATE}.asc" \
			sha256 "${BASE_P}.tar.xz patch-${PATCH_PV}.xz"
		cd "${WORKDIR}" || die
	fi

	default
}

src_prepare() {
	local patch
	eapply "${WORKDIR}/patch-${PATCH_PV}"
	eapply "${WORKDIR}/${PATCHSET}"

	# TUX fixes on top, in their series order (see TUX_FILES)
	local tux_patch
	for tux_patch in "${TUX_FILES[@]}"; do
		eapply "${DISTDIR}/${tux_patch}"
	done

	default

	# add Gentoo patchset version
	local extraversion=${PV#${PATCH_PV}}
	sed -i -e "s:^\(EXTRAVERSION =\).*:\1 ${extraversion/_/-}:" Makefile || die

	local biendian=false
	local merge_configs=()

	# prepare the default config
	case ${ARCH} in
		hppa | mips)
			> .config || die
		;;
		alpha)
			cp "${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/config" .config || die
			merge_configs+=(
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/alpha/config"
			)
			;;
		amd64)
			cp "${WORKDIR}/fedora-kernel-config-${CONFIG_VER}/kernel-x86_64-fedora.config" .config || die
			;;
		arm)
			cp "${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/config" .config || die
			merge_configs+=(
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/armhf/config" \
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/armhf/config.armmp-lpae"
			)
			;;
		arm64)
			cp "${WORKDIR}/fedora-kernel-config-${CONFIG_VER}/kernel-aarch64-fedora.config" .config || die
			biendian=true
			;;
		loong)
			cp "${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/config" .config || die
			merge_configs+=(
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/loong64/config"
			)
			;;
		m68k)
			cp "${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/config" .config || die
			merge_configs+=(
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/m68k/config"
			)
			;;
		ppc)
			cp "${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/config" .config || die
			merge_configs+=(
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/powerpc/config"
			)
			;;
		ppc64)
			cp "${WORKDIR}/fedora-kernel-config-${CONFIG_VER}/kernel-ppc64le-fedora.config" .config || die
			biendian=true
			;;
		riscv)
			cp "${WORKDIR}/fedora-kernel-config-${CONFIG_VER}/kernel-riscv64-fedora.config" .config || die
			;;
		s390)
			cp "${WORKDIR}/fedora-kernel-config-${CONFIG_VER}/kernel-s390x-fedora.config" .config || die
			;;
		sparc)
			cp "${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/config" .config || die
			merge_configs+=(
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/sparc64/config"
			)
			;;
		x86)
			cp "${WORKDIR}/fedora-kernel-config-${CONFIG_VER}/kernel-i686-fedora.config" .config || die
			;;
		*)
			die "Unsupported arch ${ARCH}"
			;;
	esac

	local myversion="-tuxedo-dist"
	use hardened && myversion+="-hardened"
	echo "CONFIG_LOCALVERSION=\"${myversion}\"" > "${T}"/version.config || die
	local dist_conf_path="${WORKDIR}/${GENTOO_CONFIG_P}"

	merge_configs+=(
		"${T}"/version.config
		"${dist_conf_path}"/base.config
		"${dist_conf_path}"/6.12+.config
	)
	use debug || merge_configs+=(
		"${dist_conf_path}"/no-debug.config
	)
	if use hardened; then
		merge_configs+=( "${dist_conf_path}"/hardened-base.config )

		tc-is-gcc && merge_configs+=( "${dist_conf_path}"/hardened-gcc-plugins.config )

		if [[ -f "${dist_conf_path}/hardened-${ARCH}.config" ]]; then
			merge_configs+=( "${dist_conf_path}/hardened-${ARCH}.config" )
		fi
	fi

	# this covers ppc64 and aarch64_be only for now
	if [[ ${biendian} == true && $(tc-endian) == big ]]; then
		merge_configs+=( "${dist_conf_path}/big-endian.config" )
	fi

	use secureboot && merge_configs+=(
		"${dist_conf_path}/secureboot.config"
		"${dist_conf_path}/zboot.config"
	)

	use amd64 && merge_configs+=( "${DISTDIR}/${TUX_CONFIG}" )
	kernel-build_merge_configs "${merge_configs[@]}"
}
