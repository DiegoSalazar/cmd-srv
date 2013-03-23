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

```cd``` into a directory with an index.html file and fire off the cmd: ```cmd_srv``` and das iiit! A browser window will automatically open.

## Todos

* Support passing in a directory to server.
* Auto directory listing when index file missing.
* Write applescript to add server and shortcut key to start the server in current Finder window.
* Interpret php files.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
