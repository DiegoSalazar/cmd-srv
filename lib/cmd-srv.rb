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
    end

    def start
      log "Serving #{@orig_dir} on http://#{@bind}:#{@port}"
      
      while session = accept
        @request = parse session.gets
        log @request
        
        begin
          # serving an asset: css, img, etc. from orig_dir
          if File.file? file = File.join(@orig_dir, @request.sub(@orig_dir, ''))
            mime = mime_of file
            response = read_file file
          else
            mime = 'text/html'
            if @request == '' # root dir
              response = index_file || dir_listing # find an index file or generate one
            elsif Dir.exists? @request # change dir
              response = index_file(@request) || dir_listing(@request)
            end
          end
          
          session.write "HTTP/1.1 200/OK\r\nContent-type:#{mime}; charset=utf-8\r\n\r\n"
          session.write response
        rescue Errno::ENOENT
          session.print "HTTP/1.1 404/NOT FOUND\r\nContent-type:text/html\r\n\r\n"
          session.print "404 Not Found: #{@request}"
        rescue Errno::ECONNRESET, Errno::EPIPE => e
          log e.message
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
      @request ? CGI.unescape(request.gsub(/GET\ /, '').gsub(/\ HTTP.*/, '').chomp) : ''
    end
    
    def index_file(dir = @orig_dir)
      file = Dir[File.join(dir, '/index*')].sort.first
      return unless file
      read_file file
    end
    
    def dir_listing(dir = @orig_dir)
      entries = Dir[File.join(dir, '/*')]
      
      html "Index of #{dir}" do
        tag 'ul' do
          entries.map do |entry|
            tag 'li' do
              tag 'a', entry, :href => entry
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
