# Tagger 0.2.0

A very simple Sinatra application that lets you tag URLs with Google Analytics campaign information. It is not unlike Google's own tool, but this one comes with some commonly used tagging templates.

## Installation

As a sinatra application you will need a working installation of Ruby and Rubygems. First make sure you have all the required gems installed:

    $ gem install sinatra addressable rack-flash bitly

Then simply run the Ruby file:

    $ ruby tagger.rb

...or refer to your host’s documentation on how to run Sinatra apps on your server.

## How it works

This app has a simple form that posts tags to a callback function, that merges them back into a given URL. It returns your tagged URL (which will be ugly) and a shortened version of it (which will be slightly less ugly).

## To Do

* Proper handling of bad or empty input
* Handle all possible variables (keywords and content are unsupported)

## History

### 0.2.0

* Added sanity check for incoming data.
* Fixed bug in form data passed by javascript-generated controls.
* Extracted configuration into config.yml file.
* Actually link the generated links.

### 0.1.0

* First release

## Credits

Author: Arjan van der Gaag <arjan@arjanvandergaag.nl>
URL: http://avdgaag.github.com/tagger
License: same as Ruby