# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="MailHog is an email testing tool for developers"
HOMEPAGE="https://github.com/mailhog/MailHog"

EGO_VENDOR=(
	"github.com/gorilla/pat v1.0.1"
	"github.com/gorilla/context v1.1.1"
	"github.com/gorilla/mux v1.7.4"
	"github.com/gorilla/websocket v1.4.2"
	"github.com/ian-kent/envconf c19809918c02ab33dc8635d68c77649313185275"
	"github.com/ian-kent/go-log/ v0.1"
	"github.com/ian-kent/goose c3541ea826ad9e0f8a4a8c15ca831e8b0adde58c"
	"github.com/ian-kent/linkio 97566b8728870dac1c9863ba5b0f237c39166879"
	"github.com/mailhog/data v1.0.0"
	"github.com/mailhog/http v1.0.0"
	"github.com/mailhog/MailHog-Server v1.0.0"
	"github.com/mailhog/MailHog-UI v1.0.0"
	"github.com/mailhog/mhsendmail v0.2.0"
	"github.com/mailhog/smtp v1.0.0"
	"github.com/mailhog/storage v1.0.0"
	"github.com/philhofer/fwd v1.0.0"
	"github.com/tinylib/msgp v1.1.2"
	"github.com/t-k/fluent-logger-golang v1.0.0"
	"github.com/ogier/pflag v0.0.1"
	"golang.org/x/crypto 4b2356b github.com/golang/crypto"
	"gopkg.in/mgo.v2 r2016.08.01 github.com/go-mgo/mgo"
)

#EGO_BUILD_FLAGS="-ldflags \"-X main.version ${PV}\""
EGO_BUILD_FLAGS="-o ${T}/MailHog"
EGO_PN="github.com/mailhog/MailHog"
inherit golang-build golang-vcs-snapshot

SRC_URI="https://github.com/mailhog/MailHog/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0"

src_install() {
	dobin "${T}/MailHog"
	newconfd "${FILESDIR}/MailHog.confd" MailHog
	newinitd "${FILESDIR}/MailHog.initd" MailHog
}
