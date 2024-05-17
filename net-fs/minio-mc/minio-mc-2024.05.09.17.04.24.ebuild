# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}
MY_PN=mc
EGIT_COMMIT=fdb36acbb1d793b6cca622a55e6292f0d52309f0

DESCRIPTION="Simple | Fast tool to manage MinIO clusters ☁️"
HOMEPAGE="https://github.com/minio/mc"
SRC_URI="https://github.com/minio/mc/archive/RELEASE.${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://digital-competence.de/fcool-overlay/${PN}-${PV}-vendor.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="noconflict"

S="${WORKDIR}/${MY_PN}-RELEASE.${MY_PV}"

RDEPEND="!noconflict? ( !!app-misc/mc )"

src_prepare() {
	export MINIO_RELEASE="RELEASE"
	default
	sed -i \
		-e "s/commitTime().Format(time.RFC3339)/\"${MY_PV}\"/" \
		-e "s/+ commitID()/+ \"${EGIT_COMMIT}\"/" \
		buildscripts/gen-ldflags.go || die
}

src_compile() {
	export CGO_ENABLED=0
	ego build -tags kqueue -trimpath --ldflags "$(go run buildscripts/gen-ldflags.go $MY_PV)" -o ${PN} || die
}

src_install() {
	BINNAME=minio-mc
	if !use noconflict ; then
		BINNAME=mc
		mv minio-mc mc
	fi
	dobin $BINNAME
	dodoc -r README.md CONTRIBUTING.md
}
