require 'open-uri'

class Scraper
  def initialize(url)
    @url = url
  end
  
  def self.get_url(url)
    Nokogiri::HTML(open(url))
  end
end