require 'spec_helper'

describe "Homepage route" do
  describe "GET /" do
    it "should route to scrapers/index" do
      {:get => root_path}.should route_to(:controller => "scrapers", :action => "index")
    end
  end
end