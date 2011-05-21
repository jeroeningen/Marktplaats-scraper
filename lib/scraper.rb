#scraper
require 'open-uri'

class Scraper
  attr_accessor :url
  
  def initialize(url)
    @url = url
  end

  #fetch the url and return the source
  def get_url
    Nokogiri::HTML(open(@url))
  end
end