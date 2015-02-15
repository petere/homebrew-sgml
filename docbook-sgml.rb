require 'formula'

class DocbookSgml < Formula
  homepage 'http://www.docbook.org/'
  url 'http://www.docbook.org/sgml/4.2/docbook-4.2.zip'
  sha1 '98afcae616ed24edb30e40baa4ddd8cd8731f2c7'

  bottle do
    root_url "https://github.com/petere/homebrew-sgml/releases/download/bottles-201502150"
    cellar :any
    sha1 "f339a54a844e0e5bb914f5bfe774d5a1cee5c3b0" => :yosemite
    sha1 "00af02d622d06c869698d83bf2cf160ed0ff0a47" => :mavericks
  end

  resource 'iso8879' do
    url 'http://www.oasis-open.org/cover/ISOEnts.zip'
    sha1 'e92da4b9e048eb4835e4c66fdfd56f9762ffbd2f'
  end

  def install
    files = %w[calstblx.dtd catalog.xml dbcentx.mod dbgenent.mod dbhierx.mod
               dbnotnx.mod dbpoolx.mod docbook.cat docbook.dcl docbook.dtd
               docbookx.dtd soextblx.dtd]

    (prefix/'docbook/sgml/4.2').install files

    resource('iso8879').stage do
      (prefix/'docbook/sgml/4.2').install Dir['ISO*']
    end

    inreplace prefix/'docbook/sgml/4.2/docbook.cat' do |s|
      s.gsub! /iso-(.*).gml/, "ISO\\1"
    end
  end

  def post_install
    (etc/'sgml').mkpath
    system "xmlcatalog", "--sgml", "--noout", "--no-super-update",
           "--add", "#{etc}/sgml/catalog",
           opt_prefix/'docbook/sgml/4.2/docbook.cat'
  end

  def caveats; <<-EOS.undent
    To use the DocBook SGML package in your SGML toolchain,
    you need to add the following to your ~/.bashrc:

    export SGML_CATALOG_FILES="#{etc}/sgml/catalog"
    EOS
  end

  test do
    ENV["SGML_CATALOG_FILES"] = etc/"sgml/catalog"

    if Formula["open-sp"].installed?
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
