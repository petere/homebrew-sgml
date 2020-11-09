class DocbookSgml < Formula
  desc "standard SGML representation system for technical documents"
  homepage "http://www.docbook.org/"
  url "http://www.docbook.org/sgml/4.2/docbook-4.2.zip"
  sha256 "67ebd2c94b342718c6865d2de60f5d4ff02d77a7e4b0d9e72a48c45f2b2635c3"

  bottle do
    root_url "https://github.com/petere/homebrew-sgml/releases/download/bottles-201502150"
    cellar :any
    sha256 "a63f1d843472ad6ef900e6f9a235a5013122752a012400964bf1f532690c2b34" => :yosemite
    sha256 "d1440a6dcb437cccc280a30dcf9458d825d62db9e3c3ef5d479730e8d1e1e5bc" => :mavericks
  end

  resource "iso8879" do
    url "http://www.oasis-open.org/cover/ISOEnts.zip"
    sha256 "dce4359a3996ed2fd33ad5eaa11a9bcfc24b5b06992e24295132b06db19a99b2"
  end

  def install
    files = %w[calstblx.dtd catalog.xml dbcentx.mod dbgenent.mod dbhierx.mod
               dbnotnx.mod dbpoolx.mod docbook.cat docbook.dcl docbook.dtd
               docbookx.dtd soextblx.dtd]

    (prefix/"docbook/sgml/4.2").install files

    resource("iso8879").stage do
      (prefix/"docbook/sgml/4.2").install Dir["ISO*"]
    end

    inreplace prefix/"docbook/sgml/4.2/docbook.cat", /iso-(.*).gml/, "ISO\\1"
  end

  def post_install
    (etc/"sgml").mkpath
    system "xmlcatalog", "--sgml", "--noout", "--no-super-update",
           "--add", "#{etc}/sgml/catalog",
           opt_prefix/"docbook/sgml/4.2/docbook.cat"
  end

  def caveats
    <<~EOS
      To use the DocBook SGML package in your SGML toolchain,
      you need to add the following to your ~/.bashrc:

      export SGML_CATALOG_FILES="#{etc}/sgml/catalog"
    EOS
  end

  test do
    ENV["SGML_CATALOG_FILES"] = etc/"sgml/catalog"

    if Formula["open-sp"].any_version_installed?
      (testpath/"test.sgml").write <<EOS
<!doctype book PUBLIC "-//OASIS//DTD DocBook V4.2//EN">
<book>
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
      system "#{Formula["open-sp"].bin}/onsgmls", "-s", "test.sgml"
    end
  end
end
