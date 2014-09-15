# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit multilib git-r3

DESCRIPTION="Convert html to pdf (and various image formats) using webkit"
HOMEPAGE="https://github.com/wkhtmltopdf/wkhtmltopdf"
EGIT_REPO_URI="https://github.com/wkhtmltopdf/wkhtmltopdf.git"
EGIT_COMMIT="2b560d5e4302b5524e47aa61d10c10f63af0801c"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="sys-libs/zlib
	media-libs/libpng
	virtual/jpeg
	app-arch/xz-utils"
DEPEND="${RDEPEND}"

# Tests pull data from websites and require a
# special patched version of qt so many fail
RESTRICT="test"

src_configure() {
	mkdir -p ${S}/work/{app,wkhtmltox,qt}
	cd ${S}/work/qt
	#TODO: Check if libtiff and libmng could be used
	#TODO: What about fontconfig?!
	#TODO: Glib seems to be included, too
	${S}/qt/configure --prefix=${S}/work/qt -opensource -confirm-license -fast -release -static  \
		-graphicssystem raster -webkit -exceptions \
		-xmlpatterns -system-zlib -system-libpng -system-libjpeg -no-libmng -no-libtiff -no-accessibility \
		-no-stl -no-qt3support -no-phonon -no-phonon-backend -no-opengl -no-declarative -no-script \
		-no-scripttools -no-sql-ibase -no-sql-mysql -no-sql-odbc -no-sql-psql -no-sql-sqlite -no-sql-sqlite2 \
		-no-multimedia -nomake demos -nomake docs -nomake examples -nomake tools -nomake tests -nomake translations \
		-silent -xrender -largefile -iconv -openssl -no-rpath -no-dbus -no-nis -no-cups -no-pch -no-gtkstyle \
		-no-nas-sound -no-sm -no-xshape -no-xinerama -no-xcursor -no-xfixes -no-xrandr -no-mitshm -no-xinput \
		-no-xkb -no-glib -no-gstreamer -D ENABLE_VIDEO=0 -no-openvg -no-xsync -no-audio-backend -no-avx \
		-no-neon	
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
