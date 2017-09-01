# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils readme.gentoo-r1 versionator

DESCRIPTION="Intelligent Python IDE with unique code assistance and analysis"
HOMEPAGE="http://www.jetbrains.com/pycharm/"
SLOT="$(get_version_component_range 1-2)"
PN_SLOTTED="${PN}${SLOT}"
if [ "$(get_version_component_range 3)" = "0" ]; then
        MY_PV="$(get_version_component_range 1-2)"
else
        MY_PV="$(get_version_component_range 1-3)"
fi

BUILD_NUMBER="$(get_version_component_range 4-5)"

SRC_URI="http://download.jetbrains.com/python/${PN}-${MY_PV}.tar.gz"

LICENSE="PyCharm_Academic PyCharm_Classroom PyCharm PyCharm_OpenSource PyCharm_Preview"

KEYWORDS="~amd64 ~x86"
IUSE="system-jre"

RDEPEND="system-jre? ( >=virtual/jre-1.8 )
	 dev-python/pip"
DEPEND=""

RESTRICT="mirror strip"

QA_PREBUILT="opt/${PN}/bin/fsnotifier
	opt/${PN}/bin/fsnotifier64
	opt/${PN}/bin/fsnotifier-arm
	opt/${PN}/bin/libyjpagent-linux.so
	opt/${PN}/bin/libyjpagent-linux64.so"

MY_PN=${PN/-professional/}
S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_prepare() {
	default

	if use system-jre ; then rm -rvf jre || die ; fi
}

src_install() {
	insinto /opt/${PN_SLOTTED}
	doins -r *

	fperms a+x /opt/${PN_SLOTTED}/bin/{pycharm.sh,fsnotifier{,64},inspect.sh}

	dosym /opt/${PN_SLOTTED}/bin/pycharm.sh /usr/bin/${PN_SLOTTED}
	newicon "bin/${MY_PN}.png" ${PN_SLOTTED}.png
	make_desktop_entry ${PN_SLOTTED} "${PN_SLOTTED}" "${PN_SLOTTED}"

#	readme.gentoo_create_doc
}
