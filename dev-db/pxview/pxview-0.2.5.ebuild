# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

EAPI=6
inherit autotools

DESCRIPTION="A library to read and write Paradox DB files"
HOMEPAGE="http://pxlib.sourceforge.net/"
#http://downloads.sourceforge.net/project/pxlib/pxview/0.2.5/pxview_0.2.5.orig.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fpxlib%2Ffiles%2Fpxview%2F0.2.5%2F&ts=1371465320&use_mirror=netcologne
#http://downloads.sourceforge.net/project/pxlib/pxview/0.2.5/pxview-0.2.5.orig.tar.gz?download&failedmirror=jaist.dl.sourceforge.net
SRC_URI="mirror://sourceforge/project/pxlib/${PN}/${PV}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"
IUSE=""

RDEPEND="dev-db/pxlib"
DEPEND="${RDEPEND}"

src_configure() {
	LDFLAGS=-lm econf || die "Could not configure"
}

src_compile() {
	emake || die "Error building ${PN}"

	# Manually build the docs since it seems the autoconf system+Makefile
	# requires docbook-to-man and not docbook2man (which works slightly
	# different).  Additionally the sgml files seems to be broken, having
	# the page names in all upper case instead of case-sensitive (eg, PX_close).
	einfo "Building manpages"
	cd doc
	for i in *.sgml; do
		pagename=$(basename "$i" .sgml)
		ucase_pagename=$(echo "${pagename}" | tr '[:lower:]' '[:upper:]')
		sed -i -e "s:${ucase_pagename}:${pagename}:" "$i"
		/usr/bin/docbook2man "$i"
	done
}

src_install() {
	make install DESTDIR="${D}"
	doman doc/PX_*.[1-8]
}
