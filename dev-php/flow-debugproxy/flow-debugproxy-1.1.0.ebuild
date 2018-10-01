# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
inherit golang-build

DESCRIPTION="Takes care of the mapping between your PHP file and Flow proxy classes"
HOMEPAGE="https://github.com/dfeyer/flow-debugproxy/"
LICENSE="LGPL-3"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""
DEPEND="dev-go/cli dev-go/ansi dev-go/mxj"
RDEPEND="${DEPEND}"

EGO_PN="github.com/dfeyer/flow-debugproxy"

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	inherit golang-vcs-snapshot
	SRC_URI="https://github.com/dfeyer/flow-debugproxy/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

src_install() {
	dobin flow-debugproxy
}


#src_compile() {
#	GOPATH="${S}" go build -v -work 
#	echo "$@"
#        "$@" || die
#}

#src_install() {
#	set -- env GOPATH="${WORKDIR}/${P}:${EPREFIX}/usr/lib/go-gentoo" \
#                go install -v -work -x "${EGO_PN}/..."
#        echo "$@"
#        "$@" || die
#        insinto /usr/lib/go-gentoo
#        insopts -m0644 -p # preserve timestamps for bug 551486
#        doins -r pkg
#	dobin bin/*
#}
