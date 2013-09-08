# OpenPhantomScripts

[![Build Status](https://secure.travis-ci.org/mark-rushakoff/OpenPhantomScripts.png?branch=master)](http://travis-ci.org/mark-rushakoff/OpenPhantomScripts)

The scripts in PhantomJS's `examples` directory have no explicit license attached, and they revolve around querying the DOM (PhantomJS itself [is BSD-licensed](https://github.com/ariya/phantomjs/blob/master/LICENSE.BSD), but it uses Qt which [is available under LGPL](http://qt.nokia.com/products/licensing/) or a commercial license).
I wrote these scripts as an explicitly MIT-licensed alternative that queries the backing test runner rather than being dependent on the result of the runner's DOM manipulations.
Hopefully, this means you can drop my scripts into your project and immediately start running your browser-based tests from the console -- as a bonus, if you have any concerns about license virality, these scripts should be far-removed enough from Phantom and Webkit to make you feel safe to include OpenPhantomScripts in your project.

## Local usage

If you plan on running your tests in phantomjs locally, you can copy `phantom-${runner}.js` into your repository or wherever is convenient for you.
If you don't intend on running the tests in phantomjs locally, you can just have Travis CI automatically download the stable version of the correct test runner -- read ahead for directions.

These scripts can run against local files:

    phantomjs phantom-${runner}.js file://$(pwd)/path/to/test.html

    phantomjs phantom-${runner}.js ./path/to/test.html

Or they can run against a real server:

    phantomjs phantom-${runner}.js http://${server}:${port}/path/to/test.html

## Super-easy Travis integration

Want to run your Javascript-based tests under PhantomJs on [Travis CI](http://travis-ci.org/)?
First, go through [Getting Started with Travis](http://about.travis-ci.org/docs/user/getting-started/).

### If you want to check phantom-xxx.js in to your repo

* copy `travis.yml.example-include` to your repository root as `.travis.yml`
* copy `phantom-${runner}.js` to your repo root as `.phantom-${runner}.js` (substituting `${runner}` with `qunit`, `jasmine`, or `mocha`)
* modify your `.travis.yml` to use the right runner and point towards your `test.html` or equivalent
* push!

### If you want Travis CI to automatically use the stable version of phantom-xxx.js

* copy `travis.yml.example-download` to your repository root as `.travis.yml`
* modify your `.travis.yml` to use the right runner and point towards your `test.html` or equivalent
* push!

## If you are experiencing issues with asynchronous code

PhantomJS supports asynchronous calls out of the box, but has some default security features that can cause headaches. In travis.yml.example-download and travis.yml.example-include you will find an override line that will hopefully solve the issues you are having.

	# - "phantomjs --local-to-remote-url-access=true --web-security=false phantom-qunit.js test/test.html"

To use this code just follow the instructions and replace the necessary line with that line. Change qunit to jasmine or mocha if necessary and modify the test/test.html path to point to your test file.

## Alternatives

If OpenPhantomScripts isn't quite the right tool for your job, check out these alternatives:

* [mocha-phantomjs](http://metaskills.net/mocha-phantomjs/)
* [grunt](https://github.com/cowboy/grunt)

----

Coming in the future:

* Other Javascript test suites? (Please open an issue or a pull request!)
