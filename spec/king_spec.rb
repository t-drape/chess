# frozen_string_literal: true

require_relative './../lib/pieces/king'

describe King do
  describe '#all_moves' do
    context 'when a king is the selected piece' do
      subject(:king_moves) { described_class.new([3, 3]) }
      it 'returns an array' do
        expect(king_moves.all_moves).to be_kind_of Array
      end

      it 'loops through all possible movements of a king' do
        moves = king_moves.instance_variable_get(:@movements)
        expect(moves).to receive(:each)
        king_moves.all_moves
      end

      it 'returns the correct array based on position' do
        expected_output = [[2, 2], [2, 3], [2, 4], [3, 2], [3, 4], [4, 2], [4, 3], [4, 4]]
        expect(king_moves.all_moves).to eql(expected_output)
      end
    end
  end
end
