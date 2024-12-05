# frozen_string_literal: true

require_relative('./../lib/pieces/queen')

describe BlackQueen do
  describe '#full_moves' do
    context 'when a queen is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:queen_mover) { described_class.new([4, 4], board) }

      it 'calls bishop_moves once' do
        expect(queen_mover).to receive(:bishop_moves).once
        queen_mover.full_moves
      end
    end
  end
end

describe WhiteQueen do
end
