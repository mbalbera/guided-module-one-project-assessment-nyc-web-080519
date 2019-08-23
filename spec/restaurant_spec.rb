require_relative "../config/environment.rb"
require_relative "./spec_helper.rb"




describe Restaurant do
  describe ".by_category" do
    it "returns an array of restaurants" do
      result = Restaurant.by_category("pizza")
      expect(result).to be_a(Array)
    end

    it "matches the category it receives" do
      result = Restaurant.by_category("pizza")
      expect(result.first.category.downcase).to include("pizza")

    end    

  end
end