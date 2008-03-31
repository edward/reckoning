TimeCruncher
    by Edward Ocampo-Gooding
    http://edwardog.net

== DESCRIPTION:
  
TimeCruncher is a simple time-tracking format parser. It comes with +crunch_time+, an executable that parses and pretty-prints (in task-grouped format by day with totals) a given file or string in the simple format.

== BUGS

Input like

  Thu Dec 13 09:35:45 EST 2007
    Start: 01:05PM    BirdPost: #83 - fixing more broken routing specs
    End:   01:28PM
    Start: 01:28PM    BirdPost: fixing RareBirdAlert specs (should have been routed as a resource under :users)

creates two tasks with two different project names (there should just be one; 'BirdPost')

== SYNOPSIS:

  $ time_cruncher daily_hours.txt
  
or

  require 'rubygems'
  require 'time_cruncher'
  
  # From a file
  tc = TimeCruncher.read('daily_hours.txt')
  
  # From a string
  tc = TimeCruncher.parse(daily_hours)

== REQUIREMENTS:

* Rspec (for the non-existent tests)

== INSTALL:

(Via RubyGems)

* sudo gem install time_cruncher

== LICENSE:

(The MIT License)

Copyright (c) 2007 Edward Ocampo-Gooding

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
