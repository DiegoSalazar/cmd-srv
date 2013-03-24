require 'cgi'
require 'socket'
require 'mimemagic'
require "cmd-srv/version"

module CmdSrv
  class Srv < TCPServer
    def initialize(bind = '127.0.0.1', port = 7335)
      @bind, @port = bind || '127.0.0.1', port || 7335
      super @bind, @port
    end

    def start
      log "Starting cmd_srv on http://#{@bind}:#{@port}"
      
      while session = accept
        request = parse session.gets
        log request

        begin
          if File.file? request
            mime = mime_of request
            response = File.read request
          else
            mime = 'text/html'
            response = request == '' ? (index_file || dir_listing) : dir_listing('/' + request + '/*')
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
      request ? CGI.unescape(request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '').chomp) : ''
    end
    
    def index_file
      file = Dir[Dir.pwd + '/index*'].sort.first
      file && file['php'] ? `php -f #{file}` : File.read(file)
    end
    
    def dir_listing(of = '/*')
      html do
        tag 'ul' do
          Dir[File.join(Dir.pwd, of)].map do |entry|
            tag 'li' do
              tag 'a', entry, :href => File.basename(entry)
            end
          end.join
        end
      end
    end
    
    def html
      tag 'html' do
        title = "Index of #{Dir.pwd}"
        tag('head') { tag 'title', title } +
        tag('body') { tag 'h1', title } +
          yield.to_s
      end
    end
    
    def tag(name, text = nil, attrs = {})
      "<#{name}#{html_attrs(text.is_a?(Hash) ? text : attrs)}>#{text || yield}</#{name}>"
    end
    
    def html_attrs(attrs)
      attrs.empty? ? '' : ' ' + attrs.map { |k, v| %{#{k}="#{v}"} }.join(' ')
    end

    def mime_of(filename)
      MimeMagic.by_path filename
    end

    def log(msg)
      STDOUT.puts "[#{Time.now}] #{msg}"
    end
  end
end
