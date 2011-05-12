Feature: Display homepage
	In order to view the homepage
	As a visitor
	I have to go to the homepage
	
	Scenario: Display the homepage
		When I am on the homepage
		Then I should see "Alle scrapers" within "h1"
		And I should see "Scrape it"