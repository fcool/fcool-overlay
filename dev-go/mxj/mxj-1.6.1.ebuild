# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/clbanning/mxj

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~arm ~arm64"
	EGIT_COMMIT=v${PV}
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Decode / encode XML to/from map[string]interface{} (or JSON); extract values with dot-notation paths and wildcards. Replaces x2j and j2x packages."
HOMEPAGE="https://github.com/cpuguy83/go-md2man"
LICENSE="MIT"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND=""
