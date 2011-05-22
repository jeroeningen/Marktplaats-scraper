require 'spec_helper'

describe "/scrapers/index" do
  it "should display all scrapers" do
    render
    rendered.should =~ /Alle scrapers/
    rendered.should =~ /Start de scraper/
  end
end