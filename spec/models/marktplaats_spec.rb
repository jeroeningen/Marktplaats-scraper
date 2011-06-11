require 'spec_helper'

describe Marktplaats do
  context "given an result page" do
    url = "http://kopen.marktplaats.nl/search.php?from_searchbox_advanced=1&q=nike&g=1776"
    it "should get the html_document" do
      m = Marktplaats.new url
      scraper = m.get_url
      scraper.class.to_s.should eq("Nokogiri::HTML::Document")
    end
    
    it "should return the advertisement links and price" do
      scraper = Marktplaats.new(url)
      scraper.get_links_with_price[0][0].should =~ /kleding-schoenen-heren.marktplaats.nl/
    end

    it "should scrape the advertisements from the result page" do
      advertisements = Marktplaats.scrape_links(url)
      advertisements.size.should == 30
      advertisements[0].advertisement_nr.should_not eq(advertisements[1].advertisement_nr) 
    end
    
    it "should scrape the links in the background" do
      Marktplaats.scrape_links_in_background(url).should eq([@advertisement])
    end
    
    it "should get the next page" do
      marktplaats = Marktplaats.new(url)
      marktplaats.url.should =~ /marktplaats/
      marktplaats.next_page
      marktplaats.url.should_not eq(url)
      marktplaats.url.should =~ /marktplaats/
    end
    
    it "should scrape the links on each page" do
      marktplaats = Marktplaats.new(url)
      marktplaats.stub!(:next_page).and_return ""
      marktplaats.scrape_links_for_each_page.should be_nil
    end
  end
  
  context "given an advertisement" do
    it "should scrape the advertisement data and return an advertisement" do
      scraper = Marktplaats.new("http://kleding-schoenen-heren.marktplaats.nl/schoenen/456527419-nikies.html?return=eJwFwdsJgDAMAMBdOkCrIH6kiLMEDDb0YWiiUMTdvUOY4WWYosK6gKsjJjOBEB7q%2BRJqvmLPJgXR1LcSbqWOR%2BUW6vCSZLchtBVW43aqi98Pmwgdxw%3D%3D&df=1")
      advertisement = scraper.scrape ""
      advertisement.advertisement_nr.should == 456527419 
      advertisement.title.should == "Gezocht: Nikies"
      advertisement.description.should =~ /Weet iemand waar deze te krijgen zijn in Nederland/
      advertisement.advertisement_owner_id.should == 16599384
      advertisement.advertisement_owner_name.should == "Jantine de Rooy"
      advertisement.location.should =~ /Nederland, Buitenland/
      advertisement.datetime.should == "Fri, 10 Jun 2011 11:16:00".to_datetime
    end
    
    it "should get the price" do
      scraper = Marktplaats.new("http://kleding-schoenen-heren.marktplaats.nl/schoenen/456527419-nikies.html?return=eJwFwdsJgDAMAMBdOkCrIH6kiLMEDDb0YWiiUMTdvUOY4WWYosK6gKsjJjOBEB7q%2BRJqvmLPJgXR1LcSbqWOR%2BUW6vCSZLchtBVW43aqi98Pmwgdxw%3D%3D&df=1")
      scraper.get_price(Marktplaats.new(scraper.url).get_url).should == "0"
      scraper.url = "http://kleding-schoenen-heren.marktplaats.nl/schoenen/456267327-nike-dunk.html?return=eJwVylsKgzAQheG9CPpWNVq0REKxKyjdQUjSJpjL4EQoLd17J2%2FffziSM%2F51vF%2BQs8vAKzRyV3axOQPvui2BiW2Q%2B5bBS5mxjb7bvNEuvk7W7CZ2qGwykaCm89DaHPz17QVrNIqc6nFl9XjzrGCep%2BKBTNfCTPw4IOJTIwUJytgTAu1rPILZnaJM6KiHBuAQfQMJs0raCNZPl%2FujWn5%2FjqY%2B1w%3D%3D&df=1&fta=eNpN0UtuwyAQBuC7sMiaGczDg3KFquoFIgw4teTEKDhp1Ch3Lw606u7jhxnQ4EjTI5Mhdr3Mh5ubM7Nl2RG7z3vYhbxfFwI7A4HWys5IqkM7r%2FQ9JZvHkMmmlbg9JTpfT%2FEyebvkiXCX0nXPd2nJq19C3ANX5v1j611aJ3eMzE6lbyZBbAqvSwUWi8EZBXG4w4A9gOwLBJjeV%2FQQXAWi2s44Y0azgftB8v%2BJQFBirNDoK6SGig5aIuIvRNzKO98bXhPgrZyH1%2B3IY1QNg6iQ9T3IUdUXjuMfMFbEKBsQKrzqKobIK5wfG0Qr17JVae7altQVXWyH0bQEQgOXcpsllFGuS3IhH%2BZ4Pq6f27hV2eiJndz9sP1AGXog2fGSIjH3xexb441ZR5wez%2BcP%2FKCfbQ%3D%3D&fta_ind=9&fs=1"
      scraper.get_price(Marktplaats.new(scraper.url).get_url).should == "3995"
    end
  end
end