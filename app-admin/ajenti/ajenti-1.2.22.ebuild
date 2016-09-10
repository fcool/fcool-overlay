# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
#PYTHON_DEPEND="2:2.7"
#SUPPORT_PYTHON_ABIS=1

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Web toolset for administrating servers"
HOMEPAGE="http://ajenti.org/"
SRC_URI="https://github.com/ajenti/ajenti/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="dev-python/gevent
	dev-python/greenlet
	dev-python/lxml
	dev-python/gevent-socketio
	dev-python/gevent-websocket
	dev-python/psutil
	dev-python/pillow
	dev-python/python-daemon
	dev-python/passlib
	dev-python/requests
	dev-python/reconfigure
	dev-python/python-catcher
	dev-python/python-exconsole
	dev-python/python-ldap
	dev-python/dbus-python
	dev-python/pyopenssl
	dev-lang/coffee-script
	dev-python/lesscpy"

python_compile() {
	#Build ressources (cofee-script and lesscpy involved)
	make all
	distutils-r1_python_compile
}

python_install() {

	distutils-r1_python_install --single-version-externally-managed -O1
}

