# Copyright 1999-2007 Warez Incorporated
# Distributed under the terms of the GNU General Public License v2
# $Header: $

: ${EHG_REPO_URI:=${VDR_SC_REPO_URI:-http://85.17.209.13:6100/sc}}

RESTRICT="mirror strip"

inherit vdr-plugin mercurial

DESCRIPTION="VDR plugin: softcam"
HOMEPAGE="http://vdr.bluox.org"
SRC_URI=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="firmware"

S="${WORKDIR}/${EHG_REPO_URI##*/}"


DEPEND=">=media-video/vdr-1.6.0
        dev-libs/openssl
        firmware? ( media-tv/sc-dvb-firmware )"

src_unpack() {
    mercurial_src_unpack
    cd "${S}"
#    vdr-plugin_src_unpack
    vdr_add_local_patch
    vdr_patchmakefile
    vdr_i18n
    fix_vdr_libsi_include systems/viaccess/tps.c
    fix_vdr_libsi_include systems/viaccess/viaccess.c

    sed -i Makefile.system \
        -e "s:^LIBDIR.*$:LIBDIR = ${S}:"

    sed -i Makefile \
        -e "s:/include/vdr/config.h:/config.h:" \
        -e "s:-march=\$(CPUOPT)::" \
        -e "s:\$(CSAFLAGS):\$(CXXFLAGS):" \
        -e "s:ci.c:ci.h:" \
        -e "s:include/vdr/i18n.h:i18n.h:"
}

src_install() {
    vdr-plugin_src_install

    insinto usr/$(get_libdir)/vdr/plugins
    doins ${S}/libsc*

    diropts -gvdr -ovdr
    keepdir /etc/vdr/plugins/sc
}
