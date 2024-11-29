# frozen_string_literal: true

require_relative('./../lib/pieces/pawn')

describe BlackPawn do
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
        expected_output = nil
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

  describe '#non_opener_moves' do
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
        expected_output = nil
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

describe WhitePawn do
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
        expected_output = nil
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
        expected_output = nil
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

# describe Pawn do
#   describe 'on_opening?' do
#     context 'when a pawn is on opening square' do
#       subject(:opener) { described_class.new('black', [1, 3], [], nil) }

#       it 'returns true for black pawn' do
#         expect(opener.on_opening?).to eql(true)
#       end

#       subject(:opener) { described_class.new('white', [6, 3], [], nil) }
#       it 'returns true for white pawn' do
#         expect(opener.on_opening?).to eql(true)
#       end
#     end
#     context 'When a pawn is not on the opening square' do
#       subject(:not_opener) { described_class.new('black', [4, 3], [], nil) }

#       it 'returns false for black pawn' do
#         expect(not_opener.on_opening?).to eql(false)
#       end

#       subject(:not_opener) { described_class.new('white', [4, 3], [], nil) }

#       it 'returns false for white pawn' do
#         expect(not_opener.on_opening?).to eql(false)
#       end
#     end
#   end
#   describe '#available_moves' do
#     context 'when a pawn is on its starting block' do
#       subject(:black_pawn) do
#         described_class.new('black', [1, 3], [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil]], nil)
#       end
#       it 'returns single and double openings for black pawn' do
#         expected_output = [[2, 3], [3, 3]]
#         expect(black_pawn.available_moves).to eql(expected_output)
#       end

#       subject(:white_pawn) do
#         described_class.new('white', [6, 3], [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil]], nil)
#       end
#       it 'returns single and double openings for white pawn' do
#         expected_output = [[5, 3], [4, 3]]
#         expect(white_pawn.available_moves).to eql(expected_output)
#       end
#     end

#     context 'when a pawn is not on its starting block' do
#       subject(:black_pawn) do
#         described_class.new('black', [5, 4], [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil]], nil)
#       end
#       it 'returns single move for black pawn' do
#         expected_output = [[6, 4]]
#         expect(black_pawn.available_moves).to eql(expected_output)
#       end

#       subject(:white_pawn) do
#         described_class.new('white', [5, 4], [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil]], nil)
#       end
#       it 'returns single move for white pawn' do
#         expected_output = [[4, 4]]
#         expect(white_pawn.available_moves).to eql(expected_output)
#       end
#     end

#     context 'when a pawn can capture' do
#       subject(:capturing_white_pawn) { described_class.new('white', [4, 3], [], nil) }
#       it 'returns the diagonal moves for a white pawn' do
#         capturing_white_pawn.board = [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                       [nil, nil, nil, nil, nil, nil, nil, nil],
#                                       [nil, nil, nil, nil, nil, nil, nil, nil],
#                                       [nil, nil, Pawn.new('black', [0, 0], [], nil), nil, Pawn.new('black', [0, 0], [], nil),
#                                        nil, nil, nil],
#                                       [nil, nil, nil, nil, nil, nil, nil, nil],
#                                       [nil, nil, nil, nil, nil, nil, nil, nil],
#                                       [nil, nil, nil, nil, nil, nil, nil, nil],
#                                       [nil, nil, nil, nil, nil, nil, nil, nil]]
#         included_output = [[3, 2], [3, 4]]
#         expect(capturing_white_pawn.available_moves).to include(included_output[0]).and include(included_output[1])
#       end

#       subject(:capturing_black_pawn) { described_class.new('black', [3, 3], [], nil) }
#       it 'returns the diagonal moves for a black pawn' do
#         capturing_black_pawn.board = [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                       [nil, nil, nil, nil, nil, nil, nil, nil],
#                                       [nil, nil, nil, nil, nil, nil, nil, nil],
#                                       [nil, nil, nil, nil, nil, nil, nil, nil],
#                                       [nil, nil, Pawn.new('white', [0, 0], [], nil), nil, Pawn.new('white', [0, 0], [], nil),
#                                        nil, nil, nil],
#                                       [nil, nil, nil, nil, nil, nil, nil, nil],
#                                       [nil, nil, nil, nil, nil, nil, nil, nil],
#                                       [nil, nil, nil, nil, nil, nil, nil, nil]]
#         included_output = [[4, 2], [4, 4]]
#         expect(capturing_black_pawn.available_moves).to include(included_output[0]).and include(included_output[1])
#       end
#     end

#     context 'when a pawn is blocked' do
#       subject(:blocked_black_pawn) do
#         described_class.new('black', [3, 3], [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, Pawn.new('white', [4, 3], [], nil), nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil]], nil)
#       end
#       it 'does not return any moves for a non-opening blocked black pawn' do
#         expect(blocked_black_pawn.available_moves).to eql([])
#       end

#       subject(:blocked_white_pawn) do
#         described_class.new('white', [5, 3], [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, Pawn.new('white', [4, 3], [], nil), nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil]], nil)
#       end
#       it 'does not return any moves for a non-opening blocked white pawn' do
#         expect(blocked_white_pawn.available_moves).to eql([])
#       end

#       subject(:blocked_double_opener) do
#         described_class.new('white', [6, 3], [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, Pawn.new('white', [4, 3], [], nil), nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil]], nil)
#       end
#       it 'returns only single opening when double is blocked' do
#         single_opening = [[5, 3]]
#         expect(blocked_double_opener.available_moves).to eql(single_opening)
#       end

#       subject(:no_opening_white) do
#         described_class.new('white', [6, 3], [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, Pawn.new('white', [4, 3], [], nil), nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil]], nil)
#       end
#       it 'returns no moves when single opening is blocked but double is open' do
#         expect(no_opening_white.available_moves).to eql([])
#       end

#       subject(:no_opening_black) do
#         described_class.new('black', [1, 1], [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, Pawn.new('white', [4, 3], [], nil), nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil],
#                                               [nil, nil, nil, nil, nil, nil, nil, nil]], nil)
#       end
#       it 'returns no moves when single opening is blocked but double is open' do
#         expect(no_opening_black.available_moves).to eql([])
#       end
#     end

#     context 'when the En Passant rule is in effect' do
#       subject(:captured) { described_class.new('white', [6, 5], [], nil) }
#       subject(:en_passant_black) do
#         described_class.new('black', [4, 4], [], { piece: captured, on_start: true, end: [4, 5], type: 'pawn' })
#       end
#       it 'returns the diagonal capture move for a black pawn' do
#         en_passant_black.board = [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                   [nil, nil, nil, nil, nil, nil, nil, nil],
#                                   [nil, nil, nil, nil, nil, nil, nil, nil],
#                                   [nil, nil, nil, nil, nil, nil, nil, nil],
#                                   [nil, nil, nil, nil, nil, Pawn.new('white', [4, 5], [], nil), nil, nil],
#                                   [nil, nil, nil, nil, nil, nil, nil, nil],
#                                   [nil, nil, nil, nil, nil, nil, nil, nil],
#                                   [nil, nil, nil, nil, nil, nil, nil, nil]]
#         expect(en_passant_black.available_moves).to include([5, 5])
#       end

#       subject(:en_passant_black_other) do
#         described_class.new('black', [4, 4], [], { piece: captured, on_start: true, end: [4, 3], type: 'pawn' })
#       end
#       it 'returns the other diagonal capture move for a black pawn' do
#         en_passant_black_other.board = [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                         [nil, nil, nil, nil, nil, nil, nil, nil],
#                                         [nil, nil, nil, nil, nil, nil, nil, nil],
#                                         [nil, nil, nil, nil, nil, nil, nil, nil],
#                                         [nil, nil, nil, Pawn.new('white', [4, 3], [], nil), nil, nil, nil, nil],
#                                         [nil, nil, nil, nil, nil, nil, nil, nil],
#                                         [nil, nil, nil, nil, nil, nil, nil, nil],
#                                         [nil, nil, nil, nil, nil, nil, nil, nil]]
#         expect(en_passant_black_other.available_moves).to include([5, 3])
#       end

#       subject(:black_capture) { described_class.new('black', [6, 5], [], nil) }
#       subject(:en_passant_white) do
#         described_class.new('white', [3, 1], [], { piece: black_capture, on_start: true, end: [3, 2], type: 'pawn' })
#       end

#       it 'returns the diagonal capture move for a white pawn' do
#         en_passant_white.board = [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                   [nil, nil, nil, nil, nil, nil, nil, nil],
#                                   [nil, nil, nil, nil, nil, nil, nil, nil],
#                                   [nil, nil, Pawn.new('black', [4, 5], [], nil), nil, nil, nil, nil, nil],
#                                   [nil, nil, nil, nil, nil, nil, nil, nil],
#                                   [nil, nil, nil, nil, nil, nil, nil, nil],
#                                   [nil, nil, nil, nil, nil, nil, nil, nil],
#                                   [nil, nil, nil, nil, nil, nil, nil, nil]]
#         expect(en_passant_white.available_moves).to include([2, 2])
#       end

#       subject(:en_passant_white_other) do
#         described_class.new('white', [3, 1], [], { piece: black_capture, on_start: true, end: [3, 0], type: 'pawn' })
#       end

#       it 'returns the other diagonal capture move for a white pawn' do
#         en_passant_white_other.board = [[nil, nil, nil, nil, nil, nil, nil, nil],
#                                         [nil, nil, nil, nil, nil, nil, nil, nil],
#                                         [nil, nil, nil, nil, nil, nil, nil, nil],
#                                         [Pawn.new('black', [3, 0], [], nil), nil, nil, nil, nil, nil, nil, nil],
#                                         [nil, nil, nil, nil, nil, nil, nil, nil],
#                                         [nil, nil, nil, nil, nil, nil, nil, nil],
#                                         [nil, nil, nil, nil, nil, nil, nil, nil],
#                                         [nil, nil, nil, nil, nil, nil, nil, nil]]
#         expect(en_passant_white_other.available_moves).to include([2, 0])
#       end
#     end
#   end
# end
