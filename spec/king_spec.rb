# frozen_string_literal: true

require_relative './../lib/pieces/king'
require_relative './../lib/pieces/rook'

describe BlackKing do # rubocop:disable Metrics/BlockLength
  describe '#normal_moves' do
    context 'when a king is the selected piece' do
      subject(:king_moves) { described_class.new([3, 3], nil) }
      it 'returns an array' do
        expect(king_moves.normal_moves).to be_kind_of Array
      end

      it 'loops through all possible movements of a king' do
        moves = king_moves.instance_variable_get(:@movements)
        expect(moves).to receive(:each)
        king_moves.normal_moves
      end

      it 'returns the correct array based on position' do
        expected_output = [[2, 2], [2, 3], [2, 4], [3, 2], [3, 4], [4, 2], [4, 3], [4, 4]]
        expect(king_moves.normal_moves).to eql(expected_output)
      end
    end
  end

  describe '#castling_right' do # rubocop:disable Metrics/BlockLength
    context 'when a black king castles to the right' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:castle) { described_class.new([0, 4], board) }

      it 'returns correct move if available' do
        castle.board[0][4] = castle
        castle.board[0][0] = BlackRook.new([0, 0], board)
        expected_output = [0, 2]
        expect(castle.castling_right).to eql(expected_output)
      end

      it 'returns nil if rook is not present' do
        castle.board[0][0] = nil
        expected_output = nil
        expect(castle.castling_right).to eql(expected_output)
      end

      it 'returns nil if path is blocked' do
        castle.board[0][0] = BlackRook.new([0, 0], board)
        castle.board[0][2] = 12
        expected_output = nil
        expect(castle.castling_right).to eql(expected_output)
      end
    end
  end

  describe '#castling_left' do # rubocop:disable Metrics/BlockLength
    context 'when a black king castles to the left' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:castle) { described_class.new([0, 4], board) }

      it 'returns correct move if available' do
        castle.board[0][4] = castle
        castle.board[0][7] = BlackRook.new([0, 7], board)
        expected_output = [0, 6]
        expect(castle.castling_left).to eql(expected_output)
      end

      it 'returns nil if rook not present' do
        castle.board[0][7] = nil
        expected_output = nil
        expect(castle.castling_left).to eql(expected_output)
      end

      it 'returns nil if path is blocked' do
        castle.board[0][7] = BlackRook.new([0, 7], board)
        castle.board[0][6] = 12
        expected_output = nil
        expect(castle.castling_left).to eql(expected_output)
      end
    end
  end

  describe '#castling' do # rubocop:disable Metrics/BlockLength
    context 'when a king is picked' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:castle) { described_class.new([0, 4], board) }

      before do
        allow(castle).to receive(:castling_left).and_return([0, 6])
        allow(castle).to receive(:castling_right).and_return([0, 2])
      end

      it 'calls castling_left once' do
        expect(castle).to receive(:castling_left).once
        castle.castling
      end

      it 'calls castling_right once' do
        expect(castle).to receive(:castling_right).once
        castle.castling
      end

      it 'returns the correct values' do
        expected_output = [[0, 6], [0, 2]]
        expect(castle.castling).to eql(expected_output)
      end
    end
  end

  describe '#moves' do # rubocop:disable Metrics/BlockLength
    context 'when a king is the chosen piece' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:king_mover) { described_class.new([0, 4], board) }

      before do
        allow(king_mover).to receive(:normal_moves).and_return([[1, 4], [1, 3]])
        allow(king_mover).to receive(:castling).and_return([[0, 2]])
      end

      it 'calls castling once' do
        expect(king_mover).to receive(:castling).once
        king_mover.moves
      end

      it 'calls normal moves once' do
        expect(king_mover).to receive(:normal_moves).once
        king_mover.moves
      end

      it 'only adds correct values from castling' do
        allow(king_mover).to receive(:castling).and_return([])
        expected_output = [[1, 4], [1, 3]]
        expect(king_mover.moves).to eql(expected_output)
      end

      it 'returns the correct values' do
        expected_output = [[1, 4], [1, 3], [0, 2]]
        expect(king_mover.moves).to eql(expected_output)
      end
    end
  end
end

describe WhiteKing do # rubocop:disable Metrics/BlockLength
  describe '#normal_moves' do
    context 'when a king is the selected piece' do
      subject(:king_moves) { described_class.new([3, 3], nil) }
      it 'returns an array' do
        expect(king_moves.normal_moves).to be_kind_of Array
      end

      it 'loops through all possible movements of a king' do
        moves = king_moves.instance_variable_get(:@movements)
        expect(moves).to receive(:each)
        king_moves.normal_moves
      end

      it 'returns the correct array based on position' do
        expected_output = [[2, 2], [2, 3], [2, 4], [3, 2], [3, 4], [4, 2], [4, 3], [4, 4]]
        expect(king_moves.normal_moves).to eql(expected_output)
      end
    end
  end

  describe '#castling_left' do # rubocop:disable Metrics/BlockLength
    context 'when a white king castles to the left' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:castle) { described_class.new([7, 4], board) }

      it 'returns correct move if available' do
        castle.board[7][4] = castle
        castle.board[7][0] = WhiteRook.new([7, 0], board)
        expected_output = [7, 2]
        expect(castle.castling_left).to eql(expected_output)
      end

      it 'returns nil if rook is not present' do
        castle.board[7][0] = nil
        expected_output = nil
        expect(castle.castling_left).to eql(expected_output)
      end

      it 'returns nil if path is blocked' do
        castle.board[7][0] = WhiteRook.new([7, 0], board)
        castle.board[7][2] = 12
        expected_output = nil
        expect(castle.castling_left).to eql(expected_output)
      end
    end
  end

  describe '#castling_right' do # rubocop:disable Metrics/BlockLength
    context 'when a white king castles to the right' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:castle) { described_class.new([7, 4], board) }

      it 'returns correct move if available' do
        castle.board[7][4] = castle
        castle.board[7][7] = WhiteRook.new([7, 7], board)
        expected_output = [7, 6]
        expect(castle.castling_right).to eql(expected_output)
      end

      it 'returns nil if rook not present' do
        castle.board[7][7] = nil
        expected_output = nil
        expect(castle.castling_right).to eql(expected_output)
      end

      it 'returns nil if path is blocked' do
        castle.board[7][7] = WhiteRook.new([7, 7], board)
        castle.board[7][6] = 12
        expected_output = nil
        expect(castle.castling_right).to eql(expected_output)
      end
    end
  end

  describe '#castling' do # rubocop:disable Metrics/BlockLength
    context 'when a king is picked' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:castle) { described_class.new([7, 4], board) }

      before do
        allow(castle).to receive(:castling_left).and_return([7, 6])
        allow(castle).to receive(:castling_right).and_return([7, 2])
      end

      it 'calls castling_left once' do
        expect(castle).to receive(:castling_left).once
        castle.castling
      end

      it 'calls castling_right once' do
        expect(castle).to receive(:castling_right).once
        castle.castling
      end

      it 'returns the correct values' do
        expected_output = [[7, 6], [7, 2]]
        expect(castle.castling).to eql(expected_output)
      end
    end
  end

  describe '#moves' do # rubocop:disable Metrics/BlockLength
    context 'when a king is the chosen piece' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:king_mover) { described_class.new([7, 4], board) }

      before do
        allow(king_mover).to receive(:normal_moves).and_return([[6, 4], [6, 3]])
        allow(king_mover).to receive(:castling).and_return([[7, 2]])
      end

      it 'calls castling once' do
        expect(king_mover).to receive(:castling).once
        king_mover.moves
      end

      it 'calls normal moves once' do
        expect(king_mover).to receive(:normal_moves).once
        king_mover.moves
      end

      it 'only adds correct values from castling' do
        allow(king_mover).to receive(:castling).and_return([])
        expected_output = [[6, 4], [6, 3]]
        expect(king_mover.moves).to eql(expected_output)
      end

      it 'returns the correct values' do
        expected_output = [[6, 4], [6, 3], [7, 2]]
        expect(king_mover.moves).to eql(expected_output)
      end
    end
  end
end
