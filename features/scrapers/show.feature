Feature: Display the result of a scraper
	In order to display the result of a scraper
	As a visitor
	I have to scrape a source like Marktplaats
	
	Scenario: Display the result of a scraper
		Given I am on /scrapers
		And I should see "Alle scrapers"
		When I follow "Scrape it"
		Then I should see "Even geduld a.u.b. De laadtijd is ca. 30 seconden."
		And I should see the result of the scraped page