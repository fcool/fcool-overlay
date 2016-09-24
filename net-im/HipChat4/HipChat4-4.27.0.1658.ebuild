# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="A Hipchat client"
HOMEPAGE="http://www.hipchat.com/"

SRC_URI_AMD64="https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client/pool/HipChat4-${PV}-Linux.deb"
#SRC_URI_X86="http://downloads.hipchat.com/linux/arch/i686/hipchat-${PV}-i686.pkg.tar.xz"
SRC_URI="
	amd64? ( ${SRC_URI_AMD64} )
"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

DEPEND="media-libs/gst-plugins-base:0.10"

S=${WORKDIR}

src_unpack() {
	ar -x ${S}/../distdir/${A} data.tar.gz
	tar xzf data.tar.gz
	rm data.tar.gz
}

src_install() {
	doins -r *
	fperms -R 0755 /opt/HipChat4/bin/ /opt/HipChat4/lib/*.bin
}
