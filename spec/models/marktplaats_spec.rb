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
      scraper = Marktplaats.new("http://kleding-schoenen-heren.marktplaats.nl/schoenen/1000017066-ecco-track-als-nieuw-maat-47.html?return=eJwty%2B0KwiAYhuFzGWz%2FmtO1FQ6JdSbiLGV%2B4esgis69V%2BjfdT%2FwSE75x%2FJhAU6vlDegZVZmMaUkTsgekw69l3kvyUlZoA%2BO7E5vNjxPRmcdCCgTdUCo%2Bcx6U7y7vZyg3QaixHZcaTve04EYEI7W5XKZqxkaP5UF%2BbYJCY8NMOqp%2FE8e9zUcXmerMCNYbNaldIihS2KaWLN8fy3TPVg%3D&fta=eNo1kF1uwyAQhO%2FCQ54Bg4FFvkKvEK35SS05DQp2GjXK3Ys39tunmYFZDYKBVwULbL3P5wfOlfkKxgF7zoM4xTosNxC%2BrMD9LEAY0%2FtZQq%2Bknxf4m4qvOVbwZWmBa4Gf9ZruU%2FC3OoE8lbIO%2FFQGreX2rQJW8JKYn6ApTeiATZEaZd8qhU08Bo3PbnSjSRgIeEBSoklW72DyBiElIymTeCZrzLnvKSNVMAS5w7EBCrUDV8mmA7oddEfhLnTmAFJGTJEqItqe7oncSUHtyvWWFGEdWUE7PR5gDqDDskK5WyjIGpV27vNzH%2Bl5tsqqT0U2bltFtIGWW8FYz3P6uSzf23S8GW2sKz7P25ptvtjmVNuIwPCX%2Ba8dH8wjcHi93%2F8nQpOi&fta_ind=3&df=1&fs=1")
      advertisement = scraper.scrape ""
      advertisement.advertisement_nr.should == 1000017066
      advertisement.title.should == "Ecco track als nieuw maat 47" 
      advertisement.description.should =~ /Kunnen in overleg worden thuisbezorgd./
      advertisement.advertisement_owner_id.should == 110214
      advertisement.advertisement_owner_name.should == "-"
      advertisement.location.should =~ /Heusden gem Heusden, Noord-Brabant/
      advertisement.price.should == 7000
      advertisement.datetime.should == "Tue, 25 Jan 2011 9:56:00".to_datetime
    end
    
    it "should get the price" do
      scraper = Marktplaats.new("http://kleding-schoenen-heren.marktplaats.nl/schoenen/451195180-state-of-art-nieuw-combi-bruin-maat-40.html?return=eJwVylsKgzAQheG9CPpWY7REiIjYnYSYNsHcyIxQWrr3Tt6%2B%2F3CU5PLr5LCA5ELIBowq2i4WMUvGzpRN7IMqJ2avFEIfPTu9OVx83awpJjLQNplI0OI%2B9haD395%2B5d0BK6Z22nk7PTyvmGdRPZLpWonEj8tEeB5AQcp1HAiB9j1ewRSnKRM46rHL%2BVqHZvn9AcPiOaQ%3D&df=1&fta=eNo9kV1uwyAQhO%2FCQ57NPyzKFXqFaG1waokkVnBSq1HuXhzWffuYHc2uBgQLrwIO2OOeT0%2FMhYUCpr7XfOSHWI7LDXjIHLi1JmQBRomQF%2Fid5lDGWCDMC3ThMsP1cUn3aQi3MoE4zPPj2G1ZCtiM58TCVHMKSGBT%2FCyRorLs0alOyHUDLTxfm8L9yjGOhgtFoHiFXvtoRYWk%2BnoQgdk81qL7V8TQoBOOQKYP4Gh9g8GqBv3YNUh2B440GsiDoyBwkkZ9T4qmQK9iA%2BdJMZFyPNrdwxvo%2FR5lBlL2wySSYpMmxZFZuLbCj448zuqtS16rXG4zxnLK6Xpevre6TR14YBdcT9sP1NIjaC2qKoDhDwtfhE8WEDp4vd9%2Fne6hlg%3D%3D&fta_ind=10&fs=1")
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