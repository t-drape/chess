# frozen_string_literal: true

require_relative('./../lib/pieces/queen')

describe BlackQueen do
  describe '#full_moves' do
    context 'when a black queen is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:queen_mover) { described_class.new([4, 4], board) }
      it 'calls normal_moves once' do
        expect(queen_mover).to receive(:normal_moves)
        queen_mover.moves
      end

      it 'calls moves once' do
        expect(queen_mover).to receive(:moves)
        queen_mover.moves
      end

      it 'returns the correct values' do
        expected_output = [[3, 4], [2, 4], [1, 4], [0, 4], [5, 4], [6, 4], [7, 4], [4, 3], [4, 2], [4, 1], [4, 0],
                           [4, 5], [4, 6], [4, 7], [3, 5], [2, 6], [1, 7], [3, 3], [2, 2], [1, 1], [0, 0], [5, 5],
                           [6, 6], [7, 7], [5, 3], [6, 2], [7, 1]]
        expect(queen_mover.moves).to eql(expected_output)
      end
    end
  end
end

describe WhiteQueen do
  describe '#full_moves' do
    context 'when a white queen is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:queen_mover) { described_class.new([3, 3], board) }

      it 'calls normal_moves once' do
        expect(queen_mover).to receive(:normal_moves).once
        queen_mover.moves
      end

      it 'calls moves once' do
        expect(queen_mover).to receive(:moves).once
        queen_mover.moves
      end

      it 'returns the correct values' do
        expected_output = [[2, 3], [1, 3], [0, 3], [4, 3], [5, 3], [6, 3], [7, 3], [3, 2], [3, 1], [3, 0], [3, 4],
                           [3, 5], [3, 6], [3, 7], [4, 2], [5, 1], [6, 0], [4, 4], [5, 5], [6, 6], [7, 7], [2, 2],
                           [1, 1], [0, 0], [2, 4], [1, 5], [0, 6]]
        expect(queen_mover.moves).to eql(expected_output)
      end
    end
  end
end
