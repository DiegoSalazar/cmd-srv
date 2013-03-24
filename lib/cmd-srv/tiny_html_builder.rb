module CmdSrv
  module TinyHtmlBuilder
    def html(title = "Index of #{Dir.pwd}")
      tag 'html' do
        tag('head') { tag 'title', title } +
        tag('body') do
          tag('h1', title) +
          yield.to_s
        end
      end
    end
    
    def tag(name, text = nil, attrs = {})
      "<#{name}#{html_attrs(text.is_a?(Hash) ? text : attrs)}>#{text || yield}</#{name}>"
    end
    
    def html_attrs(attrs)
      attrs.empty? ? '' : ' ' + attrs.map { |k, v| %{#{k}="#{v}"} }.join(' ')
    end
  end
end