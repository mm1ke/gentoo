# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SHLOMIF
DIST_VERSION=0.17029
inherit perl-module

DESCRIPTION="Error/exception handling in an OO-ish way"

LICENSE+=" MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Scalar-List-Utils
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.880.0
	)
"
