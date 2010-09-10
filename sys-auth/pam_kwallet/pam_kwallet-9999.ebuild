# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

KMNAME="playground/base/pam_kwallet"
KMNOMODULE=true
inherit kde4-meta pam

DESCRIPTION="PAM module which opens a KDE Wallet"
HOMEPAGE="http://websvn.kde.org/trunk/playground/base/pam_kwallet/"

KEYWORDS="~amd64 ~x86"
SLOT="0"

LICENSE="GPL-2"
IUSE="debug crypt"

RDEPEND="sys-auth/pam_dbus_launch
         crypt? ( app-crypt/qca:2 )"

src_prepare() {
  epatch "${FILESDIR}"/include.patch
  kde4-meta_src_prepare
}

src_configure() {
  mycmakeargs="${mycmakeargs} 
	       $(cmake-utils_use_with crypt QCA2)"
  use crypt && mycmakeargs="${mycmakeargs}
                -DQCA2_LIBRARIES=/usr/$(get_libdir)/qca2/libqca.so.2"

  kde4-meta_src_configure

}

src_install() {
  dopammod "${CMAKE_BUILD_DIR}/lib/pam_kwalletopener.so" || die "install failed" 
  kde4-meta_src_install
}
