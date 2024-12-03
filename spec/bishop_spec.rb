# frozen_string_literal: true

require_relative('./../lib/pieces/bishop')

require_relative('./../lib/pieces/rook')

describe BlackBishop do # rubocop:disable Metrics/BlockLength
  describe '#moves' do # rubocop:disable Metrics/BlockLength
    context 'when a black bishop is called' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:mover) { described_class.new([3, 3], board) }

      before do
        allow(mover).to receive(:moves_from_lowest).and_return([[2, 4], [1, 5], [0, 6], [2, 2], [1, 1], [0, 0]])
        allow(mover).to receive(:moves_to_highest).and_return([[4, 4], [5, 5], [6, 6], [7, 7], [4, 3], [3, 2], [2, 1],
                                                               [1, 0]])
      end

      it 'ca;;s moves_from_lowest once' do
        mover.board[3][3] = mover
        expect(mover).to receive(:moves_from_lowest).once
        mover.moves
      end

      it 'calls moves_to_highest once' do
        expect(mover).to receive(:moves_to_highest)
        mover.moves
      end

      it 'returns the correct_values' do
        expected_output = [[2, 4], [1, 5], [0, 6], [2, 2], [1, 1], [0, 0], [4, 4], [5, 5], [6, 6], [7, 7], [4, 3],
                           [3, 2], [2, 1], [1, 0]]

        expect(mover.moves).to eql(expected_output)
      end
    end
  end

  describe '#moves_from_lowest' do # rubocop:disable Metrics/BlockLength
    context 'when a bishop is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:lowest) { described_class.new([2, 3], board) }

      before do
        allow(lowest).to receive(:lowest_from_left).and_return([[1, 4], [0, 5]])
        allow(lowest).to receive(:lowest_from_right).and_return([[1, 2], [0, 1]])
      end

      it 'calls from_lowest_left once' do
        expect(lowest).to receive(:from_lowest_left).once
        lowest.moves_from_lowest
      end

      it 'calls from_lowest_right once' do
        expect(lowest).to receive(:from_lowest_right).once
        lowest.moves_from_lowest
      end

      it 'returns the correct moves lower than y value' do
        expected_output = [[1, 4], [0, 5], [1, 2], [0, 1]]
        expect(lowest.moves_from_lowest).to eql(expected_output)
      end
    end
  end

  describe '#from_lowest_left' do # rubocop:disable Metrics/BlockLength
    context 'when a bishop is selected' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:lower_left) { described_class.new([2, 4], board) }

      it 'returns all values to the left of pos' do
        lower_left.board = lower_left
        expected_output = [[1, 5], [0, 6]]
        expect(lower_left.from_lowest_left).to eql(expected_output)
      end

      it 'returns correct values when path is blocked later in path' do
        lower_left.board[0][6] = 12
        expected_output = [[1, 5]]
        expect(lower_left.from_lowest_left).to eql(expected_output)
      end

      it 'returns empty array when blocked on first move' do
        lower_left.board[1][5] = 12
        expected_output = []
        expect(lower_left.from_lowest_left).to eql(expected_output)
      end

      it 'returns correct value if blocked by opponent' do
        lower_left.board[1][5] = WhiteRook.new([1, 5], board)
        expected_output = [[1, 5]]
        expect(lower_left.from_lowest_left).to eql(expected_output)
      end
    end
  end

  describe '#from_lowest_right' do
  end

  describe 'moves_to_highest' do # rubocop:disable Metrics/BlockLength
    context 'when a bishop is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:highest) { described_class.new([2, 3], board) }

      before do
        allow(highest).to receive(:to_highest_left).and_return([[3, 4], [4, 5]])
        allow(highest).to receive(:to_highest_right).and_return([[3, 2], [4, 1]])
      end

      it 'returns the correct moves higher than y' do
        expected_output = [[3, 4], [4, 5], [3, 2], [4, 1]]
        expect(highest.moves_to_highest).to eql(expected_output)
      end

      it 'calls to_highest_left once' do
        expect(highest).to receive(:to_highest_left).once
        highest.moves_to_highest
      end

      it 'calls to_highest_right once' do
        expect(highest).to receive(:to_highest_right).once
        highest.moves_to_highest
      end
    end
  end

  describe '#to_highest_left' do
  end

  describe '#to_highest_right' do
  end
end

describe WhiteBishop do
  describe '#moves' do
  end

  describe '#moves_from_lowest' do
  end

  describe '#from_lowest_to_pos_left' do
  end

  describe '#from_lowest_to_pos_right' do
  end

  describe 'moves_to_highest' do
  end

  describe '#from_pos_to_highest_left' do
  end

  describe '#from_pos_to_highest_right' do
  end
end
