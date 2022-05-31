# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit multilib git-r3 flag-o-matic

DESCRIPTION="Convert html to pdf (and various image formats) using webkit"
HOMEPAGE="https://github.com/wkhtmltopdf/wkhtmltopdf"
EGIT_REPO_URI="https://github.com/wkhtmltopdf/wkhtmltopdf.git"
EGIT_COMMIT="a8ba57e1260a0430e0e9e53da05211beef4cbbc3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl iconv glib tiff"

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
	tiff? ( media-libs/tiff:0 )"
DEPEND="${RDEPEND}
        <sys-devel/gcc-9"

# Tests pull data from websites and require a
# special patched version of qt so many fail
RESTRICT="test"

PATCHES=(
        "${FILESDIR}/4.8.2-javascriptcore-x32.patch"
)

qt_use() {
        use "$1" && echo "${3:+-$3}-${2:-$1}" || echo "-no-${2:-$1}"
}

src_prepare() {
	default
	append-cxxflags -std=gnu++98
	sed -i -e "s:CXXFLAGS.*=:CXXFLAGS=${CXXFLAGS} :" \
                -e "s:LFLAGS.*=:LFLAGS=${LDFLAGS} :" \
                qt/qmake/Makefile.unix || die "sed qmake/Makefile.unix failed"

        # bug 427782
        sed -i -e '/^CPPFLAGS\s*=/ s/-g //' \
                qt/qmake/Makefile.unix || die "sed CPPFLAGS in qmake/Makefile.unix failed"
        sed -i -e 's/setBootstrapVariable QMAKE_CFLAGS_RELEASE/QMakeVar set QMAKE_CFLAGS_RELEASE/' \
                -e 's/setBootstrapVariable QMAKE_CXXFLAGS_RELEASE/QMakeVar set QMAKE_CXXFLAGS_RELEASE/' \
                qt/configure || die "sed configure setBootstrapVariable failed"

        sed -i -e 's:5\*|:[5-9]*|:' \
                qt/configure || die "sed gcc version failed"

}

src_configure() {
	mkdir -p ${S}/work/{app,wkhtmltox,qt}

	#CXXFLAGS="${CXXFLAGS} -fpermissive -std=c++11"

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
		-no-icu \
                $(qt_use iconv) \
		$(use ssl && echo -openssl-linked || echo -no-openssl) \
		$(qt_use tiff libtiff system)

#	cd src/3rdparty/webkit/Source
4#	cd ${S}/work/qt
#	emake qmake

#	sed -i -e 's:std=c++11:std=c++98:' */qt/Makefile* Makefile */Makefile || \
#		 die "Sed for qt/src/3rdparty/webkit/Source/WebKit/qt/Makefile failed"



}

src_compile() {
	WKHTMLTOX_VERSION=${PV}
	cd ${S}/work/qt
	emake
        cd ${S}/work/qt/src/3rdparty/webkit/Source/WebKit/qt
        emake
	cd ${S}/work/app
	../qt/bin/qmake ../../wkhtmltopdf.pro
	emake
}

src_install() {
	dobin ${S}/work/app/bin/wkhtmlto*
	dolib ${S}/work/app/bin/libwkhtmltox*.so.*
	insinto /usr/include/wkhtmltox
	doins ${S}/src/lib/*.h
	doins ${S}/src/lib/*.inc
}
