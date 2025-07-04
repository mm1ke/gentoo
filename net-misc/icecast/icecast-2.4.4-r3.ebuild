# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd

DESCRIPTION="Opensource alternative to shoutcast that supports mp3, ogg and aac streaming"
HOMEPAGE="https://www.icecast.org/"
SRC_URI="https://downloads.xiph.org/releases/icecast/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="kate +speex selinux +ssl +theora +yp"

#Although there is a --with-ogg and --with-orbis configure option, they're
#only useful for specifying paths, not for disabling.
DEPEND="
	acct-group/icecast
	acct-user/icecast
	dev-libs/libxml2:=
	dev-libs/libxslt
	media-libs/libogg
	media-libs/libvorbis
	kate? ( media-libs/libkate )
	speex? ( media-libs/speex )
	ssl? (
		dev-libs/openssl:0=
	)
	theora? ( media-libs/libtheora:= )
	yp? ( net-misc/curl )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-icecast )
"

PATCHES=(
	# bug #368539
	"${FILESDIR}"/${PN}-2.3.3-libkate.patch
	# bug #430434
	"${FILESDIR}"/${PN}-2.3.3-fix-xiph_openssl.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--sysconfdir=/etc/icecast2
		$(use_enable kate)
		$(use_enable yp)
		$(use_with speex)
		$(use_with ssl openssl)
		$(use_with theora)
		$(use_with yp curl)
	)
	econf "${myeconfsrgs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS README TODO HACKING NEWS conf/icecast.xml.dist
	docinto html
	dodoc doc/*.html

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	insinto /etc/icecast2
	doins "${FILESDIR}"/icecast.xml
	fperms 600 /etc/icecast2/icecast.xml

	dodir /etc/logrotate.d
	insopts -m0644
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	diropts -m0764 -o icecast -g icecast
	dodir /var/log/icecast
	keepdir /var/log/icecast
	rm -r "${ED}"/usr/share/doc/icecast || die
}

pkg_postinst() {
	touch "${ROOT}"/var/log/icecast/{access,error}.log
	chown icecast:icecast "${ROOT}"/var/log/icecast/{access,error}.log
}
