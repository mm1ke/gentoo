# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for Java Development Kit (JDK)"
SLOT="${PV}"
KEYWORDS="amd64 ~arm arm64 ppc64 ~riscv x86"
IUSE="headless-awt"

RDEPEND="|| (
		dev-java/openjdk-bin:${SLOT}[gentoo-vm(+),headless-awt=]
		dev-java/openjdk:${SLOT}[gentoo-vm(+),headless-awt=]
)"
