# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit ruby-fakegem

DESCRIPTION="Vagrant Cloud API Library"
HOMEPAGE="https://github.com/hashicorp/vagrant_cloud"
SRC_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/excon"
ruby_add_rdepend "dev-ruby/log4r"
ruby_add_rdepend "dev-ruby/rexml"
ruby_add_bdepend ">=dev-ruby/rake-10.4
	test? ( >=dev-ruby/webmock-3.0 )"

all_ruby_prepare() {
	sed -i -e '/rubocop/I s:^:#:' Rakefile || die
	# loosen dependencies
	sed -e '/rest-client/s/~>/>=/' -i ${PN}.gemspec \
	-e 's:require_relative ":require "./:' || die
}

