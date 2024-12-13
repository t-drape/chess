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

      it 'updates board' do
        before = [nil, nil, nil, nil, nil, nil, nil, nil]
        after = [WhitePawn, WhitePawn, WhitePawn, WhitePawn, WhitePawn, WhitePawn, WhitePawn, WhitePawn]

        expect { player.create_pawns(board) }.to change { board[6] }.from(before).to(after)
      end

      it 'returns an array' do
        expect(player.create_pawns(board)).to be_kind_of(Array)
      end

      it 'returns an array of length 8' do
        output = player.create_pawns(board)
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

      it 'updates board' do
        before = [nil, nil, nil, nil, nil, nil, nil, nil]
        after = [WhiteRook, WhiteKnight, WhiteBishop, WhiteQueen, WhiteKing, WhiteBishop, WhiteKnight, WhiteRook]

        expect { player.create_non_pawns(board) }.to change { board[7] }.from(before).to(after)
      end

      it 'returns an array' do
        expect(player.create_non_pawns(board)).to be_kind_of(Array)
      end

      it 'returns an array of length 8' do
        output = player.create_non_pawns(board)
        expect(output.length).to eql(8)
      end
    end
  end
end
