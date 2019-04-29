module Bot
  class HtmlTemplate
    def initialize
      @path = File.dirname(File.expand_path(__FILE__))
      @bootstrap = "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
      @bootstrapjs = "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
      @style = "./css/style.css"
      @jquery_announce_css = "/../lib/announce/jquery.announce.min.css"
      @script = "./js/script.js"
      @jquery = "https://code.jquery.com/jquery-3.4.0.min.js"
      @jquery_announce = "/../lib/announce/jquery.announce.min.js"
      @brand = "./img/mrpb.png"

      @font = "./font/font.css"
      @favicon = "./favicon.ico"
    end

    attr_reader :bootstrap, :bootstrapjs, :jquery, :style, :script
    attr_reader :brand, :font, :favicon, :jquery_announce
    attr_reader :jquery_announce_css
  end
end
