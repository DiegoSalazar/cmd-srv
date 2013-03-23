# Cmd::Srv

A command line utility to quickly server static files from the current directory.

## Why

I needed a quick way to see html files (site templates, designs, wireframes, etc.) without having to start up a Apache or something. 
Why not just open the file in directly in the browser you say? Sometimes stylesheet links and scripts use a relative or other path 
that the browser can't find when opened this way. With ```cmd_srv``` I can quickly serve up the current directory as if it were the 
document root.

## Installation

    $ [sudo] gem install cmd-srv

## Usage

    $ cd into/dir/with/an/index.html
    $ cmd_srv

Das iiit! A browser window will automatically open. You can optional pass in arguments to ```cmd_srv <bind> <port>``` where _bind_ is the IP or hostname to bind to and port is... well... the port.

## Todos

* Fix the rescue blocks so cmd_srv gracefully shuts down.
* Support passing in a path to serve.
* Auto directory listing when index file missing.
* Write applescript to add shortcut key to ```cmd_srv``` in current Finder window.
* Interpret php files cuz why not.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
