# Tagger

A very simple Sinatra application that lets you tag URLs with Google Analytics campaign information. It is not unlike Google's one tool, but this one comes with some commonly used tagging templates.

## Installation

As a sinatra application you will need a working installation of Ruby and Rubygems. First make sure you have all the required gems installed, using Bundler:

    $ bundle install

Then simply run the Ruby file:

    $ ruby tagger.rb

## How it works

This app has a simple form that posts tags to a callback function, that merges them back into a given URL. It returns your tagged URL (which will be ugly) and a shortened version of it (which will be slightly less ugly).

## Credits

Author: Arjan van der Gaag <arjan@arjanvandergaag.nl>
URL: http://avdgaag.github.com/tagger
License: same as Ruby