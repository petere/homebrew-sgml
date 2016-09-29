SGML tools for Homebrew
=======================

This is a Homebrew tap with a few SGML-related packages.  These are mainly intended for building the [PostgreSQL documentation](http://www.postgresql.org/docs/devel/static/docguide.html). Other than that, they are ancient, and you probably don't want them unless you know what you are doing.

Just `brew tap petere/sgml` and then `brew install <formula>`.

For the PostgreSQL documentation, you need:

    brew install docbook docbook-dsssl docbook-sgml docbook-xsl openjade
    export SGML_CATALOG_FILES=/usr/local/etc/sgml/catalog

[![Build Status](https://secure.travis-ci.org/petere/homebrew-sgml.png?branch=master)](http://travis-ci.org/petere/homebrew-sgml)
