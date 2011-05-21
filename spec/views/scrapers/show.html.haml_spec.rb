require 'spec_helper'

describe "scrapers/_show" do
  it "should display the show of a scraper" do
    assign :advertisements, Marktplaats.scrape_links("http://kopen.marktplaats.nl/search.php?xl=1&ds=to%3A1%3Bl1%3A1776%3Blt%3Azip%3Bsfds%3A%3Bpt%3A0%3Bmp%3Anumeric%3Bkw%3Anike%3Bosi%3A2&ppu=0&p=2&ps=30")
    render :template => "scrapers/show"
    rendered.should =~ /Resultaat van de scraper 'Marktplaats'/
    rendered.should =~ /Advertentienummer/
    rendered.should =~ /Advertentie omschrijving/
    rendered.should =~ /Userid van de plaatser/
    rendered.should =~ /Naam van advertentieplaatser/
    rendered.should =~ /Woonplaats en provincie/
    rendered.should =~ /Advertentieprijs/
    rendered.should =~ /Advertentiedatum/
    rendered.should =~ /Advertentie:/
 
  end
end