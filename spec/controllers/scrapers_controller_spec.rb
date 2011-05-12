require 'spec_helper'

describe ScrapersController do
  render_views
  
  describe "Get index of scrapers" do
    it "should get the index successfully" do
      get :index
      should respond_with :success
      response.body.should =~ /Alle scrapers/
      response.body.should =~ /Scrape it/
    end
  end

  describe "Get show of a scraper" do
    it "should get the show of a scraper successfully" do
      get :show, :id => "marktplaats"
      should assign_to :advertisements
      should respond_with :success
      response.body.should =~ /Resultaat van de scraper 'Marktplaats'/
    end
  end
end