#scraper_controller
class ScrapersController < ApplicationController
  def index
  end

  def show
    @advertisements = Marktplaats.scrape_links_in_background("http://kopen.marktplaats.nl/search.php?from_searchbox_advanced=1&q=nike&g=1776")
  end
end
