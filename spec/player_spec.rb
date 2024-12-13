# frozen_string_literal: true

require_relative('./../lib/player')

describe BlackPlayer do # rubocop:disable Metrics/BlockLength
  describe '#create_pawns' do
    context 'when a player is created' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:player) { described_class.new(board) }

      it 'returns an array' do
        expect(player.create_pawns).to be_kind_of(Array)
      end

      it 'returns an array of length 8' do
        output = player.create_pawns
        expect(output.length).to eql(8)
      end
    end
  end

  describe '#create_non_pawns' do
    context 'when a player is initialized' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:player) { described_class.new(board) }

      it 'returns an array' do
        expect(player.create_non_pawns).to be_kind_of(Array)
      end

      it 'returns an array of length 8' do
        output = player.create_non_pawns
        expect(output.length).to eql(8)
      end
    end
  end

  describe 'legal_moves' do
    context 'when a round is played' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:legal) { described_class.new(board) }
      it 'returns all legal moves for the current player' do
        legal.board[0] = legal.non_pawns
        legal.board[1] = legal.pawns
        expected_output = [[2, 0], [3, 0], [2, 1], [3, 1], [2, 2], [3, 2], [2, 3], [3, 3], [2, 4], [3, 4], [2, 5],
                           [3, 5], [2, 6], [3, 6], [2, 7], [3, 7]]
        expect(legal.legal_moves).to eql(expected_output)
      end
    end

    context 'when a player is in more realistic, complex situations' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:legal) { described_class.new(board) }

      it 'returns empty array if player is in check and cannot move without check' do
        expected_output = []
        legal.pawns = [nil, nil, nil, nil, nil, nil, nil, nil]
        legal.non_pawns = [nil, nil, nil, nil, BlackKing.new([7, 4], legal.board), nil, nil, nil]
        legal.pieces = legal.pawns + legal.non_pawns
        legal.board[7] = legal.non_pawns
        legal.board[6] = [nil, nil, nil, WhiteRook.new([0, 0], legal.board), WhiteRook.new([0, 0], legal.board),
                          WhiteRook.new([0, 0], legal.board), nil, nil]
        expect(legal.legal_moves).to eql(expected_output)
      end

      it 'returns empty array if player is not in check but cannot move due to check' do
        expected_output = []
        legal.pawns = [nil, nil, nil, nil, nil, nil, nil, nil]
        legal.non_pawns = [nil, nil, nil, nil, BlackKing.new([6, 4], legal.board), nil, nil, nil]
        legal.pieces = legal.pawns + legal.non_pawns
        legal.board[5] = [nil, nil, nil, WhiteRook.new([0, 0], legal.board), nil, WhiteRook.new([0, 0], legal.board), nil,
                          nil]
        legal.board[6] = legal.non_pawns
        legal.board[7] =
          [nil, nil, nil, WhiteRook.new([0, 0], legal.board), nil, WhiteRook.new([0, 0], legal.board), nil, nil]
        expect(legal.legal_moves).to eql(expected_output)
      end

      it 'returns the correct value if player has more than one piece but cannot move out of check' do
        expected_output = []
        legal.pawns = [BlackRook.new([6, 0], legal.board), nil, nil, nil, nil, nil, nil, nil]
        legal.non_pawns = [nil, nil, nil, nil, BlackKing.new([7, 4], legal.board), nil, nil, nil]
        legal.pieces = legal.pawns + legal.non_pawns
        legal.board[7] = legal.non_pawns
        legal.board[6] =
          [legal.pawns[0], nil, nil, WhiteRook.new([6, 3], legal.board), WhiteRook.new([6, 4], legal.board),
           WhiteRook.new([6, 5], legal.board), nil, nil]
        expect(legal.legal_moves).to eql(expected_output)
      end
    end
  end
end

describe WhitePlayer do # rubocop:disable Metrics/BlockLength
  describe '#create_pawns' do
    context 'when a player is created' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:player) { described_class.new(board) }

      it 'returns an array' do
        expect(player.create_pawns).to be_kind_of(Array)
      end

      it 'returns an array of length 8' do
        output = player.create_pawns
        expect(output.length).to eql(8)
      end
    end
  end

  describe '#create_non_pawns' do
    context 'when a player is initialized' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:player) { described_class.new(board) }

      it 'returns an array' do
        expect(player.create_non_pawns).to be_kind_of(Array)
      end

      it 'returns an array of length 8' do
        output = player.create_non_pawns
        expect(output.length).to eql(8)
      end
    end
  end

  describe 'legal_moves' do # rubocop:disable Metrics/BlockLength
    context 'when a round is played' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:legal) { described_class.new(board) }
      it 'returns all legal moves for the current player' do
        legal.board[7] = legal.non_pawns
        legal.board[6] = legal.pawns
        expected_output = [[5, 0], [4, 0], [5, 1], [4, 1], [5, 2], [4, 2], [5, 3], [4, 3], [5, 4], [4, 4], [5, 5],
                           [4, 5], [5, 6], [4, 6], [5, 7], [4, 7]]
        expect(legal.legal_moves).to eql(expected_output)
      end
    end

    context 'when a player is in more complex situations' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:legal) { described_class.new(board) }

      it 'returns empty array if player is in check and cannot move without check' do
        expected_output = []
        legal.pawns = [nil, nil, nil, nil, nil, nil, nil, nil]
        legal.non_pawns = [nil, nil, nil, nil, WhiteKing.new([0, 4], legal.board), nil, nil, nil]
        legal.pieces = legal.pawns + legal.non_pawns
        legal.board[0] = legal.non_pawns
        legal.board[1] = [nil, nil, nil, BlackRook.new([0, 0], legal.board), BlackRook.new([0, 0], legal.board),
                          BlackRook.new([0, 0], legal.board), nil, nil]
        expect(legal.legal_moves).to eql(expected_output)
      end

      it 'returns empty array if player is not in check but cannot move due to check' do
        expected_output = []
        legal.pawns = [nil, nil, nil, nil, nil, nil, nil, nil]
        legal.non_pawns = [nil, nil, nil, nil, WhiteKing.new([1, 4], legal.board), nil, nil, nil]
        legal.pieces = legal.pawns + legal.non_pawns
        legal.board[2] = [nil, nil, nil, BlackRook.new([0, 0], legal.board), nil, BlackRook.new([0, 0], legal.board), nil,
                          nil]
        legal.board[1] = legal.non_pawns
        legal.board[0] =
          [nil, nil, nil, BlackRook.new([0, 0], legal.board), nil, BlackRook.new([0, 0], legal.board), nil, nil]
        expect(legal.legal_moves).to eql(expected_output)
      end

      it 'returns the correct value if player has more than one piece but cannot move out of check' do
        expected_output = []
        legal.pawns = [WhiteRook.new([0, 0], legal.board), nil, nil, nil, nil, nil, nil, nil]
        legal.non_pawns = [nil, nil, nil, nil, WhiteKing.new([0, 4], legal.board), nil, nil, nil]
        legal.pieces = legal.pawns + legal.non_pawns
        legal.board[0] = legal.non_pawns
        legal.board[1] = [legal.pawns[0], nil, nil, BlackRook.new([0, 0], legal.board), BlackRook.new([0, 0], legal.board),
                          BlackRook.new([0, 0], legal.board), nil, nil]
        expect(legal.legal_moves).to eql(expected_output)
      end
    end
  end
end
