# frozen_string_literal: true

require_relative('./../lib/pieces/knight')

describe BlackKnight do # rubocop:disable Metrics/BlockLength
  describe '#moves' do # rubocop:disable Metrics/BlockLength
    context 'when a knight is the chosen piece' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]
      subject(:full_mover) { described_class.new([0, 1], board) }
      before do
        allow(full_mover).to receive(:left_moves).and_return([[1, 3], [2, 2]])
        allow(full_mover).to receive(:right_moves).and_return([[2, 0]])
      end

      it 'returns the correct moves available from that spot' do
        full_mover.board[0][1] = full_mover
        # Start Square being [0, 1]
        expected_output = [[1, 3], [2, 2], [2, 0]]
        expect(full_mover.moves).to eql(expected_output)
      end

      it 'calls left_moves once' do
        expect(full_mover).to receive(:left_moves).once
        full_mover.moves
      end
      it 'calls right_moves once' do
        expect(full_mover).to receive(:right_moves).once
        full_mover.moves
      end
    end
  end
  describe '#left_moves' do
    context 'when moves is called for a knight' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:mover) { described_class.new([4, 3], board) }
      it 'returns all moves to the left of the piece' do
        mover.board[4][3] = mover
        # From [4, 3]
        expected_output = [[2, 4], [3, 5], [5, 5], [6, 4]]
        expect(mover.left_moves).to eql(expected_output)
      end
    end
  end

  describe '#right_moves' do
    context 'when moves called for a knight' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]
      subject(:mover) { described_class.new([4, 3], board) }

      it 'returns all moves to the right of the piece' do
        mover.board[4][3] = mover
        # From [4, 3]
        expected_output = [[2, 2], [3, 1], [5, 1], [6, 2]]
        expect(mover.right_moves).to eql(expected_output)
      end
    end
  end
end

describe WhiteKnight do # rubocop:disable Metrics/BlockLength
  describe '#moves' do # rubocop:disable Metrics/BlockLength
    context 'when a knight is the chosen piece' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]
      subject(:full_mover) { described_class.new([0, 1], board) }
      before do
        allow(full_mover).to receive(:left_moves).and_return([[1, 3], [2, 2]])
        allow(full_mover).to receive(:right_moves).and_return([[2, 0]])
      end

      it 'returns the correct moves available from that spot' do
        full_mover.board[0][1] = full_mover
        # Start Square being [0, 1]
        expected_output = [[1, 3], [2, 2], [2, 0]]
        expect(full_mover.moves).to eql(expected_output)
      end

      it 'calls left_moves once' do
        expect(full_mover).to receive(:left_moves).once
        full_mover.moves
      end
      it 'calls right_moves once' do
        expect(full_mover).to receive(:right_moves).once
        full_mover.moves
      end
    end
  end
  describe '#right_moves' do
    context 'when moves is called for a knight' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:mover) { described_class.new([4, 3], board) }
      it 'returns all moves to the right of the piece' do
        mover.board[4][3] = mover
        expected_output = [[2, 4], [3, 5], [5, 5], [6, 4]]
        expect(mover.right_moves).to eql(expected_output)
      end
    end
  end

  describe '#left_moves' do
    context 'when moves called for a knight' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]
      subject(:mover) { described_class.new([4, 3], board) }

      it 'returns all moves to the left of the piece' do
        mover.board[4][3] = mover
        # From [4, 3]
        expected_output = [[2, 2], [3, 1], [5, 1], [6, 2]]
        expect(mover.left_moves).to eql(expected_output)
      end
    end
  end
end
