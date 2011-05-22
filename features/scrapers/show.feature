Feature: Display the result of a scraper
	In order to display the result of a scraper
	As a visitor
	I have to scrape a source like Marktplaats
	
	Scenario: Display the result of a scraper
		Given I am on /scrapers
		And I should see "Alle scrapers"
		When I wait "3" seconds
		And I follow "Scrape de eerste advertentiepagina"
		Then I should see the result of the scraped page