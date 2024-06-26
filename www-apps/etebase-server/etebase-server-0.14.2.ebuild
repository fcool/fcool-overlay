# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10,11,12} )

inherit python-single-r1 systemd wrapper

DESCRIPTION="The Etebase server"
HOMEPAGE="https://www.etesync.com https://github.com/etesync/server"
SRC_URI="https://github.com/etesync/server/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="AGPL-3"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
SLOT="0"

S="${WORKDIR}/server-${PV}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/aiofiles-23.1.0[${PYTHON_USEDEP}]
		>=dev-python/django-4.2.0[${PYTHON_USEDEP},sqlite]
		<dev-python/django-5.0.0[${PYTHON_USEDEP},sqlite]
		>=dev-python/fastapi-0.110.0[${PYTHON_USEDEP}]
		>=dev-python/httptools-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/msgpack-1.0.4[${PYTHON_USEDEP}]
		>=dev-python/pydantic-2.7.3[${PYTHON_USEDEP}]
		>=dev-python/pydantic-core-2.18.4[${PYTHON_USEDEP}]
		>=dev-python/pynacl-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/python-dotenv-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytz-2022.6[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
		>=dev-python/redis-4.4.0[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.4.0[${PYTHON_USEDEP}]
		>=dev-python/uvicorn-0.30.1[${PYTHON_USEDEP}]
		>=dev-python/uvloop-0.19.0[${PYTHON_USEDEP}]
		>=dev-python/websockets-12.0[${PYTHON_USEDEP}]
	')
	acct-user/etebase
	acct-group/etebase
"

src_prepare() {
	sed -e "s:secret.txt:${EPREFIX}/var/lib/${PN}/&:" -e "s:db.sqlite3:${EPREFIX}/var/lib/${PN}/&:" -e "s:/path/to/static:${EPREFIX}/var/lib/${PN}/static/:" -e "s:/path/to/media:${EPREFIX}/var/lib/${PN}/media/:" -i "${S}/${PN}.ini.example" || die

	default
}

src_install() {
	dodoc ChangeLog.md ${PN}.ini.example README.md
	insinto /etc/${PN}
	newins ${PN}.ini.example ${PN}.ini
	rm -r ChangeLog.md ${PN}.ini.example icon.svg LICENSE README.md .github .gitignore || die
	python_fix_shebang manage.py
	insinto /usr/$(get_libdir)/${PN}
	doins -r .
	fperms 755 /usr/$(get_libdir)/${PN}/manage.py
	make_wrapper "${PN}" "./manage.py" "${EPREFIX}/usr/$(get_libdir)/${PN}"
	sed "s/@LIBDIR@/$(get_libdir)/" "${FILESDIR}/etebase.initd" > etebase.initd || die
	sed "s/@LIBDIR@/$(get_libdir)/" "${FILESDIR}/etebase.service" > etebase.service || die
	newinitd etebase.initd etebase
	newconfd "${FILESDIR}/etebase.confd" etebase
	systemd_dounit etebase.service
	keepdir /var/lib/${PN}/static
	keepdir /var/lib/${PN}/media
	keepdir /var/log/etebase
	fowners etebase:etebase /var/lib/etebase-server/static /var/lib/etebase-server/media /var/log/etebase
}
