# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYWORDS="amd64 arm64"
DESCRIPTION="opencode sandbox"
LICENSE="MIT"
SLOT="0"
SRC_URI="https://git.digital-competence.de/digital-competence/${PN}/archive/${PV}.tar.gz -> ${P}.tgz"
HOMEPAGE="https://git.digital-competence.de/digital-competence/${PN}"

RDEPEND="sys-apps/bubblewrap"

S="${WORKDIR}/${PN}"

src_install () {
        dobin opencode-sandbox
        einstalldocs
}
