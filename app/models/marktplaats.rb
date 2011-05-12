class Marktplaats < Scraper
  attr_accessor :advertisement_nr, :title, :description, :user_id, :user_name, :location, :price, :price_type, :date, :time, :url
  
  #get the advertisement links
  def get_links_with_price
    links = []
    Marktplaats.get_url(@url).css("h3.adlist_title a").each do |link|
      price_type = link.parent.parent.parent.next.next.children[1].children.to_s
      if price_type.include? "Bieden"
        links << [link.attributes["href"].value, "Bieden"]
      elsif price_type.include? "T.e.a.b."
        links << [link.attributes["href"].value, "T.e.a.b."]
      elsif price_type.include? "Zie omschrijving"
        links << [link.attributes["href"].value, "Zie omschrijving"]
      elsif price_type.include? "N.o.t.k."
        links << [link.attributes["href"].value, "N.o.t.k."]
      else
        links << [link.attributes["href"].value, ""].flatten
      end
    end
    links
  end
  
  #scrape an advertisement using the DOM
  def scrape
    source = Marktplaats.get_url(@url)
    source.encoding = "utf-8"
    @advertisement_nr = source.css("form#contactBlockASQForm input[name=uad_id]")[0].attributes["value"].value
    @title = source.css("div#vipLeft div.roundedBoxBlueShadow div.content h1").children[0].text
    @description = source.css("div#vipTabResult div.l").children.to_s
    @user_id = source.css("form#contactBlockASQForm input[name=user_id]")[0].attributes["value"].value
    @user_name = source.css("form#contactBlockASQForm input[name=recipient_nickname]")[0].attributes["value"].value
    @location = source.css("div#vipRight div.roundedBoxYellowShadow div.content p.lh20").children[0].to_s
    @price = get_price(source)
    @date, @time = source.css("div#vipLeft div.roundedBoxBlueShadow div.content div.l table.adTop td.adSummary li nobr").children.to_s.gsub("sinds ", "").split(",")
  end
  
  #get the price of an advertisement scraping the javascript
  def get_price source
    script = source.css("script")[1].children.to_s
    price_type = script.scan(/ad.price_type'\]='([0-9])/).flatten[0]
    if price_type == "1"
      "0"
    elsif price_type == "0"
      script.scan(/ask_price'\]='([0-9]*)/).flatten[0]
    end
  end
  
  #scrape the advertisements from a given url
  def self.scrape_links url
    marktplaats = Marktplaats.new url
    advertisements = []
    marktplaats.get_links_with_price.each do |link_with_price|
      advertisement = Marktplaats.new(link_with_price[0])
      advertisement.price_type = link_with_price[1]
      advertisement.scrape
      advertisements << advertisement
    end
    advertisements
  end
end