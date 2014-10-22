require 'formula'

class Openjade < Formula
  homepage 'http://openjade.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/openjade/openjade/1.3.2/openjade-1.3.2.tar.gz'
  sha1 '54e1999f41450fbd62c5d466002d79d3efca2321'

  depends_on 'open-sp'

  patch :p0 do
    url "https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-Makefile.lib.in"
    sha1 "d971a4e4196f04cd12bb4268ea1e8449bf3328f6"
  end

  patch :p0 do
    url "https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-Makefile.prog.in"
    sha1 "55913610160d78f023508448391fad5855ef6867"
  end

  patch :p0 do
    url "https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-ltmain.sh"
    sha1 "c8d268f5bda91756a8cdbd148bffaec34c3b1985"
  end

  patch :p0 do
    url "https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-configure"
    sha1 "f57b39bbfd3ecd3663d3876d525ff47b30525886"
  end

  patch :p0 do
    url "https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-GroveApp.h"
    sha1 "e74f48182bc7407fce6333dd8b16ce2bb452a06f"
  end

  patch :p0 do
    url "https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-GroveBuilder.cxx"
    sha1 "1650ea3d2871d4092b4f5574ffcea2da3d27fb2e"
  end

  patch :p0 do
    url "https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-Node.h"
    sha1 "ee2e6cd6aeb20ac944a0bc88337f9451fbc3e978"
  end

  patch :p0 do
    url "https://trac.macports.org/export/112943/trunk/dports/textproc/openjade/files/openjade-getoptperl.patch"
    sha1 "3358ce999497cb219940d1d7edd6eea898abc737"
  end

  # patch for building with clang compiler
  patch :p0 do
    url "https://gist.github.com/theirix/3732794/raw/7d0c7d269bbf9d93b394b52e68810615d9aa33cb/default-ctor.patch"
    sha1 "2afd72e4b5393879b61f1106692b08f119d73879"
  end

  # patch for correct handling of libtool library
  patch :p0 do
    url "https://gist.github.com/theirix/3732807/raw/1400a70e6396f2c2f3d90a0ca1035e7a79ae8bd6/Makefile.prog.in.patch"
    sha1 "12b1dff73876910cbc8f370bf616673b10ce7ade"
  end

  def install
    ENV.append 'CXXFLAGS', '-fno-rtti'

    args = ["--prefix=#{prefix}",
            "--datadir=#{share}/sgml/openjade",
            "--enable-html",
            "--enable-http",
            "--enable-mif",
            "--disable-debug",
            "--disable-dependency-tracking"]

    system "./configure", *args

    # Patch libtool because it doesn't know about CXX
    inreplace 'libtool' do |s|
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "CXX", ENV.cxx
    end

    system "make"
    system "make", "install"

    (share/'sgml/openjade').install Dir['dsssl/*']
  end

  def post_install
    (etc/'sgml').mkpath
    system "xmlcatalog", "--sgml", "--noout", "--no-super-update",
                         "--add", "#{etc}/sgml/catalog",
                         opt_share/'sgml/openjade/catalog'
  end

  test do
    system bin/"openjade", "--help"
  end
end
