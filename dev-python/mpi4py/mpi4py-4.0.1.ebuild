# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
inherit distutils-r1 pypi

DESCRIPTION="Message Passing Interface for Python"
HOMEPAGE="
	https://github.com/mpi4py/mpi4py
	https://pypi.org/project/mpi4py/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	virtual/mpi
"
DEPEND="${RDEPEND}"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	>=dev-build/meson-1.0.0
	virtual/mpi
"

PATCHES=(
	"${FILESDIR}/${PN}-4-use-mesonpy.patch"
	"${FILESDIR}/${PN}-4-mpich-no-fortran-fix.patch"
)

python_prepare_all() {
	# not needed on install
	rm -vr docs/source || die
	rm test/test_pickle.py || die # disabled by Gentoo-bug #659348
	distutils-r1_python_prepare_all
}

python_compile() {
	export CC=mpicc
	distutils-r1_python_compile
}

python_test() {
	echo "Beginning test phase"
	local -x PYTHONPATH="${BUILD_DIR}/install$(python_get_sitedir)"

	# python want's all arguments as separate strings
	local mpi_opts=(
		"-n" "1"
	)
	if has_version sys-cluster/openmpi; then
		local mpi_opts+=(
			"--use-hwthread-cpus"
			# allow test in systemd-nspawn container
			"--mca" "btl" "tcp,self"
			"--mca" "oob_tcp_if_include" "lo"
			# disable openmpi OSC UCX component
			# https://github.com/open-mpi/ompi/issues/12517
			"--mca" "osc" "^ucx"
		)
	fi
	mpiexec \
		"${mpi_opts[@]}" \
		"${PYTHON}" -B -v ./test/runtests.py -v ||
		die "Testsuite failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	use examples && local DOCS=( demo )
	distutils-r1_python_install_all
}
