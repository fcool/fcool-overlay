# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils versionator fdo-mime

SLOT="2016.2"
PN_SLOTTED="${PN}${SLOT}"
MY_PV="$(get_version_component_range 1-2)"
BUILD_NUMBER="$(get_version_component_range 4-5)"

DESCRIPTION="Idea is a commercial, cross-platform IDE"
HOMEPAGE="https://www.jetbrains.com/idea"
LICENSE="IDEA || ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
SRC_URI="https://download.jetbrains.com/idea/ideaIU-${MY_PV}.tar.gz"

KEYWORDS="amd64"
RESTRICT="mirror strip"
IUSE="system-jre"

RDEPEND="system-jre? ( >=virtual/jre-1.8 )"

src_unpack() {
	default

	cd idea-IU-*/ || die
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
	fperms a+x "${install_dir}/bin/"{${PN}.sh,fsnotifier{,64,-arm}}
	use system-jre || chmod a+x "${D}/${install_dir}"/jre/jre/bin/*

	dosym "${install_dir}/bin/${PN}.sh" "/usr/bin/${PN_SLOTTED}"

	newicon -s 256 "bin/${PN}.png" "${PN_SLOTTED}.png"

	make_desktop_entry_args=(
		"${PN_SLOTTED} %U"					# exec
		"IDEA ${SLOT}"						# name
		"${PN_SLOTTED}"						# icon
		"Development;IDE;WebDevelopment"	# categories
	)
	make_desktop_entry_extras=( # MUST end with semicolon
		"MimeType=text/x-php;text/html;"
	)
	make_desktop_entry "${make_desktop_entry_args[@]}" "$( printf '%s\n' "${make_desktop_entry_extras[@]}" )"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}"/etc/sysctl.d || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}"/etc/sysctl.d/30-idea-inotify-watches.conf || die
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}
