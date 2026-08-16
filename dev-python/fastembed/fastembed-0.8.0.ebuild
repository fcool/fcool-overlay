# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Fast, light, accurate library built for retrieval embedding generation"
HOMEPAGE="
	https://github.com/qdrant/fastembed
	https://pypi.org/project/fastembed/
"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=sci-ml/huggingface_hub-0.20.0
	<sci-ml/huggingface_hub-2.0.0
	>=dev-python/loguru-0.7.0[${PYTHON_USEDEP}]
	<dev-python/loguru-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/mmh3-4.1.0[${PYTHON_USEDEP}]
	<dev-python/mmh3-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-2.3.0[${PYTHON_USEDEP}]
	>=sci-libs/onnxruntime-1.24.2[python,${PYTHON_USEDEP}]
	>=dev-python/pillow-12.0.0[${PYTHON_USEDEP}]
	<dev-python/pillow-13.0.0[${PYTHON_USEDEP}]
	>=dev-python/py-rust-stemmers-0.1.0[${PYTHON_USEDEP}]
	<dev-python/py-rust-stemmers-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
	<dev-python/requests-3.0.0[${PYTHON_USEDEP}]
	>=sci-ml/tokenizers-0.15.0
	<sci-ml/tokenizers-1.0.0
	>=dev-python/tqdm-4.66.0[${PYTHON_USEDEP}]
	<dev-python/tqdm-5.0.0[${PYTHON_USEDEP}]
"

BDEPEND="
	>=dev-python/setuptools-68.0[${PYTHON_USEDEP}]
"
