# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KFMIN=5.101.0
QTMIN=5.15.5
inherit ecm gear.kde.org

DESCRIPTION="Client for YouTube Music"
HOMEPAGE="https://apps.kde.org/audiotube/"

LICENSE="LGPL-3+"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE="mpris semantic-desktop +vlc"

RESTRICT="test"

BDEPEND=""
DEPEND="
	dev-libs/futuresql
	dev-libs/kirigami-addons
	dev-python/pybind11
	dev-python/ytmusicapi
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	net-misc/yt-dlp
"
RDEPEND="${DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
"

src_configure() {
	ecm_src_configure
}
