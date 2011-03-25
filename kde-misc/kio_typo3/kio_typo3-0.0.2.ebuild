# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit kde4-base

MY_P="kiotypo3_kde4"

#ESVN_REPO_URI="https://kiotypo3.svn.sourceforge.net/svnroot/kiotypo3/kio_typo3/trunk/"
#ESVN_PROJECT="kio_typo3"
#ESVN_FETCH_CMD="svn checkout"

DESCRIPTION="KIO-Slave for the Typo3-CMS system"
HOMEPAGE="http://kiotypo3.sourceforge.net/"
SRC_URI="mirror://sourceforge/kiotypo3/kiotypo3_kde_4.x/kiotypo3_kde4_${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="1"
IUSE="debug"

RDEPEND="net-misc/curl"

S="${WORKDIR}/kiotypo3_kde4"

src_configure() {
        mycmakeargs="${mycmakeargs}"
        kde4-base_src_configure
}

