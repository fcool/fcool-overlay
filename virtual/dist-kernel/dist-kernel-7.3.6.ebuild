# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual to depend on any Distribution Kernel"
SLOT="0/${PVR}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# DELTA: tuxedo first, the 7.2.x ebuilds had it last.  Nothing installed
# matches this version yet, so portage takes the first alternative that has
# an ebuild on offer, and the gentoo tree does have 7.3.6 for the other
# four -- pulling gentoo-kernel in, which tuxedo-kernel then soft blocks.
RDEPEND="
	|| (
		~sys-kernel/tuxedo-kernel-${PV}
		~sys-kernel/gentoo-kernel-${PV}
		~sys-kernel/gentoo-kernel-bin-${PV}
		~sys-kernel/vanilla-kernel-${PV%_p*}
		~sys-kernel/gentoo-kernel-modprep-${PV}
	)
"
