require "rails_helper"

describe MoveWithUser do
  subject(:move) { described_class.new(move: raw_move, user: user) }

  let(:raw_move) { instance_double("move", name: "Sybil") }
  let(:user) { instance_double("user", username: "david") }

  describe "#author" do
    subject(:author) { move.author }

    it { is_expected.to eq "david" }
  end
end
