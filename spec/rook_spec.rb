# frozen_string_literal: true

require_relative('./../lib/pieces/rook')
require_relative('./../lib/pieces/king')

describe BlackRook do # rubocop:disable Metrics/BlockLength
  describe '#moves' do # rubocop:disable Metrics/BlockLength
    context 'when a rook is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:rook_mover) { described_class.new([0, 0], board) }

      before do
        allow(rook_mover).to receive(:normal_moves).and_return([[1, 1], [2, 0]])
        allow(rook_mover).to receive(:castling).and_return([[0, 3]])
      end

      it 'calls castling once' do
        rook_mover.board[0][0] = rook_mover
        expect(rook_mover).to receive(:castling).once
        rook_mover.moves
      end

      it 'calls normal_moves once' do
        expect(rook_mover).to receive(:normal_moves).once
        rook_mover.moves
      end

      it 'returns the correct moves' do
        expected_output = [[1, 1], [2, 0], [0, 3]]
        expect(rook_mover.moves).to eql(expected_output)
      end
    end
  end

  describe '#normal_moves' do
    context 'when a black rook on square [0, 0] is the chosen piece' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:zero_rook) { described_class.new([0, 0], board) }

      before do
        allow(zero_rook).to receive(:vertical_moves).and_return([[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0],
                                                                 [7, 0]])

        allow(zero_rook).to receive(:horizontal_moves).and_return([[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6],
                                                                   [0, 7]])
      end

      it 'calls vertical_moves once' do
        zero_rook.board[0][0] = zero_rook
        expect(zero_rook).to receive(:vertical_moves).once
        zero_rook.normal_moves
      end

      it 'calls horizontal_moves once' do
        expect(zero_rook).to receive(:horizontal_moves).once
        zero_rook.normal_moves
      end

      it 'returns the correct moves' do
        expected_output = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0],
                           [7, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6],
                           [0, 7]]
        expect(zero_rook.normal_moves).to eql(expected_output)
      end
    end
  end

  describe '#vertical_moves' do
    context 'when the rook at square 0,9 is selected' do
    end

    context 'when the rook at square 0,7 is selected' do
    end
  end

  describe '#horizontal_moves' do
    context 'when the rook at square 0,0 is selected' do
    end

    context 'when the rook at square 0,7 is selected' do
    end
  end
end

describe WhiteRook do
end
