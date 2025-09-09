# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..13} )

inherit distutils-r1

DESCRIPTION="Certbot plugin enabling dns-01 challenge on the Hetzner DNS API"
HOMEPAGE="
	https://github.com/ctrlaltcoop/certbot-dns-hetzner
	https://pypi.org/project/certbot-dns-hetzner
"
SRC_URI="
	https://github.com/ctrlaltcoop/certbot-dns-hetzner/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64"

# TODO: as long as we do not support python2.7 this is fine.
# If we would need to support python 2 we had another dep: dev-python/parsedatetime

RDEPEND=">=dev-python/dns-lexicon-3.11.6
    >=app-crypt/certbot-2.0.0
    dev-python/requests
    dev-python/requests-mock
"

distutils_enable_tests unittest
