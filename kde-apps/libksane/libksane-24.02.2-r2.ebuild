# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.115.0
QTMIN=5.15.12
inherit ecm gear.kde.org

DESCRIPTION="SANE Library interface based on KDE Frameworks"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE="kwallet"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=media-libs/ksanecore-23.08.5:5
	kwallet? ( >=kde-frameworks/kwallet-${KFMIN}:5 )
"
RDEPEND="${DEPEND}
	>=kde-apps/libksane-common-${PV}
"

# Shipped by kde-apps/libksane-common package for shared use w/ SLOT 5
ECM_REMOVE_FROM_INSTALL=(
	/usr/share/icons/hicolor/16x16/actions
)

PATCHES=( "${FILESDIR}/${PN}-24.02.0-ksanecore-23.08.patch" )

src_prepare() {
	ecm_src_prepare
	ecm_punt_po_install
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package kwallet KF5Wallet)
	)
	ecm_src_configure
}
