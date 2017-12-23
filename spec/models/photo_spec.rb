require 'rails_helper'

RSpec.describe Photo, type: :model do
  it "has a valid factory" do
    expect(build(:photo)).to be_valid
  end

  describe "association" do
    it { is_expected.to belong_to(:spot) }
  end

  describe "validation" do
    let(:photo) { build(:profile, image: fixture_file_upload("spec/fixtures/images/sample03.jpg", "image/jpg")) }
    it "has a invalid image" do
      expect(photo).to be_invalid
    end
  end
end
