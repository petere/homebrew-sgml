require 'formula'

class DocbookDsssl < Formula
  homepage 'http://docbook.sourceforge.net/'
  url 'https://downloads.sourceforge.net/projects/docbook/docbook-dsssl/1.79/docbook-dsssl-1.79.tar.bz2'
  sha1 '0ee935247c9f850e930f3b5c162dbc03915469cd'

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
end
