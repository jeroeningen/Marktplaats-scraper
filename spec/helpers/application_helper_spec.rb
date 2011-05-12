require 'spec_helper'

describe ApplicationHelper do
  describe "#current_controller" do
    it "should return the current controller" do
      controller.stub(:controller_name) {"users"}
      helper.current_controller.should == "users"
    end
  end
  
  describe "#current_controller?" do
    it "should return true if the given controller is part of the current controller" do
      controller.stub(:controller_name) {"users"}
      helper.current_controller?("/").should be_false
      helper.current_controller?("users").should be_true
      helper.current_controller?("users/1").should be_false
      helper.current_controller?("testers").should be_false
    end
  end
  
  describe "#active_link?" do
    it "should check if the given link is active" do
      controller.stub(:controller_name) {"users"}
      helper.active_link?("/").should be_empty
      helper.active_link?("test").should be_empty
      helper.active_link?("users").should_not be_empty
      helper.active_link?("user").should be_empty
    end
  end
  
  describe "#scraper_link_fancybox" do
    it "should return the scraper link for the fancybox" do
      helper.scraperlink_to_fancybox("Scrape de eerste advertentiepagina").should eq("<a href=\"#\" onclick=\"$.fancybox({content: 'Even geduld a.u.b. De laadtijd is ca. 30 seconden.'}); $.ajax({url: '/scrapers/marktplaats', success: function(html){document.getElementsByTagName('html')[0].innerHTML = html;}}); return false;\">Scrape de eerste advertentiepagina</a>")
    end
  end
end
