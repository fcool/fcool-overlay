# Copyright
EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools

inherit pypi distutils-r1

DESCRIPTION="High performance web framework"
HOMEPAGE="https://fastapi.tiangolo.com"
SRC_URI="https://files.pythonhosted.org/packages/61/53/326977db62bf34bbdfc64acb9414e1881af7ea14e8a062fd1c11a8697616/fastapi-0.110.0.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/starlette[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
