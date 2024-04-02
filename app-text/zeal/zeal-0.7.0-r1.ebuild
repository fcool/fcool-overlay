# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=90ad776e83f182221cafd329f2e58cf0621ea3f1
inherit cmake xdg-utils

DESCRIPTION="Offline documentation browser inspired by Dash"
HOMEPAGE="https://zealdocs.org/"
SRC_URI="https://github.com/zealdocs/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-arch/libarchive:=
	dev-db/sqlite:3
	dev-qt/qtbase:6
	dev-qt/qtconnectivity:6
	dev-qt/qtwebchannel:6
	dev-qt/qtwebengine:6[widgets]
	x11-libs/libX11
	x11-libs/libxcb:=
	>=x11-libs/xcb-util-keysyms-0.3.9
"
RDEPEND="${DEPEND}
	x11-themes/hicolor-icon-theme
"
BDEPEND=">=kde-frameworks/extra-cmake-modules-5"

PATCHES=(
	"${FILESDIR}/0002-settings-disable-checking-for-updates-by-default.patch"
	"${FILESDIR}/1565-zeal-0.7.0-std-as-const.patch"
)

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
