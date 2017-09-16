require 'rails_helper'

RSpec.describe Plan, type: :model do
  it "has a valid factory" do
    expect(build(:plan)).to be_valid
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_length_of(:description).is_at_most(1000) }
  end
end
