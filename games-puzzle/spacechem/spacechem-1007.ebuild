# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/darwinia-demo/darwinia-demo-1.3.0.ebuild,v 1.9 2009/05/22 21:47:48 mr_bones_ Exp $

EAPI="2"

inherit eutils games

DESCRIPTION="A design-based puzzle game from Zachtronics Industries."
HOMEPAGE="http://www.spacechemthegame.com/"

MY_PN="SpaceChem"
MY_P="${MY_PN}-${PV}"
#SRC_URI="http://collinarnold.net/zachtronics/${MY_P}.tar.gz"
SRC_URI="http://store.zachtronicsindustries.com/download/spacechem/linux/13f3a0ee5ac64ac649908d6689e7606fd4790dad66b847c9813d07983ad90513/SpaceChem-1007.tar.gz" 
DOWNLOAD_URL="http://store.zachtronicsindustries.com/download/spacechem/13f3a0ee5ac64ac649908d6689e7606fd4790dad66b847c9813d07983ad90513"

LICENSE="spacechem"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="strip fetch"

RDEPEND=">=dev-lang/mono-2
         x11-misc/xclip
         media-libs/libsdl
         media-libs/sdl-mixer
         media-libs/sdl-image
	"

S=${WORKDIR}

src_unpack() {
	unpack "${A}"
	cd "${S}"
	unpack "./${MY_PN}-i386.deb"
	unpack ./data.tar.gz
}

src_install() {
	dodir "/${GAMES_PREFIX_OPT}/${PN}/"
	cd "${S}/opt/zachtronicsindustries/spacechem/"

	cp -R . "${D}/${GAMES_PREFIX_OPT}/${PN}"

	newicon icon.png "${PN}.png"
	games_make_wrapper "${PN}" "mono SpaceChem.exe" "${ROOT}/${GAMES_PREFIX_OPT}/${PN}/"
	make_desktop_entry "${PN}" "SpaceChem" "${PN}" "Game;LogicGame;" "Comment=Solve design-based challenges in this game from Zachtronics Industries"

	prepgamesdirs
}
