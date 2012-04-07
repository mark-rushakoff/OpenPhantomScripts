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

I'm currently trying to keep it so that you can just grab `phantom-qunit.js` or `phantom-jasmine.js` and drop that in your script along with a .travis.yml to get a really easy CI up and running.

### Known bugs

The scripts hook into Phantom's resourceReceived event, which is triggered after every resource load (e.g. script tag, image tags); in that hook, we check for the presence of the test object (`window.QUnit` or `window.jasmine`).
If `qunit.js` or `jasmine.js` is too close to one of the last resources in the page, the script will not have been evaluated by the time that the resourceReceived event is triggered, resulting in Phantom never attaching the watcher defined in the script.

----

Coming in the future:

* Other Javascript test suites? (Please open an issue or a pull request!)
