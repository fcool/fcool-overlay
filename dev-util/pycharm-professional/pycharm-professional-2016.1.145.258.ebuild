# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils versionator fdo-mime

SLOT="2016.1"
PN_SLOTTED="${PN}${SLOT}"
MY_PV="$(get_version_component_range 1-2)"
BUILD_NUMBER="$(get_version_component_range 3-4)"

DESCRIPTION="PyCharm is a commercial, cross-platform IDE for Python"
HOMEPAGE="https://www.jetbrains.com/pycharm"
LICENSE="IDEA || ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
SRC_URI="https://download.jetbrains.com/python/pycharm-professional-${MY_PV}.tar.gz"

KEYWORDS="amd64"
RESTRICT="mirror strip"
IUSE="system-jre"

DEPEND="!dev-util/pycharm-community"
RDEPEND="system-jre? ( >=virtual/jre-1.8 )"

src_unpack() {
	default

	cd pycharm-*/ || die
	S="$PWD"
}

src_prepare() {
	default

	if use system-jre ; then rm -rvf jre || die ; fi
}

src_install() {
	local install_dir="/opt/${PN_SLOTTED}"

	insinto "${install_dir}"
	doins -r .
	# globbing doesn't work with `fperms()`'
	fperms a+x "${install_dir}/bin/"{pycharm.sh,fsnotifier{,64,-arm}}
	use system-jre || chmod a+x "${D}/${install_dir}"/jre/jre/bin/*

	dosym "${install_dir}/bin/pycharm.sh" "/usr/bin/${PN_SLOTTED}"

	newicon -s 256 "bin/pycharm.png" "${PN_SLOTTED}.png"

	make_desktop_entry_args=(
		"${PN_SLOTTED} %U"					# exec
		"PyCharm Professional ${SLOT}"				# name
		"${PN_SLOTTED}"						# icon
		"Development;IDE;WebDevelopment"	# categories
	)
	make_desktop_entry_extras=( # MUST end with semicolon
		"MimeType=text/x-python;text/html;"
	)
	make_desktop_entry "${make_desktop_entry_args[@]}" "$( printf '%s\n' "${make_desktop_entry_extras[@]}" )"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}"/etc/sysctl.d || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}"/etc/sysctl.d/30-idea-inotify-watches.conf || die
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}
