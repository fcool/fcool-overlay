# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

EAPI=8
inherit autotools

DESCRIPTION="Application Layer DoS attack simulator"
HOMEPAGE="https://github.com/shekyan/slowhttptest"
SRC_URI="https://github.com/shekyan/slowhttptest/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
        econf || die "Could not configure"
}

src_install() {
        make install DESTDIR="${D}"
}
