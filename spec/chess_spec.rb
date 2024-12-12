# frozen_string_literal: true

require_relative('./../lib/chess')
require_relative('./../lib/pieces/rook')
require_relative('./../lib/pieces/pawn')
require_relative('./../lib/pieces/bishop')
require_relative('./../lib/pieces/knight')
require_relative('./../lib/pieces/queen')

describe Game do # rubocop:disable Metrics/BlockLength
  describe '#play_round' do
    context 'when a round is started' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:round) { described_class.new }
      let(:piece) { BlackRook.new([1, 2], board) }

      before do
        round.board = board
        round.board[1][2] = piece
        allow(round).to receive(:show_board)
        allow(round).to receive(:select_piece_and_move).and_return([piece, [1, 3]])
      end

      it 'calls show_board once' do
        expect(round).to receive(:show_board).once
        round.play_round
      end

      it 'calls select_piece_and_move once' do
        expect(round).to receive(:select_piece_and_move).once
        round.play_round
      end
    end
  end

  describe '#select_piece_and_move' do # rubocop:disable Metrics/BlockLength
    context 'when a round is played' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:selected) { described_class.new }
      let(:piece) { BlackRook.new([1, 2], board) }

      before do
        allow(selected).to receive(:player_select_piece).and_return(piece)
        allow(selected).to receive(:player_input_move).and_return([0, 2])
      end

      it 'returns an array' do
        expect(selected.select_piece_and_move).to be_kind_of(Array)
      end

      it 'calls player_select_piece once' do
        expect(selected).to receive(:player_select_piece).once
        selected.select_piece_and_move
      end

      it 'calls player_input_move once' do
        expect(selected).to receive(:player_input_move).once
        selected.player_input_move(piece)
      end

      it 'returns the correct order' do
        expected_output = [piece, [0, 2]]
        expect(selected.select_piece_and_move).to eql(expected_output)
      end
    end
  end

  describe '#check_message' do
    context 'when a king is in check' do
      subject(:check) { described_class.new }

      it 'returns the correct message for a white king' do
        message = "Black king is in check!\n"
        expect { check.check_message }.to output(message).to_stdout
      end

      it 'returns the correct message for a black king' do
        check.change_player
        message = "White king is in check!\n"
        expect { check.check_message }.to output(message).to_stdout
      end
    end
  end

  describe '#player_input_move' do # rubocop:disable Metrics/BlockLength
    context 'when a round is played' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:getter) { described_class.new }
      let(:piece) { BlackRook.new([0, 2], board) }
      before do
        allow(getter).to receive(:gets).and_return('1,2')
        allow(getter).to receive(:valid_move).and_return(true)
      end

      it 'gets the move from user' do
        expect(getter).to receive(:gets).once
        getter.player_input_move(piece)
      end

      it 'returns an array' do
        expect(getter.player_input_move(piece)).to be_kind_of(Array)
      end

      it 'returns the correctly formatted output' do
        expected_output = [1, 2]
        expect(getter.player_input_move(piece)).to eql(expected_output)
      end

      it 'calls valid_move once' do
        expect(getter).to receive(:valid_move).once
        getter.player_input_move(piece)
      end

      it 'calls player_input_move once if valid_move returns false' do
        allow(getter).to receive(:valid_move).and_return(false, true)
        expect(getter).to receive(:player_input_move).once
        getter.player_input_move(piece)
      end
    end
  end

  describe '#valid_move' do # rubocop:disable Metrics/BlockLength
    context 'when a player chooses a move' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:valid) { described_class.new }
      let(:piece) { BlackRook.new([0, 2], board) }

      it 'returns true for valid move' do
        move = [1, 2]
        expected_output = true
        expect(valid.valid_move(piece, move)).to eql(expected_output)
      end

      it 'returns false if given move is not array of size 2' do
        move = [1, 2, 3]
        expected_output = false
        expect(valid.valid_move(piece, move)).to eql(expected_output)
      end

      it 'returns false if x is not a number' do
        move = ['a', 2]
        expected_output = false
        expect(valid.valid_move(piece, move)).to eql(expected_output)
      end

      it 'returns false if y is not a number' do
        move = [2, 'a']
        expected_output = false
        expect(valid.valid_move(piece, move)).to eql(expected_output)
      end

      it 'returns false if x not between 0 and 7 inclusive' do
        move = [21, 1]
        expected_output = false
        expect(valid.valid_move(piece, move)).to eql(expected_output)
      end

      it 'returns false if y not between 0 and 7 inclusive' do
        move = [1, 21]
        expected_output = false
        expect(valid.valid_move(piece, move)).to eql(expected_output)
      end

      it 'returns false if move not in available_moves of piece' do
        move = [3, 4]
        expected_output = false
        expect(valid.valid_move(piece, move)).to eql(expected_output)
      end
    end
  end

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
end
