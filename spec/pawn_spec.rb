# frozen_string_literal: true

require_relative('./../lib/pieces/pawn')

describe BlackPawn do # rubocop:disable Metrics/BlockLength
  describe '#initialize' do
    context 'when a pawn is initialized' do
      it 'returns true if row num is 1' do
        expect(described_class.new([1, 0], nil, nil).opener).to be true
      end

      it 'returns false if row num is more than 1' do
        expect(described_class.new([3, 0], nil, nil).opener).to be false
      end
    end
  end

  describe '#moves' do # rubocop:disable Metrics/BlockLength
    context 'when a round is played' do # rubocop:disable Metrics/BlockLength
      subject(:mover) { described_class.new([0, 2], nil, nil) }

      before do
        allow(mover).to receive(:opening_moves).and_return([[1, 2]])
        allow(mover).to receive(:non_opening_moves).and_return([])
        allow(mover).to receive(:en_passant).and_return([[2, 3], [2, 0]])
        allow(mover).to receive(:capture_moves).and_return([])
      end

      it 'calls opening_moves once if @opener is true' do
        mover.opener = true
        expect(mover).to receive(:opening_moves).once
        mover.moves
      end

      it 'calls non_opening_moves if @opener is false' do
        mover.opener = false
        expect(mover).to receive(:non_opening_moves).once
        mover.moves
      end

      it 'calls en_passant once' do
        expect(mover).to receive(:en_passant).once
        mover.moves
      end

      it 'calls capture_moves once' do
        expect(mover).to receive(:capture_moves).once
        mover.moves
      end

      it 'returns the correct values' do
        mover.opener = true
        expected_output = [[1, 2], [2, 3], [2, 0]]
        expect(mover.moves).to eql(expected_output)
      end
    end
  end

  describe '#opening_moves' do # rubocop:disable Metrics/BlockLength
    context 'when a pawn is on its opening square' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:starting_square) { described_class.new([1, 3], board, nil) }
      it 'returns both moves when neither are not filled' do
        starting_square.board[1][3] = starting_square
        expected_output = [[2, 3], [3, 3]]
        expect(starting_square.opening_moves).to eql(expected_output)
      end

      it 'returns only the first move if the second is filled' do
        starting_square.board[3][3] = 12
        expected_output = [[2, 3]]
        expect(starting_square.opening_moves).to eql(expected_output)
      end

      it 'returns nil if the first move is blocked' do
        starting_square.board[2][3] = 12
        expected_output = []
        expect(starting_square.opening_moves).to eql(expected_output)
      end
    end
  end

  describe '#capture_moves' do
    context "when a pawn can capture the other player's piece" do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:captured) { WhitePawn.new([4, 4], board, nil) }
      subject(:capturer) { described_class.new([3, 3], board, nil) }

      it 'returns move for capture to left' do
        capturer.board[3][3] = capturer
        capturer.board[4][4] = captured
        expected_output = [[4, 4]]
        expect(capturer.capture_moves).to eql(expected_output)
      end

      it 'returns move for capture to right' do
        capturer.board[4][2] = captured
        capturer.board[4][4] = nil
        expected_output = [[4, 2]]
        expect(capturer.capture_moves).to eql(expected_output)
      end
    end
  end

  describe '#non_opening_moves' do
    context 'when a pawn is not on an opening block' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]
      subject(:single_mover) { described_class.new([3, 3], board, nil) }
      it 'returns only the move in front of it' do
        single_mover.board[3][3] = single_mover
        expected_output = [4, 3]
        expect(single_mover.non_opening_moves).to eql(expected_output)
      end

      it 'returns nil if single space is blocked' do
        single_mover.board[4][3] = 12
        expected_output = []
        expect(single_mover.non_opening_moves).to eql(expected_output)
      end
    end
  end

  describe '#en_passant_left' do
    context 'when the en passant rule is in effect for a black pawn to the left' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]
      subject(:captured) { WhitePawn.new([4, 4], board, nil) }
      subject(:ep) { described_class.new([4, 3], board, { piece: captured, from_start: true }) }
      it 'returns the en passant move to the left' do
        ep.board[4][4] = captured
        ep.board[4][3] = ep
        expected_output = [5, 4]
        expect(ep.en_passant_left).to eql(expected_output)
      end
    end
  end

  describe '#en_passant_right' do
    context 'when the en passant rule is in effect for a black pawn to the right' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]
      subject(:captured) { WhitePawn.new([4, 2], board, nil) }
      subject(:ep) { described_class.new([4, 3], board, { piece: captured, from_start: true }) }
      it 'returns the en passant move to the right' do
        ep.board[4][2] = captured
        ep.board[4][3] = ep
        expected_output = [5, 2]
        expect(ep.en_passant_right).to eql(expected_output)
      end
    end
  end

  describe '#en_passant' do
    context 'when the en passant rule is in effect' do
      subject(:ep) { described_class.new([4, 3], nil, nil) }
      before do
        allow(ep).to receive(:en_passant_left).and_return([5, 4])
        allow(ep).to receive(:en_passant_right).and_return([5, 2])
      end

      it 'calls en_passant for the left' do
        expect(ep).to receive(:en_passant_left).once
        ep.en_passant
      end

      it 'calls en_passant for the right' do
        expect(ep).to receive(:en_passant_right).once
        ep.en_passant
      end

      it 'returns both sides' do
        expected_output = [[5, 4], [5, 2]]
        expect(ep.en_passant).to eql(expected_output)
      end
    end
  end
end

describe WhitePawn do # rubocop:disable Metrics/BlockLength
  describe '#initialize' do
    context 'when a pawn is initialized' do
      it 'returns true if row num is 6' do
        expect(described_class.new([6, 0], nil, nil).opener).to be true
      end

      it 'returns false if row num is less than 6' do
        expect(described_class.new([4, 0], nil, nil).opener).to be false
      end
    end
  end

  describe '#moves' do # rubocop:disable Metrics/BlockLength
    context 'when a round is played' do # rubocop:disable Metrics/BlockLength
      subject(:mover) { described_class.new([0, 2], nil, nil) }

      before do
        allow(mover).to receive(:opening_moves).and_return([[1, 2]])
        allow(mover).to receive(:non_opening_moves).and_return([])
        allow(mover).to receive(:en_passant).and_return([[2, 3], [2, 0]])
        allow(mover).to receive(:capture_moves).and_return([])
      end

      it 'calls opening_moves once if @opener is true' do
        mover.opener = true
        expect(mover).to receive(:opening_moves).once
        mover.moves
      end

      it 'calls non_opening_moves if @opener is false' do
        mover.opener = false
        expect(mover).to receive(:non_opening_moves).once
        mover.moves
      end

      it 'calls en_passant once' do
        expect(mover).to receive(:en_passant).once
        mover.moves
      end

      it 'calls capture_moves once' do
        expect(mover).to receive(:capture_moves).once
        mover.moves
      end

      it 'returns the correct values' do
        mover.opener = true
        expected_output = [[1, 2], [2, 3], [2, 0]]
        expect(mover.moves).to eql(expected_output)
      end
    end
  end

  describe '#opening_moves' do # rubocop:disable Metrics/BlockLength
    context 'when a pawn is on its opening square' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:starting_square) { described_class.new([6, 3], board, nil) }
      it 'returns both moves when neither are filled' do
        starting_square.board[6][3] = starting_square
        expected_output = [[5, 3], [4, 3]]
        expect(starting_square.opening_moves).to eql(expected_output)
      end

      it 'returns only the first move if the second is filled' do
        starting_square.board[4][3] = 12
        expected_output = [[5, 3]]
        expect(starting_square.opening_moves).to eql(expected_output)
      end

      it 'returns nil if the first move is blocked' do
        starting_square.board[5][3] = 12
        expected_output = []
        expect(starting_square.opening_moves).to eql(expected_output)
      end
    end
  end

  describe '#capture_moves' do
    context "when a pawn can capture the other player's piece" do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:captured) { BlackPawn.new([3, 3], board, nil) }
      subject(:capturer) { described_class.new([4, 4], board, nil) }

      it 'returns move for capture to left' do
        capturer.board[4][4] = capturer
        capturer.board[3][3] = captured
        expected_output = [[3, 3]]
        expect(capturer.capture_moves).to eql(expected_output)
      end

      it 'returns move for capture to right' do
        capturer.board[3][5] = captured
        capturer.board[3][3] = nil
        expected_output = [[3, 5]]
        expect(capturer.capture_moves).to eql(expected_output)
      end
    end
  end

  describe 'non_opening_moves' do
    context 'when a pawn is not on an opening block' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:single_mover) { described_class.new([4, 3], board, nil) }
      it 'returns only the move in front of it' do
        single_mover.board[4][3] = single_mover
        expected_output = [3, 3]
        expect(single_mover.non_opening_moves).to eql(expected_output)
      end

      it 'returns nil of single space is blocked' do
        single_mover.board[3][3] = 12
        expected_output = []
        expect(single_mover.non_opening_moves).to eql(expected_output)
      end
    end
  end

  describe 'en_passant_left' do
    context 'when the en passant rule is in effect for a white pawn to the left' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:captured) { BlackPawn.new([3, 4], board, nil) }
      subject(:ep) { described_class.new([3, 3], board, { piece: captured, from_start: true }) }
      it 'returns the en passant move to the left' do
        ep.board[3][3] = ep
        ep.board[3][4] = captured
        expected_output = [2, 4]
        expect(ep.en_passant_left).to eql(expected_output)
      end
    end
  end

  describe 'en_passant_right' do
    context 'when the en passant rule is in effect for a white pawn to the right' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]
      subject(:captured) { BlackPawn.new([3, 2], board, nil) }
      subject(:ep) { described_class.new([3, 3], board, { piece: captured, from_start: true }) }
      it 'returns the en passant move to the right' do
        ep.board[3][3] = ep
        ep.board[3][2] = captured
        expected_output = [2, 2]
        expect(ep.en_passant_right).to eql(expected_output)
      end
    end
  end

  describe 'en_passant' do
    context 'when the en passant rule is in effect' do
      subject(:ep) { described_class.new([3, 3], nil, nil) }
      before do
        allow(ep).to receive(:en_passant_left).and_return([2, 4])
        allow(ep).to receive(:en_passant_right).and_return([2, 2])
      end

      it 'calls en_passant for the left' do
        expect(ep).to receive(:en_passant_left).once
        ep.en_passant
      end

      it 'calls en_passant for the right' do
        expect(ep).to receive(:en_passant_right).once
        ep.en_passant
      end

      it 'returns both sides' do
        expected_output = [[2, 4], [2, 2]]
        expect(ep.en_passant).to eql(expected_output)
      end
    end
  end
end
