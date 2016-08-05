class DocbookDsssl < Formula
  desc "modular DocBook DSSSL stylesheets"
  homepage "http://docbook.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/docbook/docbook-dsssl/1.79/docbook-dsssl-1.79.tar.bz2"
  sha256 "2f329e120bee9ef42fbdd74ddd60e05e49786c5a7953a0ff4c680ae6bdf0e2bc"

  bottle do
    root_url "https://github.com/petere/homebrew-sgml/releases/download/bottles-201502150"
    cellar :any
    sha256 "ed383b50e0d7399a804ccc2a28a7a44601f4ee96a622029197ae7df848d9a570" => :yosemite
    sha256 "2902ffe5125e293b00e839747e718f7c82e49379efe0a968b72a344acce71359" => :mavericks
  end

  def install
    (prefix/"docbook-dsssl").install %w[catalog VERSION common dtds frames html images lib olink print]
    bin.install "bin/collateindex.pl"
    man1.install "bin/collateindex.pl.1"
  end

  def post_install
    (etc/"sgml").mkpath
    system "xmlcatalog", "--sgml", "--noout", "--no-super-update",
           "--add", "#{etc}/sgml/catalog",
           opt_prefix/"docbook-dsssl/catalog"
  end

  test do
    ENV["SGML_CATALOG_FILES"] = etc/"sgml/catalog"

    if Formula["docbook-sgml"].installed? && Formula["openjade"].installed?
      (testpath/"test.sgml").write <<EOS
<!doctype book PUBLIC "-//OASIS//DTD DocBook V4.2//EN">
<book id="foo">
 <title>test</title>
 <chapter>
  <title>random</title>
   <sect1>
    <title>testsect</title>
    <para>text</para>
  </sect1>
 </chapter>
</book>
EOS
      system "#{Formula["openjade"].bin}/openjade", "-d", prefix/"docbook-dsssl/html/docbook.dsl", "-t", "sgml", "-V", "nochunks", "-V", "rootchunk", "-V", "%use-id-as-filename%", "test.sgml"
      system "test", "-s", "foo.htm"
    end

    system bin/"collateindex.pl", "-V"
  end
end
