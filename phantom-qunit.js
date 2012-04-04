// Copyright (c) 2012 Mark Rushakoff

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

// TODO: write to stderr; figure out why sometimes nothing executes
var system = require("system");
var args = system.args;

if (args.length !== 2) {
    console.log("Usage: " + args[0] + " URL");
    phantom.exit(1);
}

var page = require('webpage').create();

var hasQUnit = false;
var attachedDoneCallback = false;
page.onResourceReceived = function() {
    if (hasQUnit) {
        delete page.onResourceReceived;

        // Without this guard, I was occasionally seeing the done handler
        // pushed onto the array multiple times -- maybe the function
        // was queued up several times?
        if (!attachedDoneCallback) {
            attachedDoneCallback = true;
            page.evaluate(function() {
                window.QUnit.config.done.push(function(obj) {
                    console.log("Tests passed: " + obj.passed);
                    console.log("Tests failed: " + obj.failed);
                    console.log("Total: " + obj.total);
                    console.log("Runtime (ms): " + obj.runtime);
                    window.phantomComplete = true;
                    window.phantomResults = obj;
                });
            });
        }
    } else {
        hasQUnit = page.evaluate(function() {
            return !!window.QUnit;
        });
    }
}

page.onConsoleMessage = function(message) {
    console.log(message);
}

var url = args[1];
page.open(url, function(success) {
    if (success === "success") {
        setInterval(function() {
            if (page.evaluate(function() {return window.phantomComplete;})) {
                var failures = page.evaluate(function() {return window.phantomResults.failed;});
                phantom.exit(failures);
            } else {
                console.log("still running...");
            }
        }, 250);
    } else {
        console.log("Failure opening " + url);
        phantom.exit(1);
    }
});
