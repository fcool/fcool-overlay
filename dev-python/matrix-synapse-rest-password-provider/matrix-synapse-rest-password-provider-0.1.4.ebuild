# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..13} )

inherit distutils-r1

DESCRIPTION="Password Provider for Synapse fetching data from a REST endpoint"
HOMEPAGE="
	https://github.com/ma1uta/matrix-synapse-rest-password-provider
	https://pypi.org/project/ma1uta/matrix-synapse-rest-password-provider
"
SRC_URI="
	https://github.com/ma1uta/matrix-synapse-rest-password-provider/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

S="${WORKDIR}/matrix-synapse-rest-password-provider-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64"

RDEPEND=""

distutils_enable_tests unittest
