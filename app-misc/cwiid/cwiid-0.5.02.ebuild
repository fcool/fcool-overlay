# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Library, input driver, and utilities for the Nintendo Wiimote"
HOMEPAGE="http://abstrakraft.org/cwiid"
SRC_URI="http://abstrakraft.org/cwiid/downloads/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~ppc64"
IUSE=""

DEPEND="sys-apps/gawk
	sys-devel/bison
	>=sys-devel/flex-2.5.33
	=x11-libs/gtk+-2*
	>=sys-kernel/linux-headers-2.6
	net-wireless/bluez-libs"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-make.patch
}

src_install() {
	make DESTDIR=${D} LDCONFIG="#ldconfig" install || die "make install failed"
}
