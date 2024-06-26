# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}
EGIT_COMMIT=b5984027386ec1e55c504d27f42ef40a189cdb55

DESCRIPTION="The Object Store for AI Data Infrastructure"
HOMEPAGE="https://github.com/minio/minio"
SRC_URI="https://github.com/minio/minio/archive/RELEASE.${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://digital-competence.de/fcool-overlay/${PN}-${PV}-vendor.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${PN}-RELEASE.${MY_PV}"

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
	dobin minio
	dodoc -r README.md CONTRIBUTING.md docs
}
