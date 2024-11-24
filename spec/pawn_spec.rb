# frozen_string_literal: true

require_relative('./../lib/pieces/pawn')

describe Pawn do
  describe '#available_moves' do
    context 'when pawn is on starting block' do
      subject(:opening) { described_class.new([1, 3]) }
      it 'returns both single and double opening' do
        expected_output = [[2, 3], [3, 3]]
        expect(opening.available_moves).to eql(expected_output)
      end
    end
  end
end
