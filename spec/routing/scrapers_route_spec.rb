require 'spec_helper'

describe "scrapers route" do
  describe "GET /scrapers" do
    it "should route to scrapers/index" do
      {:get => scrapers_path}.should route_to(:controller => "scrapers", :action => "index")
    end
  end
end