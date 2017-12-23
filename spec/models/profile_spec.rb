require 'rails_helper'

RSpec.describe Profile, type: :model do
  it "has a valid factory" do
    expect(build(:profile)).to be_valid
  end

  describe "association" do
    let(:profile) { create(:profile) }
    it { is_expected.to belong_to(:user) }
    it { expect(profile.id).to eq profile.user.id}
  end

  describe "validation" do
    let(:profile) { build(:profile, image: fixture_file_upload("spec/fixtures/images/sample03.jpg", "image/jpg")) }
    it "has a invalid image" do
      expect(profile).to be_invalid
    end
  end
end
