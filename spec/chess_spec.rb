# frozen_string_literal: true

require_relative('./../lib/chess')
require_relative('./../lib/pieces/rook')
require_relative('./../lib/pieces/pawn')
require_relative('./../lib/pieces/bishop')
require_relative('./../lib/pieces/knight')
require_relative('./../lib/pieces/queen')

describe Game do # rubocop:disable Metrics/BlockLength
  describe '#change_player' do
    context 'when a round is over' do
      subject(:player_turn) { described_class.new }
      it 'changes the player from player one to player two' do
        expect { player_turn.change_player }.to change {
          player_turn.instance_variable_get(:@current_player)
        }.from('white').to('black')
      end

      it 'changes the player from player two to player one' do
        player_turn.change_player
        expect { player_turn.change_player }.to change {
          player_turn.instance_variable_get(:@current_player)
        }.from('black').to('white')
      end
    end
  end

  describe '#check_pawns' do
    context 'when a moves is over' do
      subject(:pawn_change) { described_class.new }

      it 'calls pawn_change_white once if white is current player' do
        expect(pawn_change).to receive(:pawn_change_white).once
        pawn_change.check_pawns
      end

      it 'calls pawn_change_black once if black is current player' do
        pawn_change.change_player
        expect(pawn_change).to receive(:pawn_change_black).once
        pawn_change.check_pawns
      end
    end
  end

  describe '#pawn_change_white' do # rubocop:disable Metrics/BlockLength
    context 'when a move is over' do # rubocop:disable Metrics/BlockLength
      subject(:rows) { described_class.new }

      before do
        allow(rows).to receive(:create_new_piece_white)
        allow(rows).to receive(:pawn_change)
        rows.board[0][7] = WhitePawn.new([0, 7], rows.board, nil)
      end

      it 'checks each spot in row 0 of the board' do
        expect(rows.board[0]).to receive(:each_with_index).once
        rows.pawn_change_white
      end

      it 'calls create_new_piece_white if pawn is on row 7' do
        expect(rows).to receive(:create_new_piece_white).once
        rows.pawn_change_white
      end

      it 'calls pawn_change if pawn is on row 7' do
        expect(rows).to receive(:pawn_change).once
        rows.pawn_change_white
      end

      it 'does not call anything if no white pawn present' do
        rows.board[0][7] = WhiteRook.new([0, 7], rows.board)
        expected_output = nil
        expect(rows.pawn_change_white).to eql(expected_output)
      end

      it 'does not call anything if nil' do
        rows.board[0][7] = nil
        expected_output = nil
        expect(rows.pawn_change_white).to eql(expected_output)
      end
    end
  end

  describe '#pawn_change_black' do # rubocop:disable Metrics/BlockLength
    context 'when a move is over' do # rubocop:disable Metrics/BlockLength
      subject(:rows) { described_class.new }

      before do
        allow(rows).to receive(:create_new_piece_black)
        allow(rows).to receive(:pawn_change)
        rows.board[7][0] = BlackPawn.new([7, 0], rows.board, nil)
      end

      it 'checks each spot in row 7 of the board' do
        expect(rows.board[7]).to receive(:each_with_index).once
        rows.pawn_change_black
      end

      it 'calls create_new_piece_black if pawn is on row 0' do
        expect(rows).to receive(:create_new_piece_black).once
        rows.pawn_change_black
      end

      it 'calls pawn_change if pawn is on row 0' do
        expect(rows).to receive(:pawn_change).once
        rows.pawn_change_black
      end

      it 'does not call anything if no black pawn present' do
        rows.board[7][0] = BlackRook.new([7, 0], rows.board)
        expected_output = nil
        expect(rows.pawn_change_black).to eql(expected_output)
      end

      it 'does not call anything if nil' do
        rows.board[7][0] = nil
        expected_output = nil
        expect(rows.pawn_change_black).to eql(expected_output)
      end
    end
  end

  describe '#pawn_change' do
    context 'when a pawn reached the end of the board' do
      subject(:final_pawn) { described_class.new }

      before do
        allow(final_pawn).to receive(:gets).and_return("rook\n")
        allow(final_pawn).to receive(:valid_piece).and_return(true)
      end

      it 'asks the user what piece they want their pawn to become' do
        message = "What piece would you like? \n"
        expect { final_pawn.pawn_change }.to output(message).to_stdout
      end

      it 'returns the correct value' do
        allow(final_pawn).to receive(:puts)
        expected_output = 'rook'
        expect(final_pawn.pawn_change).to eql(expected_output)
      end

      it 'rejects invalid pieces' do
        allow(final_pawn).to receive(:valid_piece).and_return(false, true)
        expect(final_pawn).to receive(:pawn_change).once
        final_pawn.pawn_change
      end
    end
  end

  describe '#valid_piece' do
    context 'when a piece is chosen' do
      subject(:valid) { described_class.new }
      it 'accepts valid piece' do
        piece = 'rook'
        expected_output = true
        expect(valid.valid_piece(piece)).to eql(expected_output)
      end

      it 'rejects invalid pieces' do
        piece = 'pawn'
        expected_output = false
        expect(valid.valid_piece(piece)).to eql(expected_output)
      end

      it 'does not care what case the string is in' do
        piece = 'KniGHt'
        expected_output = true
        expect(valid.valid_piece(piece)).to eql(expected_output)
      end
    end
  end

  describe '#create_new_piece_black' do # rubocop:disable Metrics/BlockLength
    context 'when a black pawn reaches the last row' do
      subject(:new_piece) { described_class.new }
      before do
        new_piece.board[7][0] = BlackPawn.new([7, 0], new_piece.board, nil)
      end
      it 'creates the correct piece for a rook' do
        expect do
          new_piece.create_new_piece_black('rook', [7, 0])
        end.to change { new_piece.board[7][0].class }.from(BlackPawn).to(BlackRook)
      end

      it 'creates the correct piece for a bishop' do
        expect do
          new_piece.create_new_piece_black('bishop', [7, 0])
        end.to change { new_piece.board[7][0].class }.from(BlackPawn).to(BlackBishop)
      end

      it 'creates the correct piece for a knight' do
        expect do
          new_piece.create_new_piece_black('knight', [7, 0])
        end.to change { new_piece.board[7][0].class }.from(BlackPawn).to(BlackKnight)
      end

      it 'creates the correct piece for a queen' do
        expect do
          new_piece.create_new_piece_black('queen', [7, 0])
        end.to change { new_piece.board[7][0].class }.from(BlackPawn).to(BlackQueen)
      end
    end
  end

  describe '#create_new_piece_white' do # rubocop:disable Metrics/BlockLength
    context 'when a black pawn reaches the last row' do
      subject(:new_piece) { described_class.new }
      before do
        new_piece.board[0][6] = WhitePawn.new([0, 6], new_piece.board, nil)
      end
      it 'creates the correct piece for a rook' do
        expect do
          new_piece.create_new_piece_white('rook', [0, 6])
        end.to change { new_piece.board[0][6].class }.from(WhitePawn).to(WhiteRook)
      end

      it 'creates the correct piece for a bishop' do
        expect do
          new_piece.create_new_piece_white('bishop', [0, 6])
        end.to change { new_piece.board[0][6].class }.from(WhitePawn).to(WhiteBishop)
      end

      it 'creates the correct piece for a knight' do
        expect do
          new_piece.create_new_piece_white('knight', [0, 6])
        end.to change { new_piece.board[0][6].class }.from(WhitePawn).to(WhiteKnight)
      end

      it 'creates the correct piece for a queen' do
        expect do
          new_piece.create_new_piece_white('queen', [0, 6])
        end.to change { new_piece.board[0][6].class }.from(WhitePawn).to(WhiteQueen)
      end
    end
  end

  describe '#check_message' do
    context 'when a king is in check' do
      subject(:check) { described_class.new }

      it 'returns the correct message for a white king' do
        message = "White king is in check!\n"
        expect { check.check_message }.to output(message).to_stdout
      end

      it 'returns the correct message for a black king' do
        check.change_player
        message = "Black king is in check!\n"
        expect { check.check_message }.to output(message).to_stdout
      end
    end
  end
end
