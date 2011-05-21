require "spec_helper"

describe Advertisement do
  context "given an empty advertisement" do
    it "should be invalid and not be saved" do
      advertisement = Advertisement.new
      advertisement.valid?.should be_false
      advertisement.save.should be_false
    end
  end
  
  context "given an valid advertisement" do
    it "should be valid and saved" do
      @advertisement.valid?.should be_true
      @advertisement.save.should be_true
    end
    
    it "should not save two advertisements with the same id" do
      @advertisement.save.should be_true
      @advertisement2.save.should be_false
      @advertisement2.errors[:advertisement_nr].include?("has already been taken").should be_true
    end
  end
end