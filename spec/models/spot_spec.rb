require "rails_helper"

RSpec.describe Spot, type: :model do
  it "has a valid factory" do
    expect(build(:plan)).to be_valid
  end

  describe "association" do
    it { is_expected.to have_many(:photos).inverse_of(:spot).dependent(:destroy) }
    it { is_expected.to accept_nested_attributes_for(:photos).allow_destroy(true) }
    it { is_expected.to belong_to(:plan) }
  end

  describe "validation" do
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_length_of(:description).is_at_most(1000) }
  end
end
