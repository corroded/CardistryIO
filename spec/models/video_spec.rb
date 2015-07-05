require "rails_helper"

describe Video do
  it { should belong_to :user }
  it { should have_many :appearances }
  it { should have_many :comments }
  it { should have_many :sharings }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }
  it { should validate_presence_of :url }

  it "is not approved by default" do
    video = Video.new

    expect(video.approved?).to eq false
  end

  describe "#unapproved" do
    it "returns the unapproved videos" do
      create :video, approved: true
      video = create :video, approved: false

      expect(Video.unapproved).to eq [video]
    end
  end

  describe "#approve!" do
    it "approves a video" do
      video = build :video, approved: false
      video.approve!
      expect(video.approved?).to eq true
    end
  end

  it "destroys appearances when its destroyed" do
    video = create :video
    create :appearance, video: video

    video.destroy

    expect(Appearance.count).to eq 0
  end

  describe ".approved" do
    it "returns all approved videos" do
      video = create :video, approved: true
      create :video, approved: false

      expect(Video.approved).to eq [video]
    end
  end

  describe ".all_public" do
    it "returns approved and non-private videos" do
      video = create :video, approved: true
      create :video, approved: true, private: true
      create :video, approved: false

      expect(Video.all_public).to eq [video]
    end
  end

  describe "#from_instagram?" do
    it "returns true if the video is from instagram" do
      url = "https://scontent.cdninstagram.com/hphotos-xaf1/t50.2886-16/11243245_1599951966956675_1378908578_s.mp4"

      video = Video.new(url: url)

      expect(video.from_instagram?).to eq true
    end

    it "returns false if it ins't from instagram" do
      url = "https://www.youtube.com/watch?v=p2H5YVfZVFw"

      video = Video.new(url: url)

      expect(video.from_instagram?).to eq false
    end
  end
end
