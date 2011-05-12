require 'spec_helper'

describe "/scrapers/index" do
  it "should display all scrapers" do
    render
    rendered.should =~ /Alle scrapers/
    rendered.should =~ /Scrape it/
  end
end