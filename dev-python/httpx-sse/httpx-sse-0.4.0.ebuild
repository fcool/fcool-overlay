# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

SRC_URI="https://files.pythonhosted.org/packages/source/h/httpx-sse/httpx-sse-0.4.0.tar.gz"
S="${WORKDIR}/httpx-sse-0.4.0"

DESCRIPTION="Consume Server-Sent Event (SSE) messages with HTTPX"
HOMEPAGE="https://github.com/florimondmanca/httpx-sse"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
