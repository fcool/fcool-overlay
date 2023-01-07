# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="An LDAP3 auth provider for Synapse"
HOMEPAGE="
	https://github.com/matrix-org/matrix-synapse-ldap3
	https://pypi.org/project/matrix-synapse-ldap3/
"
SRC_URI="
	https://github.com/matrix-org/matrix-synapse-ldap3/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

S="${WORKDIR}/matrix-synapse-ldap3-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64"

RDEPEND="
	>=dev-python/ldap3-2.8[${PYTHON_USEDEP}]
	>=dev-python/twisted-15.1.0[${PYTHON_USEDEP}]
	dev-python/service_identity[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
