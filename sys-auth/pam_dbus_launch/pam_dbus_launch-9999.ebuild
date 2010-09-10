# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

#inherit kde4-base
inherit pam cmake-utils 
#MY_P="kiotypo3_kde4"

#EGIT_REPO_URI="git://git.confuego.org/pamdbuslaunch.git"

DESCRIPTION="PAM module which launches a D-Bus session bus"
HOMEPAGE="http://code.confuego.org/index.php/p/pamdbuslaunch/"
DATE=$(date -Iminutes)
SRC_URI="http://code.confuego.org/index.php/p/pamdbuslaunch/source/download/master/ -> pamdbuslaunch-master.zip"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

RDEPEND="sys-libs/pam
	 sys-apps/dbus"

S="${WORKDIR}/pamdbuslaunch-master"

src_configure() {
	mycmakeargs="${mycmakeargs}"
	cmake-utils_src_configure
}

src_install() {
	dopammod "${CMAKE_BUILD_DIR}/pam_dbus_launch.so" || die "install failed"
	dodoc README
}
