EAPI=6

inherit eutils meson fdo-mime gnome2-utils xdg-utils

DESCRIPTION="Manage your FRITZ!Box or compatible router"
HOMEPAGE="https://www.tabos.org/"
SRC_URI="https://git.krueger-it.net/tabos.org/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="GPL2"
SLOT=0
KEYWORDS="~x86 ~amd64"
S="${WORKDIR}/${PN}-v${PV}"

IUSE="evo +appindicator"
#TODO: Bad design: Evo ist automagic! (as are several other, appindicator for example)

DEPEND="app-text/ghostscript-gpl
    sys-devel/gettext
    dev-cpp/gtkmm:3.0
    net-libs/libsoup:2.4
    net-libs/librm
    appindicator? ( dev-libs/libappindicator:3 )
    dev-libs/glib:2
    >=media-libs/tiff-4.0
    app-text/poppler[cxx]
    evo? ( >=mail-client/evolution-3.22 )"


RDEPEND="$DEPEND"

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
	xdg_desktop_database_update

        #TODO: Add faxinstall, maybe from provided script
        elog "To use cups as a fax driver you have to run"
	elog "lpadmin -p Roger-Router-Fax -m drv:///sample.drv/generic.ppd -v socket://localhost:9100/ -E -o PageSize=A4"
}
