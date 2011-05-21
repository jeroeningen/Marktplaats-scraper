#marktplaats.rb
class Marktplaats < Scraper
  #get the advertisement links
  def get_links_with_price
    links = []
    get_url.css("h3.adlist_title a").each do |link|
      price_type = link.parent.parent.parent.next.next.children[1].children.to_s
      ["Bieden", "T.e.a.b.", "Zie omschrijving", "N.o.t.k."].each_with_index do |val, i|
        if price_type.include? val
          links << [link.attributes["href"].value, val]
          break
        elsif i == 3
          links << [link.attributes["href"].value, ""].flatten
        end
      end
    end
    links
  end

  #scrape an advertisement using the DOM and return the advertisement
  def scrape price_type
    source = get_url
    source.encoding = "utf-8"
    advertisement = Advertisement.new
    advertisement.advertisement_nr = source.css("form#contactBlockASQForm input[name=uad_id]")[0].attributes["value"].value
    advertisement.title = source.css("div#vipLeft div.roundedBoxBlueShadow div.content h1").children[0].text
    advertisement.description = source.css("div#vipTabResult div.l").children.to_s
    advertisement.advertisement_owner_id = source.css("form#contactBlockASQForm input[name=user_id]")[0].attributes["value"].value
    advertisement.advertisement_owner_name = source.css("form#contactBlockASQForm input[name=recipient_nickname]")[0].attributes["value"].value
    advertisement.location = source.css("div#vipRight div.roundedBoxYellowShadow div.content p.lh20").children[0].to_s
    advertisement.price = get_price(source)
    advertisement.price_type = price_type
    advertisement.url = @url
    datetime = source.css("div#vipLeft div.roundedBoxBlueShadow div.content div.l table.adTop td.adSummary li nobr").children.to_s.gsub("sinds ", "").gsub(",", "")
    advertisement.datetime = DateTime.strptime(datetime,"%d-%m-%y %H:%M")
    if advertisement.save
      advertisement
    elsif !advertisement.errors[:advertisement_nr].include?("has already been taken")
      raise "Advertisement save failure!. See: #{advertisement.url}"
    end
  end

  #get the price of an advertisement scraping the javascript
  def get_price source
    script = source.css("script")[1].children.to_s
    price_type = script.scan(/ad.price_type'\]='([0-9])/).flatten[0]
    #if price type is not an integer, return zero
    if price_type == "1"
      "0"
    #if price type is an integer, return the price
    elsif price_type == "0"
      script.scan(/ask_price'\]='([0-9]*)/).flatten[0]
    end
  end

  #scrape the advertisements from a given url
  def self.scrape_links url
    advertisements = []
    Marktplaats.new(url).get_links_with_price.each do |link_with_price|
      advertisement_to_scrape = Marktplaats.new(link_with_price[0])
      advertisements << advertisement_to_scrape.scrape(link_with_price[1])
    end
    advertisements
  end
end