# frozen_string_literal: true

require_relative('./../lib/pieces/rook')

describe BlackRook do
  describe '#moves' do
  context "when a rook is selected" do
    
    it "calls castling once" do

    end

    it "calls normal_moves once" do

    end

    it "returns the correct moves" do
      expected_moves = [[1, 0], [2, 0], [3, 0], [0, 1], [0, 2], [0, 3], [0, 4]]
    end
  end
end

describe WhiteRook do
end
