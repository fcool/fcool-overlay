# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit multilib git-r3

DESCRIPTION="Convert html to pdf (and various image formats) using webkit"
HOMEPAGE="https://github.com/wkhtmltopdf/wkhtmltopdf"
EGIT_REPO_URI="https://github.com/wkhtmltopdf/wkhtmltopdf.git"
EGIT_COMMIT="124a9dc9eaf7e6b365d84a219c3e427af295a148"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl iconv glib icu tiff"

RDEPEND="sys-libs/zlib
	virtual/jpeg
	app-arch/xz-utils
	media-libs/fontconfig
        media-libs/freetype:2
        media-libs/libpng:0=
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libICE
        x11-libs/libSM
        x11-libs/libX11
        x11-libs/libXcursor
        x11-libs/libXext
        x11-libs/libXfixes
        x11-libs/libXi
        x11-libs/libXrandr
        x11-libs/libXrender
	glib? ( dev-libs/glib:2 )
        icu? ( >=dev-libs/icu-49:= )
	tiff? ( media-libs/tiff:0 )"
DEPEND="${RDEPEND}"

# Tests pull data from websites and require a
# special patched version of qt so many fail
RESTRICT="test"

qt_use() {
        use "$1" && echo "${3:+-$3}-${2:-$1}" || echo "-no-${2:-$1}"
}

src_configure() {
	mkdir -p ${S}/work/{app,wkhtmltox,qt}
	cd ${S}/work/qt
	#TODO: Check if libtiff and libmng could be used
	#TODO: What about fontconfig?!
	#TODO: Glib seems to be included, too
	${S}/qt/configure --prefix=${S}/work/qt -opensource -confirm-license -fast -release -static \
		-graphicssystem raster -webkit -exceptions \
		-xmlpatterns -system-zlib -system-libpng -system-libjpeg -no-libmng -no-accessibility \
		-no-stl -no-qt3support -no-phonon -no-phonon-backend -no-opengl -no-declarative -no-script \
		-no-scripttools -no-sql-ibase -no-sql-mysql -no-sql-odbc -no-sql-psql -no-sql-sqlite -no-sql-sqlite2 \
		-no-multimedia -nomake demos -nomake docs -nomake examples -nomake tools -nomake tests -nomake translations \
		-silent -xrender -largefile -no-rpath -no-dbus -no-nis -no-cups -no-pch -no-gtkstyle \
		-no-nas-sound -no-sm -no-xshape -no-xinerama -no-xcursor -no-xfixes -no-xrandr -no-mitshm -no-xinput \
		-no-xkb -no-gstreamer -D ENABLE_VIDEO=0 -no-openvg -no-xsync -no-audio-backend -no-avx \
		-no-neon \
		-fontconfig -system-freetype \
		$(qt_use glib) \
                $(qt_use iconv) \
		$(use ssl && echo -openssl-linked || echo -no-openssl) \
		$(qt_use tiff libtiff system)	
}

src_compile() {
	WKHTMLTOX_VERSION=${PV}
	cd ${S}/work/qt
	emake
	cd ${S}/work/app
	../qt/bin/qmake ../../wkhtmltopdf.pro
	emake
}

src_install() {
	dobin ${S}/work/app/bin/wkhtmlto*
	dolib ${S}/work/app/bin/libwkhtmltox*.so.*
	insinto /usr/include/wkhtmltox-${PV}
	doins ${S}/include/wkhtmltox/*.h
	doins ${S}/include/wkhtmltox/dll*.inc
}
