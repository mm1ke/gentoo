# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Divides large result sets into pages for easier browsing"
HOMEPAGE="
	https://github.com/Pylons/paginate/
	https://pypi.org/project/paginate/
"
SRC_URI="
	https://github.com/Pylons/paginate/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		python3.13)
			;&
		python3.12)
			EPYTEST_DESELECT+=(
				# these tests assume that dict is not sliceable
				# https://github.com/Pylons/paginate/issues/19
				tests/test_paginate.py::test_wrong_collection
				tests/test_paginate.py::TestCollectionTypes::test_unsliceable_sequence3
			)
			;;
	esac

	epytest
}
