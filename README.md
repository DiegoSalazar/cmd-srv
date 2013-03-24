# Cmd::Srv

A command line utility to quickly server static(ish) files from the current directory.

## Why

I needed a quick way to see html files (site templates, designs, wireframes, etc.) without having to start up Apache or something. 
Why not just open the file directly in the browser you say? Sometimes stylesheet links and scripts use a relative or other path 
that the browser can't find when opened this way. With ```cmd_srv``` I can quickly serve up the current directory as if it were the 
document root.

## What is it?

A tiny little http server! Isn't that the cutest?! It uses TCPServer to handle requests, MimeMagic for correct content-types in responses, and a tiny html builder for listing directory contents when no index file is found.

## Installation

    $ git clone git@github.com:DiegoSalazar/cmd-srv.git
    $ [sudo] gem install cmd-srv/cmd-srv-0.0.1.gem

## Usage

    $ cd into/dir/with/an/index.html
    $ cmd_srv

Das iiit! A browser window will automatically open. You can optionaly pass in arguments to ```cmd_srv <bind> <port>``` where _bind_ is the IP or hostname to bind to and _port_ is... well... the port.

## Todos

* Write applescript to add shortcut key (cmd + srv) to run ```cmd_srv``` in current Finder focused dir, including desktop.
* Interpret php files cuz why not (currently just using php cli to interpret files, haven't fully tested yet).
* Upload to rubygems.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
