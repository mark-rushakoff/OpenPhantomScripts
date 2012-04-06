# OpenPhantomScripts

[![Build Status](https://secure.travis-ci.org/mark-rushakoff/OpenPhantomScripts.png?branch=master)](http://travis-ci.org/mark-rushakoff/OpenPhantomScripts)

The scripts in PhantomJS's `examples` directory have no explicit license attached, and they revolve around querying the DOM (PhantomJS itself is BSD-licensed, but it uses Qt which has weird licensing).
I wrote these scripts as an explicitly MIT-licensed alternative that queries the backing test runner rather than being dependent on the result of the runner's DOM manipulations.
Hopefully, this means you can drop my scripts into your project and just not worry about PhantomJS's licensing at all.

## Usage

These scripts can run against local files:

    phantomjs phantom-${runner}.js file://$(pwd)/path/to/test.html

Or they can run against a real server:

    phantomjs phantom-${runner}.js http://${server}:${port}/path/to/test.html

----

Coming in the future:

* Other Javascript test suites? (Please open an issue or a pull request!)
