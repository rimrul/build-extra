#!/bin/sh

die () {
	echo "$*" >&2
	exit 1
}

test -n "$ARCH" &&
test -n "$BITNESS" ||
die "Need ARCH and BITNESS to be set"

pacman_list () {
	package_list=$(for arg
		do
			pactree -u "$arg"
		done |
		grep -v -e '^db$' -e '^info$' -e '^heimdal$' |
		sort |
		uniq) &&
	if test -n "$PACKAGE_VERSIONS_FILE"
	then
		pacman -Q $package_list >"$PACKAGE_VERSIONS_FILE"
	fi &&
	pacman -Ql $package_list |
	grep -v '/$' |
	sed 's/^[^ ]* //'
}

# Packages that have been added after Git SDK 1.0.0 was released...
pacman -S --needed --noconfirm mingw-w64-$ARCH-connect >&2 ||
die "Could not install required packages"

pacman_list mingw-w64-$ARCH-git mingw-w64-$ARCH-git-doc-html \
	git-extra ncurses mintty vim openssh winpty \
	sed awk less grep gnupg tar findutils coreutils diffutils patch \
	dos2unix which subversion mingw-w64-$ARCH-tk \
	mingw-w64-$ARCH-connect "$@" |
grep -v -e '\.[acho]$' -e '\.l[ao]$' -e '/aclocal/' \
	-e '/man/' -e '/pkgconfig/' -e '/emacs/' \
	-e '^/usr/lib/python' -e '^/usr/lib/ruby' \
	-e '^/usr/share/awk' -e '^/usr/share/subversion' \
	-e '^/etc/skel/' -e '^/mingw../etc/skel/' \
	-e '^/usr/bin/svn' \
	-e '^/mingw../share/doc/gettext/' \
	-e '^/mingw../share/doc/lib' \
	-e '^/mingw../share/doc/pcre/' \
	-e '^/mingw../share/doc/git-doc/.*\.txt$' \
	-e '^/mingw../lib/gettext/' -e '^/mingw../share/gettext/' \
	-e '^/usr/include/' -e '^/mingw../include/' \
	-e '^/usr/share/doc/' \
	-e '^/usr/share/info/' -e '^/mingw../share/info/' \
	-e '^/mingw../share/git-doc/technical/' \
	-e '^/mingw../itcl/' \
	-e '^/mingw../t\(cl\|k\)[^/]*/\(demos\|msgs\|encoding\|tzdata\)/' \
	-e '^/mingw../bin/\(autopoint\|[a-z]*-config\)$' \
	-e '^/mingw../bin/lib\(asprintf\|gettext\|gnutlsxx\|pcre[0-9a-z]\|quadmath\|stdc++\)[^/]*\.dll$' \
	-e '^/mingw../bin/\(asn1\|gnutls\|idn\|mini\|msg\|nettle\|ngettext\|ocsp\|pcre\|rtmp\|xgettext\)[^/]*\.exe$' \
	-e '^/mingw../.*/git-\(remote-testsvn\|shell\)\.exe$' \
	-e '^/mingw../lib/tdbc' \
	-e '^/mingw../share/git\(k\|-gui\)/lib/msgs/' \
	-e '^/mingw../share/locale/' \
	-e '^/usr/bin/msys-\(db\|icu\|gfortran\|stdc++\|quadmath\)[^/]*\.dll$' \
	-e '^/usr/bin/dumper\.exe$' \
	-e '^/usr/share/locale/' \
	-e '^/usr/share.*/magic$' \
	-e '^/usr/share/perl5/core_perl/Unicode/Collate/Locale/' \
	-e '^/usr/share/perl5/core_perl/pods/' \
	-e '^/usr/share/vim/vim74/lang/' |
grep --perl-regexp -v -e '^/usr/(lib|share)/terminfo/(?!.*/(cygwin|dumb|xterm.*)$)' |
sed 's/^\///'

test -z "$PACKAGE_VERSIONS_FILE" ||
pacman -Q filesystem dash rebase >"$PACKAGE_VERSIONS_FILE"

cat <<EOF
etc/profile
etc/profile.d/lang.sh
etc/bash.bash_logout
etc/bash.bashrc
etc/fstab
etc/nsswitch.conf
mingw$BITNESS/etc/gitconfig
etc/post-install/01-devices.post
etc/post-install/03-mtab.post
etc/post-install/06-windows-files.post
usr/bin/start
usr/bin/dash.exe
usr/bin/rebase.exe
usr/bin/rebaseall
mingw$BITNESS/bin/docx2txt
mingw$BITNESS/bin/antiword.exe
mingw$BITNESS/bin/astextplain
mingw$BITNESS/etc/gitattributes
mingw$BITNESS/share/antiword/8859-1.txt
mingw$BITNESS/share/antiword/8859-2.txt
mingw$BITNESS/share/antiword/8859-3.txt
mingw$BITNESS/share/antiword/8859-4.txt
mingw$BITNESS/share/antiword/8859-5.txt
mingw$BITNESS/share/antiword/8859-6.txt
mingw$BITNESS/share/antiword/8859-7.txt
mingw$BITNESS/share/antiword/8859-8.txt
mingw$BITNESS/share/antiword/8859-9.txt
mingw$BITNESS/share/antiword/8859-10.txt
mingw$BITNESS/share/antiword/8859-11.txt
mingw$BITNESS/share/antiword/8859-13.txt
mingw$BITNESS/share/antiword/8859-14.txt
mingw$BITNESS/share/antiword/8859-15.txt
mingw$BITNESS/share/antiword/8859-16.txt
mingw$BITNESS/share/antiword/cp437.txt
mingw$BITNESS/share/antiword/cp850.txt
mingw$BITNESS/share/antiword/cp852.txt
mingw$BITNESS/share/antiword/cp862.txt
mingw$BITNESS/share/antiword/cp864.txt
mingw$BITNESS/share/antiword/cp866.txt
mingw$BITNESS/share/antiword/cp1250.txt
mingw$BITNESS/share/antiword/cp1251.txt
mingw$BITNESS/share/antiword/cp1252.txt
mingw$BITNESS/share/antiword/koi8-r.txt
mingw$BITNESS/share/antiword/koi8-u.txt
mingw$BITNESS/share/antiword/MacCyrillic.txt
mingw$BITNESS/share/antiword/MacRoman.txt
mingw$BITNESS/share/antiword/roman.txt
mingw$BITNESS/share/antiword/UTF-8.txt
mingw$BITNESS/share/antiword/fontnames
usr/bin/unzip.exe
EOF
