require 'cgi'
require 'socket'
require 'mimemagic'
require "cmd-srv/version"
require 'cmd-srv/tiny_html_builder'

module CmdSrv
  class Srv < TCPServer
    include TinyHtmlBuilder
    
    def initialize(bind = '127.0.0.1', port = 7335)
      @bind, @port = bind || '127.0.0.1', port || 7335
      super @bind, @port
      @orig_dir = Dir.pwd
      @cur_dir = Dir.pwd
    end

    def start
      log "Starting cmd_srv on http://#{@bind}:#{@port}"
      
      while session = accept
        request = parse session.gets
        log request

        begin
          if File.file? request # serving an asset: css, img, etc.
            @cur_dir = File.dirname request
            mime = mime_of request
            response = read_file request
          else
            mime = 'text/html'
            if request == '/' # root dir
              @cur_dir = @orig_dir.dup
              response = index_file || dir_listing # find an index file or generate one
            elsif Dir.exists? @cur_dir = File.expand_path(request) # change dir
              response = index_file || dir_listing
            end
          end
          
          session.write "HTTP/1.1 200/OK\r\nContent-type:#{mime}; charset=utf-8\r\n\r\n"
          session.write response
        rescue Errno::ENOENT
          session.print "HTTP/1.1 404/NOT FOUND\r\nContent-type:text/html\r\n\r\n"
          session.print "404 Not Found: #{request}"
        rescue Errno::EPIPE => e
          log e.message and exit
        ensure
          session.close
        end
      end
      
    rescue Interrupt
      session.close if session
      puts "Bye"
      exit 0
    end

    private
    
    def parse(request)
      request ? CGI.unescape(request.gsub(/GET\ /, '').gsub(/\ HTTP.*/, '').chomp) : ''
    end
    
    def index_file
      file = Dir[File.join(@cur_dir, '/index*')].sort.first
      return unless file
      read_file file
    end
    
    def dir_listing(of = '/*')
      entries = Dir[File.join(@cur_dir, of)]
      
      html do
        tag 'ul' do
          entries.map do |entry|
            tag 'li' do
              tag 'a', entry, :href => File.expand_path(entry, @cur_dir)
            end
          end.join
        end
      end
    end
    
    def read_file(file)
      file['php'] ? `php -f #{file}` : File.read(file)
    end

    def mime_of(filename)
      MimeMagic.by_path filename
    end

    def log(msg)
      STDOUT.puts "[#{Time.now}] #{msg}"
    end
  end
end
