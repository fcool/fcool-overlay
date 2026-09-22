# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module desktop xdg-utils

KEYWORDS="~amd64"
DESCRIPTION="Dabri • Native Linux Speech-to-Text (STT) • Offline, Privacy-First"
HOMEPAGE="https://github.com/AshBuk/${PN}"
SRC_URI="https://github.com/AshBuk/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
SRC_URI+=" https://digital-competence.de/fcool-overlay/${PN}-${PV}-vendor.tar.xz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

BDEPEND=">=dev-lang/go-1.25.0"
DEPEND=">=app-accessibility/whisper-cpp-1.9.4
>=sys-apps/dbus-1.16.2
>=x11-misc/xdotool-4.20251130.1
>=media-sound/alsa-utils-1.2.13
>=dev-libs/libayatana-appindicator-0.5.94
>=x11-libs/libnotify-0.8.7
>=gui-apps/wl-clipboard-2.2.1
>=x11-misc/ydotool-1.0.4
"

src_compile() {
	CGO_ENABLED=1 CGO_CFLAGS="${CGO_CFLAGS} -I/usr/include/whisper.cpp" CGO_LDFLAGS="-lwhisper -lggml -lggml-cpu -lggml-vulkan" ego build -v \
        -tags systray \
        -ldflags "-s -w -X github.com/AshBuk/${PN}/internal/version.Version=${PV} -linkmode=external -extldflags '-L/usr/lib64/whisper.cpp -Wl,-rpath,/usr/lib/${PN}'" \
        -o "${PN}" \
        ./cmd/${PN}
}

src_install() {
	dobin "${S}/${PN}"
	domenu io.github.ashbuk.${PN}.desktop
	doicon -s 128x128 icons/io.github.ashbuk.${PN}.png
	doicon -s scalable icons/io.github.ashbuk.${PN}.svg
	dodoc README.md	docs/*
}


pkg_postinst() {
    # Update XDG icon cache (for /usr/share/icons)
    xdg_icon_cache_update

    # Update .desktop database
    xdg_desktop_database_update
}

pkg_postrm() {
    # Update XDG icon cache
    xdg_icon_cache_update

    # Update .desktop database
    xdg_desktop_database_update
}
