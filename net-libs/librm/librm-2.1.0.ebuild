EAPI=6

inherit eutils meson gnome2-utils

DESCRIPTION="Router Manager library"
HOMEPAGE="https://www.tabos.org/"
SRC_URI="https://gitlab.com/tabos/librm/-/archive/v${PV}/librm-v${PV}.tar.gz"
LICENSE="GPL-2"
SLOT=0
KEYWORDS="~x86 ~amd64"
S="${WORKDIR}/${PN}-v${PV}"
IUSE="doc test +libsecret"

DEPEND="dev-libs/glib:2
    x11-libs/gdk-pixbuf:2
    net-libs/libsoup:2.4
    media-libs/speex
    dev-libs/libxml2:2
    >=media-libs/tiff-4.0
    media-libs/spandsp
    >=dev-libs/json-glib-1.2
    libsecret? ( >=app-crypt/libsecret-0.18 )
    
    media-libs/libsndfile
    net-libs/gupnp
    net-libs/gssdp
    net-libs/libcapi
"
    
RDEPEND="$DEPEND"

src_configure() {
        local emesonargs=(
                -Denable-documentation=$(usex doc true false)
                -Denable-secret=$(usex libsecret true false)
        )
        meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
}
