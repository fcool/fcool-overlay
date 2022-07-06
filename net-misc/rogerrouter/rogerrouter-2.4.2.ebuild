EAPI=7

inherit eutils meson gnome2-utils xdg-utils

DESCRIPTION="Manage your FRITZ!Box or compatible router"
HOMEPAGE="https://www.tabos.org/"
SRC_URI="https://gitlab.com/tabos/${PN}/-/archive/${PV}/${PN}-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT=0
KEYWORDS="~x86 ~amd64"
#S="${WORKDIR}/${PN}-v${PV}"

IUSE="evo +appindicator"
#TODO: Bad design: Evo ist automagic! (as are several other, appindicator for example)

DEPEND="app-text/ghostscript-gpl
    sys-devel/gettext
    dev-cpp/gtkmm:3.0
    net-libs/libsoup:2.4
    >=net-libs/librm-2.2.3
    appindicator? ( dev-libs/libappindicator:3 )
    dev-libs/glib:2
    >=media-libs/tiff-4.0
    app-text/poppler[cxx]
    evo? ( >=mail-client/evolution-3.22 )
    >=gui-libs/libhandy-0.90.0"


RDEPEND="$DEPEND"

pkg_postinst() {
        xdg_mimeinfo_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
	xdg_desktop_database_update

        #TODO: Add faxinstall, maybe from provided script
        elog "To use cups as a fax driver you have to run"
	elog "lpadmin -p Roger-Router-Fax -m drv:///sample.drv/generic.ppd -v socket://localhost:9100/ -E -o PageSize=A4"
}
