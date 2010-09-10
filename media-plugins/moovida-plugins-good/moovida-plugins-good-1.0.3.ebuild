# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils python

DESCRIPTION="Good plugins for Moovida media center"
HOMEPAGE="http://www.moovida.com/"
SRC_URI="http://www.moovida.com/static/download/elisa/${P}.tar.gz"

RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~ppc x86"
IUSE=""

#MAKEOPTS="-j1"

RDEPEND="!media-plugins/elisa-plugins-good
    ~media-video/moovida-${PV}"


DEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog COPYING NEWS"

S="${WORKDIR}/elisa-plugins-good-${PV}"

src_install() {
	distutils_src_install

	# __init__.py is provided by elisa
	rm ${D}/usr/$(get_libdir)/python${PYVER}/site-packages/elisa/plugins/__init__.py
}
