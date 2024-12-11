# frozen_string_literal: true

require_relative('./../lib/pieces/bishop')

require_relative('./../lib/pieces/rook')

describe BlackBishop do # rubocop:disable Metrics/BlockLength
  describe '#bishop_moves' do # rubocop:disable Metrics/BlockLength
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
        mover.bishop_moves
      end

      it 'calls moves_to_highest once' do
        expect(mover).to receive(:moves_to_highest)
        mover.bishop_moves
      end

      it 'returns the correct_values' do
        expected_output = [[2, 4], [1, 5], [0, 6], [2, 2], [1, 1], [0, 0], [4, 4], [5, 5], [6, 6], [7, 7], [4, 3],
                           [3, 2], [2, 1], [1, 0]]

        expect(mover.bishop_moves).to eql(expected_output)
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
        allow(lowest).to receive(:from_lowest_left).and_return([[1, 4], [0, 5]])
        allow(lowest).to receive(:from_lowest_right).and_return([[1, 2], [0, 1]])
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
        lower_left.board[2][4] = lower_left
        expected_output = [[1, 5], [0, 6]]
        expect(lower_left.from_lowest_left).to eql(expected_output)
      end

      it 'returns correct values when path is blocked later in path' do
        lower_left.board[0][6] = BlackRook.new([0, 6], board)
        expected_output = [[1, 5]]
        expect(lower_left.from_lowest_left).to eql(expected_output)
      end

      it 'returns empty array when blocked on first move' do
        lower_left.board[1][5] = BlackRook.new([1, 5], board)
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

  describe '#from_lowest_right' do # rubocop:disable Metrics/BlockLength
    context 'when a bishop is selected' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:lower_right) { described_class.new([2, 4], board) }

      it 'returns all values to the right of pos' do
        lower_right.board[2][4] = lower_right
        expected_output = [[1, 3], [0, 2]]
        expect(lower_right.from_lowest_right).to eql(expected_output)
      end

      it 'returns correct values when path is blocked later in path' do
        lower_right.board[0][2] = BlackRook.new([0, 2], board)
        expected_output = [[1, 3]]
        expect(lower_right.from_lowest_right).to eql(expected_output)
      end

      it 'returns empty array when blocked on first move' do
        lower_right.board[1][3] = BlackRook.new([1, 3], board)
        expected_output = []
        expect(lower_right.from_lowest_right).to eql(expected_output)
      end

      it 'returns correct value if blocked by opponent' do
        lower_right.board[1][3] = WhiteRook.new([1, 3], board)
        expected_output = [[1, 3]]
        expect(lower_right.from_lowest_right).to eql(expected_output)
      end
    end
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

  describe '#to_highest_left' do # rubocop:disable Metrics/BlockLength
    context 'when a bishop is selected' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:higher_left) { described_class.new([5, 2], board) }

      it 'returns all moves to left higher than y' do
        higher_left.board[5][2] = higher_left
        expected_output = [[6, 3], [7, 4]]
        expect(higher_left.to_highest_left).to eql(expected_output)
      end

      it 'returns correct values when path is blocked later in path' do
        higher_left.board[7][4] = BlackRook.new([7, 4], board)
        expected_output = [[6, 3]]
        expect(higher_left.to_highest_left).to eql(expected_output)
      end

      it 'returns empty array when blocked on first move' do
        higher_left.board[6][3] = BlackRook.new([6, 3], board)
        expected_output = []
        expect(higher_left.to_highest_left).to eql(expected_output)
      end

      it 'returns correct value if blocked by opponent' do
        higher_left.board[6][3] = WhiteRook.new([6, 3], board)
        expected_output = [[6, 3]]
        expect(higher_left.to_highest_left).to eql(expected_output)
      end
    end
  end

  describe '#to_highest_right' do # rubocop:disable Metrics/BlockLength
    context 'when a bishop is selected' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:higher_right) { described_class.new([5, 2], board) }

      it 'returns all moves to right higher than y' do
        higher_right.board[5][2] = higher_right
        expected_output = [[6, 1], [7, 0]]
        expect(higher_right.to_highest_right).to eql(expected_output)
      end

      it 'returns correct values when path is blocked later in path' do
        higher_right.board[7][0] = BlackRook.new([7, 0], board)
        expected_output = [[6, 1]]
        expect(higher_right.to_highest_right).to eql(expected_output)
      end

      it 'returns empty array when blocked on first move' do
        higher_right.board[6][1] = BlackRook.new([6, 1], board)
        expected_output = []
        expect(higher_right.to_highest_right).to eql(expected_output)
      end

      it 'returns correct value if blocked by opponent' do
        higher_right.board[6][1] = WhiteRook.new([6, 1], board)
        expected_output = [[6, 1]]
        expect(higher_right.to_highest_right).to eql(expected_output)
      end
    end
  end
end

describe WhiteBishop do # rubocop:disable Metrics/BlockLength
  describe '#moves' do # rubocop:disable Metrics/BlockLength
    context 'when a white bishop is called' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:mover) { described_class.new([2, 3], board) }

      before do
        allow(mover).to receive(:moves_from_lowest).and_return([[3, 2], [4, 1], [5, 0], [3, 4], [4, 5], [5, 6], [6, 7]])
        allow(mover).to receive(:moves_to_highest).and_return([[6, 2], [7, 1], [6, 4], [7, 5]])
      end

      it 'calls moves_from_lowest once' do
        mover.board[2][3] = mover
        expect(mover).to receive(:moves_from_lowest).once
        mover.bishop_moves
      end

      it 'calls moves_to_highest once' do
        expect(mover).to receive(:moves_to_highest).once
        mover.bishop_moves
      end

      it 'returns the correct values' do
        expected_output = [[3, 2], [4, 1], [5, 0], [3, 4], [4, 5], [5, 6], [6, 7], [6, 2], [7, 1], [6, 4], [7, 5]]
        expect(mover.bishop_moves).to eql(expected_output)
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

      subject(:lowest) { described_class.new([5, 3], board) }

      before do
        allow(lowest).to receive(:from_lowest_left).and_return([[6, 2], [7, 1]])
        allow(lowest).to receive(:from_lowest_right).and_return([[6, 4], [7, 5]])
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
        expected_output = [[6, 2], [7, 1], [6, 4], [7, 5]]
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

      subject(:lower_left) { described_class.new([5, 3], board) }

      it 'returns all values less than y and to the left of pos' do
        lower_left.board[5][3] = lower_left
        expected_output = [[6, 2], [7, 1]]
        expect(lower_left.from_lowest_left).to eql(expected_output)
      end

      it 'returns correct values when path is blocked later on' do
        lower_left.board[7][1] = WhiteRook.new([7, 1], board)
        expected_output = [[6, 2]]
        expect(lower_left.from_lowest_left).to eql(expected_output)
      end

      it 'returns empty array if immediate path is blocked' do
        lower_left.board[6][2] = WhiteRook.new([6, 2], board)
        expected_output = []
        expect(lower_left.from_lowest_left).to eql(expected_output)
      end

      it 'returns the correct value if blocked by opponent' do
        lower_left.board[6][2] = BlackRook.new([6, 2], board)
        expected_output = [[6, 2]]
        expect(lower_left.from_lowest_left).to eql(expected_output)
      end
    end
  end

  describe '#from_lowest_right' do # rubocop:disable Metrics/BlockLength
    context 'when a bishop is selected' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:lower_right) { described_class.new([5, 3], board) }

      it 'returns all values to the right and less than pos' do
        lower_right.board[5][3] = lower_right
        expected_output = [[6, 4], [7, 5]]
        expect(lower_right.from_lowest_right).to eql(expected_output)
      end

      it 'returns correct values when path is blocked later on' do
        lower_right.board[7][5] = WhiteRook.new([7, 5], board)
        expected_output = [[6, 4]]
        expect(lower_right.from_lowest_right).to eql(expected_output)
      end

      it 'returns empty array if blocked on immediate move' do
        lower_right.board[6][4] = WhiteRook.new([6, 4], board)
        expected_output = []
        expect(lower_right.from_lowest_right).to eql(expected_output)
      end

      it 'returns correct value whe blocked by opponent' do
        lower_right.board[6][4] = BlackRook.new([6, 4], board)
        expected_output = [[6, 4]]
        expect(lower_right.from_lowest_right).to eql(expected_output)
      end
    end
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

      subject(:highest) { described_class.new([2, 2], board) }

      before do
        allow(highest).to receive(:to_highest_left).and_return([[1, 1], [0, 0]])
        allow(highest).to receive(:to_highest_right).and_return([[1, 3], [0, 4]])
      end

      it 'returns the correct moves with higher y-value' do
        expected_output = [[1, 1], [0, 0], [1, 3], [0, 4]]
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

  describe '#to_highest_left' do # rubocop:disable Metrics/BlockLength
    context 'when a bishop is selected' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:higher_left) { described_class.new([2, 2], board) }

      it 'returns all moves to the left with a higher y-value' do
        higher_left.board[2][2] = higher_left
        expected_output = [[1, 1], [0, 0]]
        expect(higher_left.to_highest_left).to eql(expected_output)
      end

      it 'returns correct values when path is blocked later on' do
        higher_left.board[0][0] = WhiteRook.new([0, 0], board)
        expected_output = [[1, 1]]
        expect(higher_left.to_highest_left).to eql(expected_output)
      end

      it 'returns empty array if blocked on immediate move' do
        higher_left.board[1][1] = WhiteRook.new([1, 1], board)
        expected_output = []
        expect(higher_left.to_highest_left).to eql(expected_output)
      end

      it 'returns correct value when blocked by opponent' do
        higher_left.board[1][1] = BlackRook.new([1, 1], board)
        expected_output = [[1, 1]]
        expect(higher_left.to_highest_left).to eql(expected_output)
      end
    end
  end

  describe '#to_highest_right' do # rubocop:disable Metrics/BlockLength
    context 'when a bishop is selected' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:higher_right) { described_class.new([2, 2], board) }

      it 'returns all moves to the right with a higher y-value' do
        higher_right.board[2][2] = higher_right
        expected_output = [[1, 3], [0, 4]]
        expect(higher_right.to_highest_right).to eql(expected_output)
      end

      it 'returns correct values when path is blocked later on' do
        higher_right.board[0][4] = WhiteRook.new([0, 4], board)
        expected_output = [[1, 3]]
        expect(higher_right.to_highest_right).to eql(expected_output)
      end

      it 'returns empty array if blocked on immediate move' do
        higher_right.board[1][3] = WhiteRook.new([1, 3], board)
        expected_output = []
        expect(higher_right.to_highest_right).to eql(expected_output)
      end

      it 'returns correct value if blocked by opponent' do
        higher_right.board[1][3] = BlackRook.new([1, 3], board)
        expected_output = [[1, 3]]
        expect(higher_right.to_highest_right).to eql(expected_output)
      end
    end
  end
end
