require 'spec_helper'

describe Marktplaats do
  context "given an url" do
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

    it "should scrape the advertisement data for a given advertisement url and return an advertisement" do
      scraper = Marktplaats.new("http://kleding-schoenen-heren.marktplaats.nl/schoenen/423439884-lowa-wandelschoen.html?return=eJwty%2B0KgjAUxvF7EfRbzqlZTEbYnYy52nAvh50JUXTvHaFvv%2F8DjxJcfJzoZhT8ykWFRmVtZ1sKCMa2BCa2QeWtgFeqYBs927xZXXyerMkmMtQ2mUjQ09i3tgR%2Fe3nJmxVlSfWw8Hq4w07oCJ4fy%2BUyHe7J9DlYiG8HRHysSHGcyv8UaF%2FiHkx2mjKho%2B4bgF12DcjzOFbz9wct1j1Z&df=1&fta=eNot0FluwyAQBuC78JBnhs1mkK%2FQK0SsqSWnQcFOo0a5e1ny9mlgFv0WJ3wVnJEc9%2B38sFshpuCkkTy3BU6hLPsNweQDqdkAYZqU2Rgqwcy249%2BaTUmhoMl7%2FXDN%2BHNc43315lZWZKecj4We8iKFaGMFkmwvkZgVa6UWOJI19I1M1ZWgeXBOwrPBWkU7lEiyQzqZOgQk0cEi9QPeuwHN7YBgH9B5tEOax2RgbrRTP7OG2kzTgAyfClDV4RL0dj8L3u%2FxQk8DlI7DXLRSD1DbVzhvZT%2FMaYDYIZnq9zgeIx%2BYxejiTIoBiH2yA%2Bd0SwVqQPst21DOW%2Fy57N8tOlofalhX%2Bzy3NGt8AaVqVYbE%2FhLz9eGDGIsUX%2B%2F3P0gKjSg%3D&fta_ind=6&fs=1")
      advertisement = scraper.scrape ""
      advertisement.advertisement_nr.should == 423439884
      advertisement.title.should == "lowa wandelschoen"
      advertisement.description.should =~ /Kleur zwart navy<br><br>/
      advertisement.advertisement_owner_id.should == 14159957
      advertisement.advertisement_owner_name.should == "chamarshoes"
      advertisement.location.should =~ /Kerkrade, Limburg/
      advertisement.price.should == 15995
      advertisement.datetime.should == "Wed, 16 Feb 2011 11:08:00".to_datetime
    end
    
    it "should get the price" do
      scraper = Marktplaats.new("http://kleding-schoenen-heren.marktplaats.nl/schoenen/454075299-gaastra-schoenen-maat-43.html?return=eJwVylsKgzAQheG9CPpWY7REiIjYnYSYNsHcyIxQWrr3Tt6%2B%2F3CU5PLr5LCA5ELIBowq2i4WMUvGzpRN7IMqJ2avFEIfPTu9OVx83awpJjLQNplI0OI%2B9haD395%2B5d0BK6Z22nk7PTyvmGdRPZLpWonEj8tEeB5AQcp1HAiB9j1ewRSnKRM46rHL%2BVqHZvn9AcPiOaQ%3D&df=1&fs=1")
      scraper.get_price(Marktplaats.new(scraper.url).get_url).should == "0"
      scraper.url = "http://kleding-schoenen-heren.marktplaats.nl/schoenen/448463929-supervette-nike-air-max-1-87-one-nieuw-echt.html?return=eJwVylsKgzAQheG9CPpWY7REiIjYnYSYNsHcyIxQWrr3Tt6%2B%2F3CU5PLr5LCA5ELIBowq2i4WMUvGzpRN7IMqJ2avFEIfPTu9OVx83awpJjLQNplI0OI%2B9haD395%2B5d0BK6Z22nk7PTyvmGdRPZLpWonEj8tEeB5AQcp1HAiB9j1ewRSnKRM46rHL%2BVqHZvn9AcPiOaQ%3D&df=1&fta=eNo10d2OgyAQBeB34aLX%2FAjIkL5CX6EZRLomtCXFds02fffFOt59zhzBHBEsvCv0wJ6PfH5hrsxXMO15yUdxiPU430H4LEBYa3yWYDrp8wx%2FU%2FE1xQq%2BzMD9tcDteR0f0%2BDvdQJ5KOV55OtZHbCCl5H5qZ1TQQGb4vcSJZtVcCGZgIsK2Es0acPowiIwWGXQEaJtQN3LPq6TwHtnNpie0OlEUG6DGuUGiYHCHUHq7wrTOPA9o2hi9rC0G8QeTqKnjAoEzjdETRgGS3CJYDXB7Cu5r6QjcEJIdEWI4duGMiO9Hoawgz4VtVm7FK3K%2BV4w1nMeb5f5Z63btIUDdsXlvP6BVnoEbWSbSmD4y%2FyJ%2BGIegcP78%2FkHDi%2BnHw%3D%3D&fta_ind=10&fs=1"
      scraper.get_price(Marktplaats.new(scraper.url).get_url).should == "9000"
    end
    
    it "should scrape the advertisements for a given url" do
      advertisements = Marktplaats.scrape_links(url)
      advertisements.size.should == 30
      advertisements[0].advertisement_nr.should_not eq(advertisements[1].advertisement_nr) 
    end
    
    it "should scrape the links in the background" do
      Marktplaats.scrape_links_in_background(url).should eq([@advertisement])
    end
    
    it "should get the next page" do
      marktplaats = Marktplaats.new(url)
      marktplaats.next_page
      marktplaats.url.should_not eq(url)
    end
    
    it "should scrape the links on each page" do
      marktplaats = Marktplaats.new(url)
      marktplaats.stub!(:next_page).and_return ""
      marktplaats.scrape_links_for_each_page.should be_nil
    end
  end
end