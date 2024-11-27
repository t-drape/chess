# frozen_string_literal: true

require_relative('./../lib/pieces/pawn')

describe Pawn do
  describe 'on_opening?' do
    context 'when a pawn is on opening square' do
      subject(:opener) { described_class.new('black', [1, 3]) }

      it 'returns true for black pawn' do
        expect(opener.on_opening?).to eql(true)
      end

      subject(:opener) { described_class.new('white', [6, 3]) }
      it 'returns true for white pawn' do
        expect(opener.on_opening?).to eql(true)
      end
    end
    context 'When a pawn is not on the opening square' do
      subject(:not_opener) { described_class.new('black', [4, 3]) }

      it 'returns false for black pawn' do
        expect(not_opener.on_opening?).to eql(false)
      end

      subject(:not_opener) { described_class.new('white', [4, 3]) }

      it 'returns false for white pawn' do
        expect(not_opener.on_opening?).to eql(false)
      end
    end
  end
  describe '#available_moves' do
    context 'when a pawn is on its starting block' do
      subject(:black_pawn) { described_class.new('black', [1, 3]) }
      it 'returns single and double openings for black pawn' do
        expected_output = [[2, 3], [3, 3]]
        expect(black_pawn.available_moves).to eql(expected_output)
      end

      subject(:white_pawn) { described_class.new('white', [6, 3]) }
      it 'returns single and double openings for white pawn' do
        expected_output = [[5, 3], [4, 3]]
        expect(white_pawn.available_moves).to eql(expected_output)
      end
    end

    context 'when a pawn is not on its starting block' do
      subject(:black_pawn) { described_class.new('black', [5, 4]) }
      it 'returns single move for black pawn' do
        expected_output = [[6, 4]]
        expect(black_pawn.available_moves).to eql(expected_output)
      end

      subject(:white_pawn) { described_class.new('white', [5, 4]) }
      it 'returns single move for white pawn' do
        expected_output = [[4, 4]]
        expect(white_pawn.available_moves).to eql(expected_output)
      end
    end
  end
end
