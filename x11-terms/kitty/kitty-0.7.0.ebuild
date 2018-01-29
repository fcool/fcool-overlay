# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/Babel/Babel-1.3-r1.ebuild,v 1.7 2014/12/07 12:01:28 ago Exp $

EAPI=5

PYTHON_COMPAT=( python{3_5,3_6} )
#inherit distutils-r1 git-r3
inherit python-r1

DESCRIPTION="A modern, hackable, featureful, OpenGL-based terminal emulator."
HOMEPAGE="https://github.com/kovidgoyal/kitty"
SRC_URI="https://github.com/kovidgoyal/kitty/archive/v${PV}.tar.gz -> ${P}.tgz"

IUSE="X wayland +imagemagick"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="${DEPEND}
	>=dev-lang/python-3.5
	X? ( >=media-libs/glfw-3.2[-wayland] )
	wayland? ( >=media-libs/glfw-3.2[wayland] )
	media-libs/fontconfig
	X? ( x11-apps/xrdb )
	X? ( x11-misc/xsel )
	>=media-libs/harfbuzz-1.5
	imagemagick? ( media-gfx/imagemagick )
	"

src_compile() {
	cd ${S};
	python_setup;
	python setup.py linux-package;
}

src_install() {
	dobin linux-package/bin/kitty;
	insinto /usr/lib/;
	doins -r linux-package/lib/kitty;
	insinto /usr/share/;
	doins -r linux-package/share/applications;
	doins -r linux-package/share/icons;
	doins -r linux-package/share/terminfo;
}
