require 'formula'

class DocbookDsssl < Formula
  homepage 'http://docbook.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/docbook/docbook-dsssl/1.79/docbook-dsssl-1.79.tar.bz2'
  sha1 '0ee935247c9f850e930f3b5c162dbc03915469cd'

  bottle do
    root_url "https://github.com/petere/homebrew-sgml/releases/download/bottles-201502150"
    cellar :any
    sha1 "cefab2a39e2f44e85db01b27ab141cfa13a6b224" => :yosemite
    sha1 "eeecbf086798652605e0c0cffc914641ebb2a173" => :mavericks
  end

  def install
    (prefix/'docbook-dsssl').install %w(catalog VERSION common dtds frames html images lib olink print)
    bin.install 'bin/collateindex.pl'
    man1.install 'bin/collateindex.pl.1'
  end

  def post_install
    (etc/'sgml').mkpath
    system "xmlcatalog", "--sgml", "--noout", "--no-super-update",
           "--add", "#{etc}/sgml/catalog",
           opt_prefix/'docbook-dsssl/catalog'
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
