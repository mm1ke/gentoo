# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ASPELL_LANG="Italian"
ASPELL_VERSION=6
MY_PV="${PV#*.}"
MY_P="${PN/aspell/aspell"${ASPELL_VERSION}"}-${PV%%.*}.${MY_PV//./-}"

inherit aspell-dict-r1

SRC_URI="https://downloads.sourceforge.net/linguistico/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
