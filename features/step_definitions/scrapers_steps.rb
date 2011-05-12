Then /^I should see the result of the scraped page$/ do
  sleep(40)
  ["Advertentie", "Resultaat van de scraper 'Marktplaats'",
    "Advertentienummer", "Advertentie omschrijving", "Userid van de plaatser", 
    "Naam van advertentieplaatser", "Woonplaats en provincie", 
    "Advertentieprijs", "Advertentiedatum", "Adverentietijd"].each do |text|
    if page.respond_to? :should
      page.should have_content(text)
    else
      assert page.has_content?(text)
    end
  end
end