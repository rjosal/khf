#$LastChangedDate: 2009-03-10 11:51:00 -0700 (Tue, 10 Mar 2009) $
#$LastChangedBy: rjosal $

require 'rubygems'
require 'cgi'


module Multipart
  # Formats a given hash as a multipart form post. Hash values can be strings or files.
  class Post
    USERAGENT = "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/523.10.6 (KHTML, like Gecko) Version/3.0.4 Safari/523.10.6" unless const_defined?(:USERAGENT)
    BOUNDARY = "=======Multipart-Part-Delimiter=======" unless const_defined?(:BOUNDARY)
    CONTENT_TYPE = "multipart/form-data; boundary=#{ BOUNDARY }" unless const_defined?(:CONTENT_TYPE)
    HEADER = { "Content-Type" => CONTENT_TYPE, "User-Agent" => USERAGENT } unless const_defined?(:HEADER)

    def self.prepare_query(params)
      fp = []
      params.each do |k, v|
        if v.respond_to?(:read)
          fp.push(FilePart.new(k, v.path, v.read))
        else
          fp.push(StringPart.new(k, v))
        end
      end

      # Assemble the request body using the special multipart format
      query = fp.collect {|p| "--" + BOUNDARY + "\r\n" + p.to_multipart }.join("")  + "--" + BOUNDARY + "--"
      return query, HEADER
    end
  end

  private

  class StringPart
    attr_accessor :k, :v

    def initialize(k, v)
      @k = k
      @v = v
    end

    def to_multipart
      return "Content-Disposition: form-data; name=\"#{CGI::escape(k)}\"\r\n\r\n#{v}\r\n"
    end
  end
  
  class FilePart
    attr_accessor :k, :filename, :content

    def initialize(k, filename, content)
      @k = k
      @filename = filename
      @content = content
    end

    def to_multipart
      ext = File.extname(k)
      return "Content-Disposition: form-data; name=\"#{k}\"; filename=\"#{k}\"\r\n" +
             "Content-Type: image/#{ext[1,ext.length-1]}\r\n\r\n#{ content }\r\n"
    end
  end
end
