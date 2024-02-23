# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
DESCRIPTION="Bash Line Editor―a line editor written in pure Bash with syntax highlighting, auto suggestions, vim modes, etc. for Bash interactive sessions."
LICENSE="BSD"
SLOT="0"
SRC_URI="https://github.com/akinomyoga/ble.sh/archive/v${PV}.tar.gz -> ${P}.tgz"

RDEPEND="
        app-shells/bash
"

S="${WORKDIR}/ble.sh-${PV}"

src_compile () {
        blesh_build_pkgver="${PV}"
        emake FULLVER="${PV}"
}

src_install () {
        emake DESTDIR="${D}" INSDIR="${D}/usr/share/ble-${PV}" install
        einstalldocs
        dosym ble-${PV} /usr/share/ble.sh
}
