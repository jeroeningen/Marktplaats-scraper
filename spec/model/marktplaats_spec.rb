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

    it "should scrape the advertisement data for a given advertisement url" do
      scraper = Marktplaats.new("http://kleding-schoenen-heren.marktplaats.nl/schoenen/447285854-nike-classics-air-max-exclusief-model-van-footlocker.html")
      scraper.scrape
      scraper.advertisement_nr.should == "447285854"
      scraper.title.should == "nike classics air max exclusief model van footlocker" 
      scraper.description.should =~ /Hallo,ik heb 2 weken geleden deze nike schoenen gekocht en ben er toch niet zo tevreden mee.De kassabon is aanwezig en ook op foto. dus deze schoenen zijn echt!doe een goed bod en de schoenen zijn van u<br>groetjes/
      scraper.user_id.should == "5357052"
      scraper.user_name.should == "Remco"
      scraper.location.should =~ /Kerkrade, Limburg/
      scraper.price.should == "0"
      scraper.date.should == "07-05-11"
      scraper.time.should =~ /17:15/
    end
    
    it "should get the price" do
      scraper = Marktplaats.new("http://kleding-schoenen-heren.marktplaats.nl/schoenen/447285854-nike-classics-air-max-exclusief-model-van-footlocker.html")
      scraper.get_price(Marktplaats.new(scraper.url).get_url).should == "0"
      scraper.url = "http://kleding-schoenen-heren.marktplaats.nl/schoenen/448463929-supervette-nike-air-max-1-87-one-nieuw-echt.html?return=eJwVylsKgzAQheG9CPpWY7REiIjYnYSYNsHcyIxQWrr3Tt6%2B%2F3CU5PLr5LCA5ELIBowq2i4WMUvGzpRN7IMqJ2avFEIfPTu9OVx83awpJjLQNplI0OI%2B9haD395%2B5d0BK6Z22nk7PTyvmGdRPZLpWonEj8tEeB5AQcp1HAiB9j1ewRSnKRM46rHL%2BVqHZvn9AcPiOaQ%3D&df=1&fta=eNo10d2OgyAQBeB34aLX%2FAjIkL5CX6EZRLomtCXFds02fffFOt59zhzBHBEsvCv0wJ6PfH5hrsxXMO15yUdxiPU430H4LEBYa3yWYDrp8wx%2FU%2FE1xQq%2BzMD9tcDteR0f0%2BDvdQJ5KOV55OtZHbCCl5H5qZ1TQQGb4vcSJZtVcCGZgIsK2Es0acPowiIwWGXQEaJtQN3LPq6TwHtnNpie0OlEUG6DGuUGiYHCHUHq7wrTOPA9o2hi9rC0G8QeTqKnjAoEzjdETRgGS3CJYDXB7Cu5r6QjcEJIdEWI4duGMiO9Hoawgz4VtVm7FK3K%2BV4w1nMeb5f5Z63btIUDdsXlvP6BVnoEbWSbSmD4y%2FyJ%2BGIegcP78%2FkHDi%2BnHw%3D%3D&fta_ind=10&fs=1"
      scraper.get_price(Marktplaats.new(scraper.url).get_url).should == "9000"
    end
    
    it "should scrape the advertisements for a given url" do
      advertisements = Marktplaats.scrape_links(url)
      advertisements.size.should == 30
      advertisements[0].advertisement_nr.should_not eq(advertisements[1].advertisement_nr) 
    end
  end
end