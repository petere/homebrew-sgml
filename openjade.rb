class Openjade < Formula
  desc "Implementation of the DSSSL language"
  homepage "http://openjade.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/openjade/openjade/1.3.2/openjade-1.3.2.tar.gz"
  sha256 "1d2d7996cc94f9b87d0c51cf0e028070ac177c4123ecbfd7ac1cb8d0b7d322d1"

  bottle do
    root_url "https://github.com/petere/homebrew-sgml/releases/download/bottles-201502150"
    sha256 "4f5865ce2baf6f938c74a51731ba95012dd542b7b8992ecba1a34feb9a2de621" => :yosemite
    sha256 "20eb74265d7f0b86c900b9b873f3c9638880558a8146c5ad4bb3f6a83c9cd062" => :mavericks
  end

  depends_on "open-sp"

  patch :p0 do
    url "https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-Makefile.lib.in"
    sha256 "d538cd1f3fdf836f848220c61834976d579e9e72f2411d3f4b631422834c0bfb"
  end

  patch :p0 do
    url "https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-Makefile.prog.in"
    sha256 "1709f4aadf14fec6ce25dd2ba9bfbc4c75b7a366492333acc9f612e46eea4af2"
  end

  patch :p0 do
    url "https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-ltmain.sh"
    sha256 "2c7c6114ab24fe99142f18948ec2bccb51a226c78f295339c76486cbf44c9b23"
  end

  patch :p0 do
    url "https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-configure"
    sha256 "91010212d38362b33b693f97299557ae8d63ff42443b21397b485e14bcbe48db"
  end

  patch :p0 do
    url "https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-GroveApp.h"
    sha256 "52a88479789eb0173591a3e7055932f28047d0d8cd32a89bb9e11994be8bf5eb"
  end

  patch :p0 do
    url "https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-GroveBuilder.cxx"
    sha256 "cb8819d081e9021dca82ed7e2ecf2749bafd39d60081524953662008cbbfdcfe"
  end

  patch :p0 do
    url "https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-Node.h"
    sha256 "c5874479ed9c888ff56f62d938d07abf8279aa436e9adec4325b836f7048b7df"
  end

  patch :p0 do
    url "https://trac.macports.org/export/112943/trunk/dports/textproc/openjade/files/openjade-getoptperl.patch"
    sha256 "04ef02318becdf8abb693fc3a9c5bd478ff4da706bf3df8cc21e3f2d3ceeba20"
  end

  # patch for building with clang compiler
  patch :p0 do
    url "https://gist.github.com/theirix/3732794/raw/7d0c7d269bbf9d93b394b52e68810615d9aa33cb/default-ctor.patch"
    sha256 "97d6d62b00e1b658db136bcd484b4ed0678dab8ea4f82adb6b85db89e62d1778"
  end

  # patch for correct handling of libtool library
  patch :p0 do
    url "https://gist.github.com/theirix/3732807/raw/1400a70e6396f2c2f3d90a0ca1035e7a79ae8bd6/Makefile.prog.in.patch"
    sha256 "32467e15151dff0c70ecf432ba54d40a802e107bbd098e6292d91eea80fdeec9"
  end

  def install
    ENV.append "CXXFLAGS", "-fno-rtti"

    args = ["--prefix=#{prefix}",
            "--datadir=#{share}/sgml/openjade",
            "--enable-html",
            "--enable-http",
            "--enable-mif",
            "--disable-debug",
            "--disable-dependency-tracking"]

    system "./configure", *args

    # Patch libtool because it doesn't know about CXX
    inreplace "libtool" do |s|
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "CXX", ENV.cxx
    end

    system "make"
    system "make", "install"

    (share/"sgml/openjade").install Dir["dsssl/*"]
  end

  def post_install
    (etc/"sgml").mkpath
    system "xmlcatalog", "--sgml", "--noout", "--no-super-update",
                         "--add", "#{etc}/sgml/catalog",
                         opt_share/"sgml/openjade/catalog"
  end

  test do
    system bin/"openjade", "--help"
  end
end
