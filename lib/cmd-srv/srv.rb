require 'socket'

module CmdSrv
  class Srv < TCPServer
    def initialize(bind = '127.0.0.1', port = 7335)
      @bind, @port = bind || '127.0.0.1', port || 7335
      super @bind, @port
    end
    
    def start
      log "Starting srv on http://#{@bind}:#{@port}"
      main_loop
  	rescue Interrupt
  	  @session.close if @session
  	  puts "Bye"
  	  exit 0
	  ensure
    	@session.close if @session
    end
    
    def main_loop
      while @session = accept
      	request = @session.gets
      	filename = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '').chomp
      	filename = "index.html" if filename == ""
        
        log "#{request.chomp}"

        begin
      		file = File.open File.expand_path(filename, Dir.pwd), 'r'
      		content = file.read
      		@session.write "HTTP/1.1 200/OK\r\nContent-type:#{mime_of(filename)}; charset=utf-8\r\n\r\n"
      		@session.write content
    		rescue Errno::ENOENT
    		  @session.print "HTTP/1.1 404/NOT FOUND\r\nContent-type:text/html\r\n\r\n"
      		@session.print "404 Not Found: #{File.join Dir.pwd, filename}"
    		ensure
    		  @session.close
    		end
  		end
    end
    
    private
    
    def mime_of(filename)
      MimeMagic.by_path filename
    end
    
    def log(msg)
      STDOUT.puts "[#{Time.now}] #{msg}"
    end
  end
end