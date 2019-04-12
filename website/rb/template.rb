class HtmlTemplate
  def initialize
    @bootstrap = "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" 
    @bootstrapjs = "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
    @style = "./css/style.css"
    @script = "./js/script.js"
    @jquery = "https://code.jquery.com/jquery-3.4.0.min.js"

    @brand = "./img/mrpb.png"

    @font = "./font/font.css"
    @favicon = "./favicon.ico"
  end

  attr_reader :bootstrap, :bootstrapjs, :jquery, :style, :script
  attr_reader :brand, :font, :favicon
end
