# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI=8
inherit autotools

DESCRIPTION="A library to read and write Paradox DB files"
HOMEPAGE="http://pxlib.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/pxlib/${PN}/${PV}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"
IUSE=""

RDEPEND="dev-db/pxlib"
DEPEND="${RDEPEND}"

src_configure() {
	export DOC_TO_MAN="/usr/bin/docbook2man"
	LDFLAGS=-lm econf || die "Could not configure"
}

src_compile() {
	emake || die "Error building ${PN}"
}

src_install() {
	make install DESTDIR="${D}"
}
