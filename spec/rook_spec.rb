# frozen_string_literal: true

require_relative('./../lib/pieces/rook')
require_relative('./../lib/pieces/king')

describe BlackRook do # rubocop:disable Metrics/BlockLength
  describe '#moves' do # rubocop:disable Metrics/BlockLength
    context 'when a rook is selected' do # rubocop:disable Metrics/BlockLength
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
        allow(rook_mover).to receive(:normal_moves).and_return([[1, 0], [2, 0], [0, 1]])
        allow(rook_mover).to receive(:castling).and_return([[0, 2]])
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
        expected_output = [[1, 0], [2, 0], [0, 1], [0, 2]]
        expect(rook_mover.moves).to eql(expected_output)
      end
    end
  end

  describe '#normal_moves' do # rubocop:disable Metrics/BlockLength
    context 'when a black rook on square [0, 0] is the chosen piece' do # rubocop:disable Metrics/BlockLength
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

  describe '#vertical_moves' do # rubocop:disable Metrics/BlockLength
    context 'when the rook at square 0,9 is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:mover) { described_class.new([0, 0], board) }

      it 'returns an empty array if blocked' do
        mover.board[0][0] = mover
        mover.board[1][0] = BlackRook.new([1, 0], board)
        expected_output = []
        expect(mover.vertical_moves).to eql(expected_output)
      end
    end

    context 'when the rook at square 3,0 is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:mover) { described_class.new([3, 0], board) }

      it 'returns both directions for a piece' do
        mover.board[3][0] = mover
        expected_output = [[2, 0], [1, 0], [0, 0], [4, 0], [5, 0], [6, 0], [7, 0]]
        expect(mover.vertical_moves).to eql(expected_output)
      end

      it 'returns the correct values in both ways if blocked' do
        mover.board[0][0] = BlackRook.new([0, 0], board)
        mover.board[6][0] = WhiteRook.new([6, 0], board)
        expected_output = [[2, 0], [1, 0], [4, 0], [5, 0], [6, 0]]
        expect(mover.vertical_moves).to eql(expected_output)
      end
    end

    context 'when the rook at square 0,7 is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:mover) { described_class.new([3, 7], board) }

      it 'returns both directions for a piece' do
        mover.board[3][7] = mover
        expected_output = [[2, 7], [1, 7], [0, 7], [4, 7], [5, 7], [6, 7], [7, 7]]
        expect(mover.vertical_moves).to eql(expected_output)
      end

      it 'returns the correct values in both ways if blocked' do
        mover.board[0][7] = BlackRook.new([0, 7], board)
        mover.board[6][7] = WhiteRook.new([6, 7], board)
        expected_output = [[2, 7], [1, 7], [4, 7], [5, 7], [6, 7]]
        expect(mover.vertical_moves).to eql(expected_output)
      end
    end
  end

  describe '#up_to_pos_zero_moves' do
    context "when a rook's vertical available moves are being found" do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:vert_mover) { described_class.new([3, 0], board) }

      it 'returns all open spots less than spot' do
        vert_mover.board[3][0] = vert_mover
        expected_output = [[2, 0], [1, 0], [0, 0]]
        expect(vert_mover.up_to_pos_zero_moves).to eql(expected_output)
      end

      it 'returns empty array if no lesser spots are open' do
        vert_mover.board[2][0] = BlackRook.new([2, 0], board)
        expected_output = []
        expect(vert_mover.up_to_pos_zero_moves).to eql(expected_output)
      end
    end
  end

  describe 'from_pos_zero_moves' do
    context "when a rook's vertical available moves are being found" do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:vert_mover) { described_class.new([3, 7], board) }

      it 'returns all open spots more than spot' do
        vert_mover.board[3][7] = vert_mover
        expected_output = [[4, 7], [5, 7], [6, 7], [7, 7]]
        expect(vert_mover.from_pos_zero_moves).to eql(expected_output)
      end

      it 'returns an empty array if no higher spots open (or blocked)' do
        vert_mover.board[4][7] = BlackRook.new([4, 7], board)
        expected_output = []
        expect(vert_mover.from_pos_zero_moves).to eql(expected_output)
      end
    end
  end

  describe '#horizontal_moves' do
    context 'when the rook at square 1,3 is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:mover) { described_class.new([1, 3], board) }

      it 'returns the correct moves in each direction' do
        mover.board[1][3] = mover
        expected_output = [[1, 2], [1, 1], [1, 0], [1, 4], [1, 5], [1, 6], [1, 7]]
        expect(mover.horizontal_moves).to eql(expected_output)
      end

      it 'returns an empty array if both ways are blocked' do
        mover.board[1][2] = BlackRook.new([1, 2], board)
        mover.board[1][4] = BlackRook.new([1, 4], board)
        expected_output = []
        expect(mover.horizontal_moves).to eql(expected_output)
      end
    end
  end

  describe '#up_to_pos_one_moves' do
    context 'when a rook is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:h_mover) { described_class.new([0, 7], board) }

      it 'returns all moves with x index less than spot' do
        h_mover.board[0][7] = h_mover
        expected_output = [[0, 6], [0, 5], [0, 4], [0, 3], [0, 2], [0, 1], [0, 0]]
        expect(h_mover.up_to_pos_one_moves).to eql(expected_output)
      end

      it 'returns empty array if blocked' do
        h_mover.board[0][6] = BlackRook.new([0, 6], board)
        expected_output = []
        expect(h_mover.up_to_pos_one_moves).to eql(expected_output)
      end
    end
  end

  describe '#from_pos_one_moves' do
    context 'when a rook is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:h_mover) { described_class.new([0, 4], board) }

      it 'returns all moves with x index higher than spot' do
        h_mover.board[0][4] = h_mover
        expected_output = [[0, 5], [0, 6], [0, 7]]
        expect(h_mover.from_pos_one_moves).to eql(expected_output)
      end

      it 'returns empty array if blocked' do
        h_mover.board[0][5] = BlackRook.new([0, 5], board)
        expected_output = []
        expect(h_mover.from_pos_one_moves).to eql(expected_output)
      end
    end
  end

  describe `#castling` do
    context 'when the rook is selected and castling is available' do
      subject(:castle) { described_class.new([0, 0], nil) }

      before do
        allow(castle).to receive(:castling_left).and_return([0, 5])
        allow(castle).to receive(:castling_right).and_return([0, 2])
      end

      it 'returns the correct values' do
        expected_output = [[0, 5], [0, 2]]
        expect(castle.castling).to eql(expected_output)
      end

      it 'calls castling_left once' do
        expect(castle).to receive(:castling_left).once
        castle.castling_left
      end

      it 'calls castling_right once' do
        expect(castle).to receive(:castling_right).once
        castle.castling_right
      end
    end
  end

  describe '#castling_left' do # rubocop:disable Metrics/BlockLength
    context 'when castling to the left' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:castle) { described_class.new([0, 7], board) }

      it 'returns the correct move if path open' do
        castle.board[0][4] = BlackKing.new([0, 4], board)
        expected_output = [0, 5]
        expect(castle.castling_left).to eql(expected_output)
      end

      it 'returns nil if path is blocked' do
        castle.board[0][5] = 12
        expected_output = nil
        expect(castle.castling_left).to eql(expected_output)
      end

      it 'returns nil if king is not present' do
        castle.board[0][5] = nil
        castle.board[0][4] = nil
        expected_output = nil
        expect(castle.castling_left).to eql(expected_output)
      end
    end
  end

  describe '#castling_right' do # rubocop:disable Metrics/BlockLength
    context 'when castling to the right' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:castle) { described_class.new([0, 7], board) }

      it 'returns the correct move if path is open' do
        castle.board[0][0] = castle
        castle.board[0][4] = BlackKing.new([0, 4], board)
        expected_output = [0, 2]
        expect(castle.castling_right).to eql(expected_output)
      end

      it 'returns nil if path is blocked' do
        castle.board[0][3] = 12
        expected_output = nil
        expect(castle.castling_right).to eql(expected_output)
      end

      it 'returns nil if king is not present' do
        castle.board[0][3] = nil
        castle.board[0][4] = nil
        expected_output = nil
        expect(castle.castling_right).to eql(expected_output)
      end
    end
  end
end

describe WhiteRook do # rubocop:disable Metrics/BlockLength
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

      subject(:rook_mover) { described_class.new([7, 0], board) }

      before do
        allow(rook_mover).to receive(:normal_moves).and_return([[6, 0], [5, 0], [7, 1]])
        allow(rook_mover).to receive(:castling).and_return([[7, 2]])
      end

      it 'calls castling once' do
        expect(rook_mover).to receive(:castling).once
        rook_mover.moves
      end

      it 'calls normal_moves once' do
        expect(rook_mover).to receive(:normal_moves).once
        rook_mover.moves
      end

      it 'returns the correct moves' do
        expected_output = [[6, 0], [5, 0], [7, 1], [7, 2]]
        expect(rook_mover.moves).to eql(expected_output)
      end
    end
  end

  describe '#normal_moves' do # rubocop:disable Metrics/BlockLength
    context 'when a white rook on square 7, 0 is the chosen piece' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:zero_rook) { described_class.new([7, 0], board) }

      before do
        allow(zero_rook).to receive(:vertical_moves).and_return([[6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0],
                                                                 [0, 0]])
        allow(zero_rook).to receive(:horizontal_moves).and_return([[7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6],
                                                                   [7, 7]])
      end

      it 'vertical_moves once' do
        expect(zero_rook).to receive(:vertical_moves).once
        zero_rook.normal_moves
      end

      it 'calls horizontal_moves once' do
        expect(zero_rook).to receive(:horizontal_moves).once
        zero_rook.normal_moves
      end

      it 'returns the correct moves' do
        expected_output = [[6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0],
                           [0, 0], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5],
                           [7, 6], [7, 7]]

        expect(zero_rook.normal_moves).to eql(expected_output)
      end
    end
  end

  describe '#vertical_moves' do # rubocop:disable Metrics/BlockLength
    context 'when the rook at square 0,0 is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:mover) { described_class.new([7, 0], board) }

      it 'returns an empty array if blocked' do
        mover.board[7][0] = mover
        mover.board[6][0] = WhiteRook.new([6, 0], board)
        expected_output = []
        expect(mover.vertical_moves).to eql(expected_output)
      end
    end

    context 'when the rook at square 4,3 is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:mover) { described_class.new([4, 3], board) }

      it 'returns both direction for a piece' do
        mover.board[4][3] = mover
        expected_output = [[3, 3], [2, 3], [1, 3], [0, 3], [5, 3], [6, 3], [7, 3]]
        expect(mover.vertical_moves).to eql(expected_output)
      end

      it 'returns the correct values in both ways if blocked' do
        mover.board[7][3] = WhiteRook.new([7, 3], board)
        mover.board[2][3] = WhiteRook.new([2, 3], board)
        expected_output = [[3, 3], [5, 3], [6, 3]]
        expect(mover.vertical_moves).to eql(expected_output)
      end
    end

    context 'when the rook at square 2,7 is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:mover) { described_class.new([2, 7], board) }

      it 'returns both directions for a piece' do
        mover.board[2][7] = mover
        expected_output = [[1, 7], [0, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7]]
        expect(mover.vertical_moves).to eql(expected_output)
      end

      it 'returns the correct values in both ways if blocked' do
        mover.board[5][7] = BlackRook.new([5, 7], board)
        mover.board[0][7] = WhiteRook.new([0, 7], board)
        expected_output = [[1, 7], [3, 7], [4, 7], [5, 7]]
        expect(mover.vertical_moves).to eql(expected_output)
      end
    end
  end

  describe '#up_to_pos_zero_moves' do
    context 'when a rook is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:vert_mover) { described_class.new([7, 0], board) }

      it 'returns all open spots with y less than spot' do
        vert_mover.board[7][0] = vert_mover
        expected_output = [[6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0]]
        expect(vert_mover.up_to_pos_zero_moves).to eql(expected_output)
      end

      it 'returns empty array if no lesser y spots open' do
        vert_mover.board[6][0] = WhiteRook.new([6, 0], board)
        expected_output = []
        expect(vert_mover.up_to_pos_zero_moves).to eql(expected_output)
      end
    end
  end

  describe '#from_pos_zero_moves' do
    context "when a rook's vertical available moves are being found" do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:vert_mover) { described_class.new([4, 7], board) }

      it 'returns all open spots with y greater than spot' do
        vert_mover.board[4][7] = vert_mover
        expected_output = [[5, 7], [6, 7], [7, 7]]
        expect(vert_mover.from_pos_zero_moves).to eql(expected_output)
      end

      it 'returns an empty array if no greater y spots open (or blocked)' do
        vert_mover.board[5][7] = vert_mover
        expected_output = []
        expect(vert_mover.from_pos_zero_moves).to eql(expected_output)
      end
    end
  end

  describe '#horizontal_moves' do
    context 'when the rook at square 4, 3 is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:mover) { described_class.new([4, 3], board) }

      it 'returns the correct moves in each direction' do
        mover.board[4][3] = mover
        expected_output = [[4, 2], [4, 1], [4, 0], [4, 4], [4, 5], [4, 6], [4, 7]]
        expect(mover.horizontal_moves).to eql(expected_output)
      end

      it 'returns an empty array if both ways are blocked' do
        mover.board[4][2] = WhiteRook.new([4, 2], board)
        mover.board[4][4] = WhiteRook.new([4, 4], board)
        expected_output = []
        expect(mover.horizontal_moves).to eql(expected_output)
      end
    end
  end

  describe 'up_to_pos_one_moves' do
    context 'when a rook is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:mover) { described_class.new([7, 7], board) }

      it 'returns all moves with x index less than spot' do
        mover.board[7][7] = mover
        expected_output = [[7, 6], [7, 5], [7, 4], [7, 3], [7, 2], [7, 1], [7, 0]]
        expect(mover.up_to_pos_one_moves).to eql(expected_output)
      end

      it 'returns an empty array if blocked' do
        mover.board[7][6] = WhiteRook.new([7, 6], board)
        expected_output = []
        expect(mover.up_to_pos_one_moves).to eql(expected_output)
      end
    end
  end

  describe 'from_pos_one_moves' do
    context 'when a rook is selected' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:mover) { described_class.new([7, 3], board) }

      it 'returns all moves with x index higher tha spot' do
        mover.board[7][2] = mover
        expected_output = [[7, 4], [7, 5], [7, 6], [7, 7]]
        expect(mover.from_pos_one_moves).to eql(expected_output)
      end

      it 'returns an empty array if blocked' do
        mover.board[7][4] = WhiteRook.new([7, 4], board)
        expected_output = []
        expect(mover.from_pos_one_moves).to eql(expected_output)
      end
    end
  end

  describe 'castling' do
    context 'when the rook is selected and castling is available' do
      subject(:castle) { described_class.new([7, 0], nil) }

      before do
        allow(castle).to receive(:castling_left).and_return([7, 2])
        allow(castle).to receive(:castling_right).and_return([7, 5])
      end

      it 'returns the correct values' do
        expected_output = [[7, 2], [7, 5]]
        expect(castle.castling).to eql(expected_output)
      end

      it 'calls castling_left once' do
        expect(castle).to receive(:castling_left).once
        castle.castling
      end

      it 'calls castling_right once' do
        expect(castle).to receive(:castling_right).once
        castle.castling
      end
    end
  end

  describe 'castling_left' do # rubocop:disable Metrics/BlockLength
    context 'when castling to the left' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:castle) { described_class.new([7, 0], board) }

      it 'returns the correct move if path open' do
        castle.board[0][0] = castle
        castle.board[7][4] = WhiteKing.new([7, 4], board)
        expected_output = [7, 2]
        expect(castle.castling_left).to eql(expected_output)
      end

      it 'returns nil if path is blocked' do
        castle.board[7][2] = 12
        expected_output = nil
        expect(castle.castling_left).to eql(expected_output)
      end

      it 'returns nil if king is not present' do
        castle.board[7][2] = nil
        castle.board[7][4] = nil
        expected_output = nil
        expect(castle.castling_left).to eql(expected_output)
      end
    end
  end

  describe 'castling_right' do # rubocop:disable Metrics/BlockLength
    context 'when castling to the right' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:castle) { described_class.new([7, 7], board) }

      it 'returns the correct move if path is open' do
        castle.board[7][7] = castle
        castle.board[7][4] = WhiteKing.new([7, 4], board)
        expected_output = [7, 5]
        expect(castle.castling_right).to eql(expected_output)
      end

      it 'returns nil if path is blocked' do
        castle.board[7][5] = 12
        expected_output = nil
        expect(castle.castling_right).to eql(expected_output)
      end

      it 'returns nil if king is not present' do
        castle.board[7][5] = nil
        castle.board[7][4] = nil
        expected_output = nil
        expect(castle.castling_right).to eql(expected_output)
      end
    end
  end
end
