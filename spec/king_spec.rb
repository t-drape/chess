# frozen_string_literal: true

require_relative './../lib/pieces/king'
require_relative './../lib/pieces/rook'
require_relative './../lib/pieces/queen'
require_relative './../lib/pieces/bishop'
require_relative './../lib/pieces/pawn'
require_relative './../lib/pieces/knight'

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
        expected_output = [0, 1]
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

  describe '#in_check?' do # rubocop:disable Metrics/BlockLength
    context 'when a move is made' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([0, 4], board) }

      before do
        allow(check).to receive(:in_check_vertical?).and_return(false)
        allow(check).to receive(:in_check_horizontal?).and_return(false)
        allow(check).to receive(:in_check_diagonal?).and_return(false)
        allow(check).to receive(:special_checks?).and_return(true)
      end

      it 'calls in_check_vertical? once' do
        check.board[0][4] = check
        expect(check).to receive(:in_check_vertical?).once
        check.in_check?
      end

      it 'calls in_check_horizontal? once' do
        expect(check).to receive(:in_check_horizontal?).once
        check.in_check?
      end

      it 'calls in_check_diagonal? once' do
        expect(check).to receive(:in_check_diagonal?).once
        check.in_check?
      end

      it 'calls special_checks? once' do
        expect(check).to receive(:special_checks?).once
        check.in_check?
      end

      it 'returns true if only one is true' do
        expected_output = true
        expect(check.in_check?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_vertical?' do
    context 'when in_check is called' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([0, 4], board) }

      before do
        allow(check).to receive(:in_check_up?).and_return(false)
        allow(check).to receive(:in_check_down?).and_return(true)
      end

      it 'calls in_check_up? once' do
        check.board[0][4] = check
        expect(check).to receive(:in_check_up?).once
        check.in_check_vertical?
      end

      it 'calls in_check_down? once' do
        expect(check).to receive(:in_check_down?).once
        check.in_check_vertical?
      end

      it 'returns true if only one is true' do
        expected_output = true
        expect(check.in_check_vertical?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_horizontal?' do
    context 'when in_check? is called' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([0, 4], board) }

      before do
        allow(check).to receive(:in_check_left?).and_return(false)
        allow(check).to receive(:in_check_right?).and_return(true)
      end

      it 'calls in_check_left? once' do
        check.board[0][4] = check
        expect(check).to receive(:in_check_left?).once
        check.in_check_horizontal?
      end

      it 'calls in_check_right? once' do
        expect(check).to receive(:in_check_right?).once
        check.in_check_horizontal?
      end

      it 'returns true if only one is true' do
        expected_output = true
        expect(check.in_check_horizontal?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_diagonal?' do
    context 'when in_check? is called' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([0, 4], board) }

      before do
        allow(check).to receive(:in_check_left_up?).and_return(false)
        allow(check).to receive(:in_check_left_down?).and_return(false)
        allow(check).to receive(:in_check_right_up?).and_return(false)
        allow(check).to receive(:in_check_right_down?).and_return(true)
      end

      it 'calls in_check_left_up? once' do
        check.board[0][4] = check
        expect(check).to receive(:in_check_left_up?).once
        check.in_check_diagonal?
      end

      it 'calls in_check_left_down? once' do
        expect(check).to receive(:in_check_left_down?).once
        check.in_check_diagonal?
      end

      it 'calls in_check_right_up? once' do
        expect(check).to receive(:in_check_right_up?).once
        check.in_check_diagonal?
      end

      it 'calls in_check_right_down? once' do
        expect(check).to receive(:in_check_right_down?).once
        check.in_check_diagonal?
      end

      it 'returns true when only one is true' do
        expected_output = true
        expect(check.in_check_diagonal?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_up?' do
    context 'when in_check_vertical? is called' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([0, 4], board) }

      it 'returns false when path is not blocked' do
        check.board[0][4] = check
        expected_output = false
        expect(check.in_check_up?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[0][4] = check
        check.board[3][4] = BlackRook.new([3, 4], board)
        expected_output = false
        expect(check.in_check_up?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent rook' do
        check.board[0][4] = check
        check.board[3][4] = WhiteRook.new([3, 4], board)
        expected_output = true
        expect(check.in_check_up?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[0][4] = check
        check.board[3][4] = WhiteQueen.new([3, 4], board)
        expected_output = true
        expect(check.in_check_up?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_down?' do
    context 'when in_check_vertical? is called' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([7, 4], board) }

      it 'returns false when path is not blocked' do
        check.board[7][4] = check
        expected_output = false
        expect(check.in_check_down?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[7][4] = check
        check.board[3][4] = BlackRook.new([3, 4], board)
        expected_output = false
        expect(check.in_check_down?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent rook' do
        check.board[7][4] = check
        check.board[3][4] = WhiteRook.new([3, 4], board)
        expected_output = true
        expect(check.in_check_down?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[7][4] = check
        check.board[3][4] = WhiteQueen.new([3, 4], board)
        expected_output = true
        expect(check.in_check_down?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_left?' do
    context 'when in_check_vertical? is called' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([3, 4], board) }

      it 'returns false when path is not blocked' do
        check.board[3][4] = check
        expected_output = false
        expect(check.in_check_left?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[3][4] = check
        check.board[3][0] = BlackRook.new([3, 0], board)
        expected_output = false
        expect(check.in_check_left?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent rook' do
        check.board[3][4] = check
        check.board[3][0] = WhiteRook.new([3, 0], board)
        expected_output = true
        expect(check.in_check_left?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[3][4] = check
        check.board[3][0] = WhiteQueen.new([3, 0], board)
        expected_output = true
        expect(check.in_check_left?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_right?' do
    context 'when in_check_vertical? is called' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([3, 4], board) }

      it 'returns false when path is not blocked' do
        check.board[3][4] = check
        expected_output = false
        expect(check.in_check_right?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[3][4] = check
        check.board[3][7] = BlackRook.new([3, 7], board)
        expected_output = false
        expect(check.in_check_right?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent rook' do
        check.board[3][4] = check
        check.board[3][7] = WhiteRook.new([3, 7], board)
        expected_output = true
        expect(check.in_check_right?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[3][4] = check
        check.board[3][7] = WhiteQueen.new([3, 7], board)
        expected_output = true
        expect(check.in_check_right?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_left_up?' do
    context 'when in_check_diagonal?' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([5, 5], board) }

      it 'returns false when path is not blocked' do
        check.board[5][5] = check
        expected_output = false
        expect(check.in_check_left_up?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[5][5] = check
        check.board[6][4] = BlackBishop.new([6, 4], board)
        expected_output = false
        expect(check.in_check_left_up?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent bishop' do
        check.board[5][5] = check
        check.board[6][4] = WhiteBishop.new([6, 4], board)
        expected_output = true
        expect(check.in_check_left_up?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[5][5] = check
        check.board[6][4] = WhiteQueen.new([6, 4], board)
        expected_output = true
        expect(check.in_check_left_up?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_left_down?' do
    context 'when in_check_diagonal?' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([5, 5], board) }

      it 'returns false when path is not blocked' do
        check.board[5][5] = check
        expected_output = false
        expect(check.in_check_left_down?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[5][5] = check
        check.board[4][4] = BlackBishop.new([4, 4], board)
        expected_output = false
        expect(check.in_check_left_down?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent bishop' do
        check.board[5][5] = check
        check.board[4][4] = nil
        check.board[2][2] = WhiteBishop.new([2, 2], board)
        expected_output = true
        expect(check.in_check_left_down?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[5][5] = check
        check.board[4][4] = WhiteQueen.new([4, 4], board)
        expected_output = true
        expect(check.in_check_left_down?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_right_up?' do
    context 'when in_check_diagonal?' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([5, 5], board) }

      it 'returns false when path is not blocked' do
        check.board[5][5] = check
        expected_output = false
        expect(check.in_check_right_up?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[5][5] = check
        check.board[7][7] = BlackBishop.new([7, 7], board)
        expected_output = false
        expect(check.in_check_right_up?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent bishop' do
        check.board[5][5] = check
        check.board[7][7] = WhiteBishop.new([7, 7], board)
        expected_output = true
        expect(check.in_check_right_up?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[5][5] = check
        check.board[7][7] = WhiteQueen.new([7, 7], board)
        expected_output = true
        expect(check.in_check_right_up?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_right_down?' do
    context 'when in_check_diagonal?' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([5, 5], board) }

      it 'returns false when path is not blocked' do
        check.board[5][5] = check
        expected_output = false
        expect(check.in_check_right_down?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[5][5] = check
        check.board[4][6] = BlackBishop.new([4, 6], board)
        expected_output = false
        expect(check.in_check_right_down?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent bishop' do
        check.board[5][5] = check
        check.board[4][6] = nil
        check.board[3][7] = WhiteBishop.new([3, 7], board)
        expected_output = true
        expect(check.in_check_right_down?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[5][5] = check
        check.board[4][6] = WhiteQueen.new([4, 6], board)
        expected_output = true
        expect(check.in_check_right_down?).to eql(expected_output)
      end
    end
  end

  describe '#special_checks?' do
    context 'when in_check? is called' do
      subject(:check) { described_class.new(nil, nil) }

      before do
        allow(check).to receive(:in_pawn_check?).and_return(false)
        allow(check).to receive(:in_knight_check?).and_return(true)
      end

      it 'calls in_pawn_check? once' do
        expect(check).to receive(:in_pawn_check?).once
        check.special_checks?
      end

      it 'calls in_knight_check? once' do
        expect(check).to receive(:in_knight_check?).once
        check.special_checks?
      end
    end
  end

  describe '#in_pawn_check?' do
    context 'when a king is tested for check' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([0, 4], board) }

      it 'returns false if no pawns present' do
        check.board[0][4] = check
        expected_output = false
        expect(check.in_pawn_check?).to eql(expected_output)
      end

      it 'returns true if checked by pawn, diagonal to right' do
        check.board[0][4] = check
        check.board[1][3] = WhitePawn.new([1, 3], board, nil)
        expected_output = true
        expect(check.in_pawn_check?).to eql(expected_output)
      end

      it 'returns true if checked by pawn, diagonal to left' do
        check.board[1][3] = nil
        check.board[1][5] = WhitePawn.new([1, 5], board, nil)
        expected_output = true
        expect(check.in_pawn_check?).to eql(expected_output)
      end
    end
  end

  describe '#in_knight_check?' do
    context 'when a king is tested for check' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([4, 3], board) }

      it 'returns false if no knight(s) present' do
        check.board[4][3] = check
        expected_output = false
        expect(check.in_knight_check?).to eql(expected_output)
      end
      it 'returns true if king in check by knight y - 2, x + 1' do
        check.board[2][4] = WhiteKnight.new([2, 4], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end
      it 'returns true if king in check by knight y - 2, x - 1' do
        check.board[2][4] = nil
        check.board[2][2] = WhiteKnight.new([2, 2], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end
      it 'returns true if king in check by knight y - 1, x + 2' do
        check.board[2][2] = nil
        check.board[3][5] = WhiteKnight.new([3, 5], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end

      it 'returns true if king in check by knight y - 1, x - 2' do
        check.board[3][5] = nil
        check.board[3][1] = WhiteKnight.new([3, 1], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end

      it 'returns true if king in check by knight y + 1, x + 2' do
        check.board[3][1] = nil
        check.board[5][5] = WhiteKnight.new([5, 5], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end

      it 'returns true if king in check by knight y + 1, x - 2' do
        check.board[5][5] = nil
        check.board[5][1] = WhiteKnight.new([5, 1], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end

      it 'returns true if king in check by knight y + 2, x + 1' do
        check.board[5][1] = nil
        check.board[6][4] = WhiteKnight.new([6, 4], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end

      it 'returns true if king in check by knight y + 2, x - 1' do
        check.board[6][4] = nil
        check.board[6][2] = WhiteKnight.new([6, 2], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
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
        expected_output = [7, 1]
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

  describe '#in_check?' do # rubocop:disable Metrics/BlockLength
    context 'when a move is made' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([0, 4], board) }

      before do
        allow(check).to receive(:in_check_vertical?).and_return(false)
        allow(check).to receive(:in_check_horizontal?).and_return(false)
        allow(check).to receive(:in_check_diagonal?).and_return(true)
      end

      it 'calls in_check_vertical? once' do
        check.board[0][4] = check
        expect(check).to receive(:in_check_vertical?).once
        check.in_check?
      end

      it 'calls in_check_horizontal? once' do
        expect(check).to receive(:in_check_horizontal?).once
        check.in_check?
      end

      it 'calls in_check_diagonal? once' do
        expect(check).to receive(:in_check_diagonal?).once
        check.in_check?
      end

      it 'returns true if only one is true' do
        expected_output = true
        expect(check.in_check?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_vertical?' do
    context 'when in_check is called' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([0, 4], board) }

      before do
        allow(check).to receive(:in_check_up?).and_return(false)
        allow(check).to receive(:in_check_down?).and_return(true)
      end

      it 'calls in_check_up? once' do
        check.board[0][4] = check
        expect(check).to receive(:in_check_up?).once
        check.in_check_vertical?
      end

      it 'calls in_check_down? once' do
        expect(check).to receive(:in_check_down?).once
        check.in_check_vertical?
      end

      it 'returns true if only one is true' do
        expected_output = true
        expect(check.in_check_vertical?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_horizontal?' do
    context 'when in_check? is called' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([0, 4], board) }

      before do
        allow(check).to receive(:in_check_left?).and_return(false)
        allow(check).to receive(:in_check_right?).and_return(true)
      end

      it 'calls in_check_left? once' do
        check.board[0][4] = check
        expect(check).to receive(:in_check_left?).once
        check.in_check_horizontal?
      end

      it 'calls in_check_right? once' do
        expect(check).to receive(:in_check_right?).once
        check.in_check_horizontal?
      end

      it 'returns true if only one is true' do
        expected_output = true
        expect(check.in_check_horizontal?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_diagonal?' do
    context 'when in_check? is called' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([0, 4], board) }

      before do
        allow(check).to receive(:in_check_left_up?).and_return(false)
        allow(check).to receive(:in_check_left_down?).and_return(false)
        allow(check).to receive(:in_check_right_up?).and_return(false)
        allow(check).to receive(:in_check_right_down?).and_return(true)
      end

      it 'calls in_check_left_up? once' do
        check.board[0][4] = check
        expect(check).to receive(:in_check_left_up?).once
        check.in_check_diagonal?
      end

      it 'calls in_check_left_down? once' do
        expect(check).to receive(:in_check_left_down?).once
        check.in_check_diagonal?
      end

      it 'calls in_check_right_up? once' do
        expect(check).to receive(:in_check_right_up?).once
        check.in_check_diagonal?
      end

      it 'calls in_check_right_down? once' do
        expect(check).to receive(:in_check_right_down?).once
        check.in_check_diagonal?
      end

      it 'returns true when only one is true' do
        expected_output = true
        expect(check.in_check_diagonal?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_down?' do
    context 'when in_check_vertical? is called' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([0, 4], board) }

      it 'returns false when path is not blocked' do
        check.board[0][4] = check
        expected_output = false
        expect(check.in_check_down?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[0][4] = check
        check.board[3][4] = WhiteRook.new([3, 4], board)
        expected_output = false
        expect(check.in_check_down?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent rook' do
        check.board[0][4] = check
        check.board[3][4] = BlackRook.new([3, 4], board)
        expected_output = true
        expect(check.in_check_down?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[0][4] = check
        check.board[3][4] = BlackQueen.new([3, 4], board)
        expected_output = true
        expect(check.in_check_down?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_up?' do
    context 'when in_check_vertical? is called' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([7, 4], board) }

      it 'returns false when path is not blocked' do
        check.board[7][4] = check
        expected_output = false
        expect(check.in_check_up?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[7][4] = check
        check.board[3][4] = WhiteRook.new([3, 4], board)
        expected_output = false
        expect(check.in_check_up?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent rook' do
        check.board[7][4] = check
        check.board[3][4] = BlackRook.new([3, 4], board)
        expected_output = true
        expect(check.in_check_up?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[7][4] = check
        check.board[3][4] = BlackQueen.new([3, 4], board)
        expected_output = true
        expect(check.in_check_up?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_right?' do
    context 'when in_check_vertical? is called' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([3, 4], board) }

      it 'returns false when path is not blocked' do
        check.board[3][4] = check
        expected_output = false
        expect(check.in_check_right?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[3][4] = check
        check.board[3][0] = WhiteRook.new([3, 0], board)
        expected_output = false
        expect(check.in_check_right?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent rook' do
        check.board[3][4] = check
        check.board[3][0] = BlackRook.new([3, 0], board)
        expected_output = true
        expect(check.in_check_right?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[3][4] = check
        check.board[3][0] = BlackQueen.new([3, 0], board)
        expected_output = true
        expect(check.in_check_right?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_left?' do
    context 'when in_check_vertical? is called' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([3, 4], board) }

      it 'returns false when path is not blocked' do
        check.board[3][4] = check
        expected_output = false
        expect(check.in_check_left?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[3][4] = check
        check.board[3][7] = WhiteRook.new([3, 7], board)
        expected_output = false
        expect(check.in_check_left?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent rook' do
        check.board[3][4] = check
        check.board[3][7] = BlackRook.new([3, 7], board)
        expected_output = true
        expect(check.in_check_left?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[3][4] = check
        check.board[3][7] = BlackQueen.new([3, 7], board)
        expected_output = true
        expect(check.in_check_left?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_right_down?' do
    context 'when in_check_diagonal?' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([5, 5], board) }

      it 'returns false when path is not blocked' do
        check.board[5][5] = check
        expected_output = false
        expect(check.in_check_right_down?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[5][5] = check
        check.board[6][4] = WhiteBishop.new([6, 4], board)
        expected_output = false
        expect(check.in_check_right_down?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent bishop' do
        check.board[5][5] = check
        check.board[6][4] = BlackBishop.new([6, 4], board)
        expected_output = true
        expect(check.in_check_right_down?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[5][5] = check
        check.board[6][4] = BlackQueen.new([6, 4], board)
        expected_output = true
        expect(check.in_check_right_down?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_right_up?' do
    context 'when in_check_diagonal?' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([5, 5], board) }

      it 'returns false when path is not blocked' do
        check.board[5][5] = check
        expected_output = false
        expect(check.in_check_right_up?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[5][5] = check
        check.board[4][4] = WhiteBishop.new([4, 4], board)
        expected_output = false
        expect(check.in_check_right_up?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent bishop' do
        check.board[5][5] = check
        check.board[4][4] = nil
        check.board[2][2] = BlackBishop.new([2, 2], board)
        expected_output = true
        expect(check.in_check_right_up?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[5][5] = check
        check.board[4][4] = BlackQueen.new([4, 4], board)
        expected_output = true
        expect(check.in_check_right_up?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_left_down?' do
    context 'when in_check_diagonal?' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([5, 5], board) }

      it 'returns false when path is not blocked' do
        check.board[5][5] = check
        expected_output = false
        expect(check.in_check_left_down?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[5][5] = check
        check.board[7][7] = WhiteBishop.new([7, 7], board)
        expected_output = false
        expect(check.in_check_left_down?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent bishop' do
        check.board[5][5] = check
        check.board[7][7] = BlackBishop.new([7, 7], board)
        expected_output = true
        expect(check.in_check_left_down?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[5][5] = check
        check.board[7][7] = BlackQueen.new([7, 7], board)
        expected_output = true
        expect(check.in_check_left_down?).to eql(expected_output)
      end
    end
  end

  describe '#in_check_left_up?' do
    context 'when in_check_diagonal?' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([5, 5], board) }

      it 'returns false when path is not blocked' do
        check.board[5][5] = check
        expected_output = false
        expect(check.in_check_left_up?).to eql(expected_output)
      end

      it 'returns false when path is blocked by same color piece' do
        check.board[5][5] = check
        check.board[4][6] = WhiteBishop.new([4, 6], board)
        expected_output = false
        expect(check.in_check_left_up?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent bishop' do
        check.board[5][5] = check
        check.board[4][6] = nil
        check.board[3][7] = BlackBishop.new([3, 7], board)
        expected_output = true
        expect(check.in_check_left_up?).to eql(expected_output)
      end

      it 'returns true when path is blocked by opponent queen' do
        check.board[5][5] = check
        check.board[4][6] = BlackQueen.new([4, 6], board)
        expected_output = true
        expect(check.in_check_left_up?).to eql(expected_output)
      end
    end
  end

  describe '#special_checks?' do
    context 'when in_check? is called' do
      subject(:check) { described_class.new(nil, nil) }

      before do
        allow(check).to receive(:in_pawn_check?).and_return(false)
        allow(check).to receive(:in_knight_check?).and_return(true)
      end

      it 'calls in_pawn_check? once' do
        expect(check).to receive(:in_pawn_check?).once
        check.special_checks?
      end

      it 'calls in_knight_check? once' do
        expect(check).to receive(:in_knight_check?).once
        check.special_checks?
      end
    end
  end

  describe '#in_pawn_check?' do
    context 'when a king is tested for check' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([7, 4], board) }

      it 'returns false if no pawns present' do
        check.board[7][4] = check
        expected_output = false
        expect(check.in_pawn_check?).to eql(expected_output)
      end

      it 'returns true if checked by pawn, diagonal to left' do
        check.board[7][4] = check
        check.board[6][3] = BlackPawn.new([6, 3], board, nil)
        expected_output = true
        expect(check.in_pawn_check?).to eql(expected_output)
      end

      it 'returns true if checked by pawn, diagonal to right' do
        check.board[6][3] = nil
        check.board[6][5] = BlackPawn.new([6, 5], board, nil)
        expected_output = true
        expect(check.in_pawn_check?).to eql(expected_output)
      end
    end
  end

  describe '#in_knight_check?' do
    context 'when a king is tested for check' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:check) { described_class.new([4, 3], board) }

      it 'returns false if no knight(s) present' do
        check.board[4][3] = check
        expected_output = false
        expect(check.in_knight_check?).to eql(expected_output)
      end
      it 'returns true if king in check by knight y - 2, x + 1' do
        check.board[2][4] = BlackKnight.new([2, 4], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end
      it 'returns true if king in check by knight y - 2, x - 1' do
        check.board[2][4] = nil
        check.board[2][2] = BlackKnight.new([2, 2], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end
      it 'returns true if king in check by knight y - 1, x + 2' do
        check.board[2][2] = nil
        check.board[3][5] = BlackKnight.new([3, 5], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end

      it 'returns true if king in check by knight y - 1, x - 2' do
        check.board[3][5] = nil
        check.board[3][1] = BlackKnight.new([3, 1], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end

      it 'returns true if king in check by knight y + 1, x + 2' do
        check.board[3][1] = nil
        check.board[5][5] = BlackKnight.new([5, 5], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end

      it 'returns true if king in check by knight y + 1, x - 2' do
        check.board[5][5] = nil
        check.board[5][1] = BlackKnight.new([5, 1], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end

      it 'returns true if king in check by knight y + 2, x + 1' do
        check.board[5][1] = nil
        check.board[6][4] = BlackKnight.new([6, 4], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end

      it 'returns true if king in check by knight y + 2, x - 1' do
        check.board[6][4] = nil
        check.board[6][2] = BlackKnight.new([6, 2], board)
        expected_output = true
        expect(check.in_knight_check?).to eql(expected_output)
      end
    end
  end
end
