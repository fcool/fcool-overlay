# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV}

VER_PART=$(ver_cut 4-5)

if [[ ${VER_PART} = rc* ]]; then
        MY_PV=$(ver_cut 1-3)-devel${VER_PART#rc}
fi

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
DESCRIPTION="Bash Line Editor―a line editor written in pure Bash with syntax highlighting, auto suggestions, vim modes, etc. for Bash interactive sessions."
LICENSE="BSD"
SLOT="0"
SRC_URI="https://github.com/akinomyoga/ble.sh/archive/v${MY_PV}.tar.gz -> ${P}.tgz"
SRC_URI+=" https://digital-competence.de/fcool-overlay/${PN}-${PV}-contrib.tar.xz"

RDEPEND="
        app-shells/bash
"

S="${WORKDIR}/ble.sh-${MY_PV}"

src_compile () {
        blesh_build_pkgver="${PV}"
        sed -i "s/git show -s --format=%h/echo none/" "ble.pp"
        mkdir .git
        emake FULLVER="$(ver_cut 1-3)"
        sed -i "s/^_ble_base_repository=.*/_ble_base_repository=release:$pkgver/" "out/ble.sh"
}

src_install () {
        emake DESTDIR="${D}" INSDIR="${D}/usr/share/ble-${PV}" install
        einstalldocs
        dosym ble-${PV} /usr/share/ble.sh
}
