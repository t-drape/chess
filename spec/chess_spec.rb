# frozen_string_literal: true

require_relative('./../lib/chess')
require_relative('./../lib/pieces/rook')
require_relative('./../lib/pieces/pawn')
require_relative('./../lib/pieces/bishop')
require_relative('./../lib/pieces/knight')
require_relative('./../lib/pieces/queen')

describe Game do # rubocop:disable Metrics/BlockLength
  describe '#initialize' do
    context 'when a game is started' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]
      it 'creates a new WhitePlayer' do
        new_class = described_class.new
        player_one = new_class.instance_variable_get(:@player_one)
        expect(player_one).to be_kind_of(WhitePlayer)
      end

      it 'creates a new BlackPlayer' do
        new_class = described_class.new
        player_two = new_class.instance_variable_get(:@player_two)
        expect(player_two).to be_kind_of(BlackPlayer)
      end
    end
  end

  describe '#show_board' do
    context 'when the board needs to be shown' do
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:each_row_of_board) { described_class.new }
      it 'calls each for the board' do
        expect(each_row_of_board.board).to receive(:each)
        each_row_of_board.show_board
      end

      it 'outputs the correct value' do
        each_row_of_board.board = board
        expected_output = "[nil, nil, nil, nil, nil, nil, nil, nil]\n[nil, nil, nil, nil, nil, nil, nil, nil]\n[nil, nil, nil, nil, nil, nil, nil, nil]\n[nil, nil, nil, nil, nil, nil, nil, nil]\n[nil, nil, nil, nil, nil, nil, nil, nil]\n[nil, nil, nil, nil, nil, nil, nil, nil]\n[nil, nil, nil, nil, nil, nil, nil, nil]\n[nil, nil, nil, nil, nil, nil, nil, nil]\n"
        expect { each_row_of_board.show_board }.to output(expected_output).to_stdout
      end
    end
  end

  describe '#play_game' do # rubocop:disable Metrics/BlockLength
    context 'when a game is started' do # rubocop:disable Metrics/BlockLength
      subject(:game_on) { described_class.new }

      it 'calls start message once' do
        allow(game_on).to receive(:set_board)
        allow(game_on).to receive(:set_piece_boards)
        allow(game_on).to receive(:end_message)
        allow(game_on).to receive(:end_game_check).and_return(true)
        expect(game_on).to receive(:start_message).once
        game_on.play_game
      end

      it 'calls set board once' do
        allow(game_on).to receive(:start_message)
        allow(game_on).to receive(:set_piece_boards)
        allow(game_on).to receive(:end_message)
        allow(game_on).to receive(:end_game_check).and_return(true)
        expect(game_on).to receive(:set_board).once
        game_on.play_game
      end

      it 'calls set piece boards once' do
        allow(game_on).to receive(:start_message)
        allow(game_on).to receive(:set_board)
        allow(game_on).to receive(:end_message)
        allow(game_on).to receive(:end_game_check).and_return(true)
        expect(game_on).to receive(:set_piece_boards).once
        game_on.play_game
      end

      it 'calls play round until end game check returns true' do
        allow(game_on).to receive(:start_message)
        allow(game_on).to receive(:set_board)
        allow(game_on).to receive(:set_piece_boards)
        allow(game_on).to receive(:end_message)
        allow(game_on).to receive(:end_game_check).and_return(false, true)
        expect(game_on).to receive(:play_round).once
        game_on.play_game
      end

      it 'calls end_message once after loop' do
        allow(game_on).to receive(:start_message)
        allow(game_on).to receive(:set_board)
        allow(game_on).to receive(:set_piece_boards)
        allow(game_on).to receive(:end_game_check).and_return(true)
        expect(game_on).to receive(:end_message).once
        game_on.play_game
      end
    end
  end

  describe '#end_message' do
    context 'when a game is over' do
      subject(:messages) { described_class.new }
      it 'outputs the correct message for a draw' do
        draw_message = "It's a Draw!\n"
        expect { messages.end_message(nil) }.to output(draw_message).to_stdout
      end

      it 'outputs the correct message for a win' do
        win_message = "Black Player wins!\n"
        player_two = messages.instance_variable_get(:@player_two)
        expect { messages.end_message(player_two) }.to output(win_message).to_stdout
      end
    end
  end

  describe '#set_board' do
    context 'when play_game is called' do
      subject(:board_setter) { described_class.new }
      it 'sets the first row to the correct values' do
        player_two = board_setter.instance_variable_get(:@player_two)
        first_row_pieces = player_two.pieces[8..]
        expect { board_setter.set_board }.to change { board_setter.board[0] }.to(first_row_pieces)
      end

      it 'sets the second row to the correct values' do
        player_two = board_setter.instance_variable_get(:@player_two)
        second_row_pieces = player_two.pieces[0..7]
        expect { board_setter.set_board }.to change { board_setter.board[1] }.to(second_row_pieces)
      end

      it 'sets the seventh row to the correct values' do
        player_one = board_setter.instance_variable_get(:@player_one)
        seventh_row_pieces = player_one.pieces[0..7]
        expect { board_setter.set_board }.to change { board_setter.board[6] }.to(seventh_row_pieces)
      end

      it 'sets the eighth row to the correct values' do
        player_one = board_setter.instance_variable_get(:@player_one)
        eighth_row_pieces = player_one.pieces[8..]
        expect { board_setter.set_board }.to change { board_setter.board[7] }.to(eighth_row_pieces)
      end
    end
  end

  describe '#set_piece_boards' do
    context 'before a round is played' do
      subject(:piece_board) { described_class.new }
      it "sets each piece's board variable to the game board" do
        player_one = piece_board.instance_variable_get(:@player_one)
        player_two = piece_board.instance_variable_get(:@player_two)
        all_pieces = player_one.pieces + player_two.pieces
        all_pieces = all_pieces.map(&:board)
        piece_board.set_piece_boards
        expect(all_pieces).to all eql(piece_board.board)
      end
    end
  end

  describe '#end_game_check' do
    context 'when a round is over' do
      subject(:checker) { described_class.new }

      before do
        allow(checker).to receive(:voluntary_draw?).and_return(false)
        allow(checker.instance_variable_get(:@current_player)).to receive(:legal_moves).and_return([1, 2, 3])
      end

      it 'returns true if both players agree to a draw' do
        allow(checker).to receive(:voluntary_draw?).and_return(true)
        expect(checker.end_game_check).to eql(true)
      end

      it 'returns true if no legal moves are available' do
        allow(checker.instance_variable_get(:@current_player)).to receive(:legal_moves).and_return([])
        expect(checker.end_game_check).to eql(true)
      end

      it 'updates winner variable if no legal moves and king is in check' do
        allow(checker.instance_variable_get(:@current_player)).to receive(:legal_moves).and_return([])
        allow(checker.instance_variable_get(:@current_player).pieces[12]).to receive(:in_check?).and_return(true)
        expect { checker.end_game_check }.to change {
          checker.instance_variable_get(:@winner)
        }.from(nil).to(checker.instance_variable_get(:@player_two))
      end

      it 'returns false otherwise' do
        expect(checker.end_game_check).to eql(false)
      end
    end
  end

  describe '#voluntary_draw?' do # rubocop:disable Metrics/BlockLength
    context 'when a round is initiated' do # rubocop:disable Metrics/BlockLength
      subject(:draw) { described_class.new }

      before do
        allow(draw).to receive(:gets).and_return('N')
      end

      it 'asks the current user if they want to propose a draw' do
        first_message = "Ask For a Draw? [Y/N]\n"
        expect { draw.voluntary_draw? }.to output(first_message).to_stdout
      end

      it 'gets input from the user once for a no answer' do
        allow(draw).to receive(:puts)
        allow(draw).to receive(:gets).and_return('N')
        expect(draw).to receive(:gets).once
        draw.voluntary_draw?
      end

      it 'asks the other player if they accept the draw if current player wats a draw' do
        first_message = "Ask For a Draw? [Y/N]\n"
        allow(draw).to receive(:gets).and_return('Y')
        second_message = "Do You Accept the Draw? [Y/N]\n"
        expect { draw.voluntary_draw? }.to output(first_message + second_message).to_stdout
      end

      it 'returns true if other player accepts draw offer' do
        allow(draw).to receive(:puts)
        allow(draw).to receive(:gets).and_return('Y', 'Y')
        expect(draw.voluntary_draw?).to eql(true)
      end

      it 'returns false if current player does not want to propose a draw' do
        allow(draw).to receive(:puts)
        allow(draw).to receive(:gets).and_return('N')
        expect(draw.voluntary_draw?).to eql(false)
      end

      it 'returns false if other players does not want to draw' do
        allow(draw).to receive(:puts)
        allow(draw).to receive(:gets).and_return('Y', 'N')
        expect(draw.voluntary_draw?).to eql(false)
      end

      it "returns false if first answer is not 'Y'" do
        allow(draw).to receive(:puts)
        allow(draw).to receive(:gets).and_return('T')
        expect(draw.voluntary_draw?).to eql(false)
      end
    end
  end

  describe '#insufficient_material?' do # rubocop:disable Metrics/BlockLength
    context 'when a round is completed' do # rubocop:disable Metrics/BlockLength
      subject(:material) { described_class.new }
      it 'returns false if player one has two or more pieces and player two has more than one piece' do
        expect(material.insufficient_material?).to eql(false)
      end

      it 'returns false if player one has more than two pieces and player two has two or more pieces' do
        expect(material.insufficient_material?).to eql(false)
      end

      it 'returns false if player one has a piece other than a King, Bishop, and Knight' do
        material.instance_variable_get(:@player_one).pieces = [WhiteKing.new(nil, nil), WhiteQueen.new(nil, nil)]
        material.instance_variable_get(:@player_two).pieces = [BlackKing.new(nil, nil), BlackBishop.new(nil, nil)]
        expect(material.insufficient_material?).to eql(false)
      end

      it 'returns false if player two has a piece other than a King, Bishop, and Knight' do
        material.instance_variable_get(:@player_one).pieces = [WhiteKing.new(nil, nil), WhiteBishop.new(nil, nil)]
        material.instance_variable_get(:@player_two).pieces = [BlackKing.new(nil, nil), BlackQueen.new(nil, nil)]
        expect(material.insufficient_material?).to eql(false)
      end

      it 'returns true for king vs king' do
        material.instance_variable_get(:@player_one).pieces = [WhiteKing.new(nil, nil)]
        material.instance_variable_get(:@player_two).pieces = [BlackKing.new(nil, nil)]
        expect(material.insufficient_material?).to eql(true)
      end

      it 'returns true for king and bishop vs king' do
        material.instance_variable_get(:@player_one).pieces = [WhiteKing.new(nil, nil), WhiteBishop.new(nil, nil)]
        material.instance_variable_get(:@player_two).pieces = [BlackKing.new(nil, nil)]
        expect(material.insufficient_material?).to eql(true)
      end

      it 'returns true for king and knight vs king' do
        material.instance_variable_get(:@player_one).pieces = [WhiteKing.new(nil, nil), WhiteKnight.new(nil, nil)]
        material.instance_variable_get(:@player_two).pieces = [BlackKing.new(nil, nil)]
        expect(material.insufficient_material?).to eql(true)
      end

      it 'returns true for king vs king and bishop' do
        material.instance_variable_get(:@player_one).pieces = [WhiteKing.new(nil, nil)]
        material.instance_variable_get(:@player_two).pieces = [BlackKing.new(nil, nil), BlackBishop.new(nil, nil)]
        expect(material.insufficient_material?).to eql(true)
      end

      it 'returns true for king vs king and knight' do
        material.instance_variable_get(:@player_one).pieces = [WhiteKing.new(nil, nil)]
        material.instance_variable_get(:@player_two).pieces = [BlackKing.new(nil, nil), BlackKnight.new(nil, nil)]
        expect(material.insufficient_material?).to eql(true)
      end
    end
  end

  describe '#play_round' do # rubocop:disable Metrics/BlockLength
    context 'when a round is started' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:round) { described_class.new }
      let(:piece) { WhiteRook.new([1, 2], board) }

      it 'calls show board once' do
        allow(round.instance_variable_get(:@current_player)).to receive(:legal_moves)
        allow(round).to receive(:select_piece_and_move)
        allow(round).to receive(:set_last_moves)
        allow(round).to receive(:update_board)
        allow(round).to receive(:set_piece_boards)
        allow(round).to receive(:check?)
        allow(round).to receive(:change_player)
        expect(round).to receive(:show_board).once
        round.play_round
      end

      it 'finds all legal moves for current player' do
        allow(round).to receive(:show_board)
        allow(round).to receive(:select_piece_and_move)
        allow(round).to receive(:set_last_moves)
        allow(round).to receive(:update_board)
        allow(round).to receive(:set_piece_boards)
        allow(round).to receive(:check?)
        allow(round).to receive(:change_player)
        expect(round.instance_variable_get(:@current_player)).to receive(:legal_moves)
        round.play_round
      end

      it 'calls select piece and move once (gets move from user)' do
        allow(round).to receive(:show_board)
        allow(round.instance_variable_get(:@current_player)).to receive(:legal_moves)
        allow(round).to receive(:set_last_moves)
        allow(round).to receive(:update_board)
        allow(round).to receive(:set_piece_boards)
        allow(round).to receive(:check?)
        allow(round).to receive(:change_player)
        expect(round).to receive(:select_piece_and_move).once
        round.play_round
      end

      it 'calls set_last_moves once' do
        allow(round).to receive(:show_board)
        allow(round.instance_variable_get(:@current_player)).to receive(:legal_moves)
        allow(round).to receive(:select_piece_and_move)
        allow(round).to receive(:update_board)
        allow(round).to receive(:set_piece_boards)
        allow(round).to receive(:check?)
        allow(round).to receive(:change_player)
        expect(round).to receive(:set_last_moves).once
        round.play_round
      end

      it 'calls update_board once' do
        allow(round).to receive(:show_board)
        allow(round.instance_variable_get(:@current_player)).to receive(:legal_moves)
        allow(round).to receive(:select_piece_and_move)
        allow(round).to receive(:set_last_moves)
        allow(round).to receive(:set_piece_boards)
        allow(round).to receive(:check?)
        allow(round).to receive(:change_player)
        expect(round).to receive(:update_board).once
        round.play_round
      end

      it "calls set piece boards once (updates each piece's board variable)" do
        allow(round).to receive(:show_board)
        allow(round.instance_variable_get(:@current_player)).to receive(:legal_moves)
        allow(round).to receive(:select_piece_and_move)
        allow(round).to receive(:set_last_moves)
        allow(round).to receive(:update_board)
        allow(round).to receive(:check?)
        allow(round).to receive(:change_player)
        expect(round).to receive(:set_piece_boards).once
        round.play_round
      end

      it 'calls check? once' do
        allow(round).to receive(:show_board)
        allow(round.instance_variable_get(:@current_player)).to receive(:legal_moves)
        allow(round).to receive(:select_piece_and_move)
        allow(round).to receive(:set_last_moves)
        allow(round).to receive(:update_board)
        allow(round).to receive(:set_piece_boards)
        allow(round).to receive(:change_player)
        expect(round).to receive(:check?).once
        round.play_round
      end

      it 'calls change player once' do
        allow(round).to receive(:show_board)
        allow(round.instance_variable_get(:@current_player)).to receive(:legal_moves)
        allow(round).to receive(:select_piece_and_move)
        allow(round).to receive(:set_last_moves)
        allow(round).to receive(:update_board)
        allow(round).to receive(:set_piece_boards)
        allow(round).to receive(:check?)
        expect(round).to receive(:change_player).once
        round.play_round
      end

      # before do
      #   round.board = board
      #   round.board[1][2] = piece
      #   allow(round).to receive(:show_board)
      #   allow(round).to receive(:select_piece_and_move).and_return([piece, [1, 3]])
      #   allow(round).to receive(:)
      # end

      # it 'calls show_board once' do
      #   expect(round).to receive(:show_board).once
      #   round.play_round
      # end

      # it 'calls legal moves on current player once' do
      #   expect(round.instance_variable_get(:@current_player)).to receive(:legal_moves)
      #   round.play_round
      # end

      # it 'calls select_piece_and_move once' do
      #   expect(round).to receive(:select_piece_and_move).once
      #   round.play_round
      # end

      # it 'calls update_board once' do
      #   expect(round).to receive(:update_board).once
      #   round.play_round
      # end
    end
  end

  describe '#set_last_moves' do # rubocop:disable Metrics/BlockLength
    context 'when a round is over' do # rubocop:disable Metrics/BlockLength
      subject(:last_moves) { described_class.new }
      let(:piece) { BlackRook.new([0, 0], nil) }
      let(:last_black_pawn) { BlackPawn.new([1, 0], nil, nil) }
      let(:last_white_pawn) { WhitePawn.new([6, 6], nil, nil) }

      it 'updates the last move variable of each player one pawn' do
        last_moves.set_last_moves(piece)
        pawns = last_moves.instance_variable_get(:@player_one).pieces[0..7]
        pawns = pawns.map(&:last_move)
        expect(pawns).to all eql({ piece: piece, from_start: false })
      end

      it 'updates the last move variable of each player two pawn' do
        last_moves.set_last_moves(piece)
        pawns = last_moves.instance_variable_get(:@player_two).pieces[0..7]
        pawns = pawns.map(&:last_move)
        expect(pawns).to all eql({ piece: piece, from_start: false })
      end

      it 'works correctly for a black pawn moving from its starting position' do
        last_moves.set_last_moves(last_black_pawn)
        pawns = last_moves.instance_variable_get(:@player_one).pieces[0..7]
        pawns = pawns.map(&:last_move)
        expect(pawns).to all eql({ piece: last_black_pawn, from_start: true })
      end

      it 'works correctly for a white pawn moving from its starting position' do
        last_moves.set_last_moves(last_white_pawn)
        pawns = last_moves.instance_variable_get(:@player_two).pieces[0..7]
        pawns = pawns.map(&:last_move)
        expect(pawns).to all eql({ piece: last_white_pawn, from_start: true })
      end
    end
  end

  describe '#check?' do
    context 'when a move is made' do
      subject(:checker) { described_class.new }
      it 'calls check_message if player one move puts player two in check' do
        allow(checker.instance_variable_get(:@player_two).pieces[12]).to receive(:in_check?).and_return(true)
        expect(checker).to receive(:check_message)
        checker.check?
      end

      it 'calls check_message if player two move puts player one in check' do
        checker.change_player
        allow(checker.instance_variable_get(:@player_one).pieces[12]).to receive(:in_check?).and_return(true)
        expect(checker).to receive(:check_message)
        checker.check?
      end

      it 'returns nil if player one move does not put player two in check' do
        checker.change_player
        allow(checker.instance_variable_get(:@player_two).pieces[12]).to receive(:in_check?).and_return(false)
        expect(checker.check?).to eql(nil)
      end

      it 'returns nil if player two move does not put player one in check' do
        checker.change_player
        allow(checker.instance_variable_get(:@player_one).pieces[12]).to receive(:in_check?).and_return(false)
        expect(checker.check?).to eql(nil)
      end
    end
  end

  describe '#update_board' do # rubocop:disable Metrics/BlockLength
    context 'when a round finishes' do # rubocop:disable Metrics/BlockLength
      board_before = [[nil, nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:update) { described_class.new }
      let(:piece) { BlackRook.new([1, 2], board_before) }
      before do
        allow(update).to receive(:remove_capture_piece_from_player)
      end

      it 'updates the board to reflect the new move' do
        update.board = board_before
        expect { update.update_board(piece, [0, 2]) }.to change { update.board[0][2] }.from(nil).to(piece)
      end

      it 'changes the pos of the piece' do
        expect { update.update_board(piece, [0, 2]) }.to change { piece.pos }.from([1, 2]).to([0, 2])
      end

      it 'removes the last position of the piece' do
        update.board = board_before
        update.board[1][2] = piece
        expect { update.update_board(piece, [0, 2]) }.to change { update.board[1][2] }.from(piece).to(nil)
      end

      it 'calls remove_capture_piece_from_player once' do
        expect(update).to receive(:remove_capture_piece_from_player)
        update.update_board(piece, [0, 2])
      end
    end
  end

  describe '#remove_capture_piece_from_player' do # rubocop:disable Metrics/BlockLength
    context 'when a capture is made' do # rubocop:disable Metrics/BlockLength
      subject(:captures) { described_class.new }

      it 'changes the value of the piece to nil in the pieces array for player two' do
        move = [3, 3]
        captures.board[3][3] = captures.instance_variable_get(:@player_two).pieces[6]
        captured = captures.instance_variable_get(:@player_two).pieces[6]
        expect { captures.remove_capture_piece_from_player(nil, move) }.to change {
          captures.instance_variable_get(:@player_two).pieces[6]
        }.from(captured).to(nil)
      end

      it 'changes the value of the piece to nil in the pieces array for player one' do
        captures.change_player
        move = [6, 0]
        captures.board[6][0] = captures.instance_variable_get(:@player_one).pieces[0]
        captured = captures.instance_variable_get(:@player_one).pieces[0]
        expect { captures.remove_capture_piece_from_player(nil, move) }.to change {
          captures.instance_variable_get(:@player_one).pieces[0]
        }.from(captured).to(nil)
      end

      it 'calls ep_capture if no piece is captured' do
        move = [0, 3]
        expect(captures).to receive(:ep_capture)
        captures.remove_capture_piece_from_player(nil, move)
      end

      it 'returns nil if no piece is captured' do
        move = [0, 3]
        expect(captures.remove_capture_piece_from_player(nil, move)).to eql(nil)
      end
    end
  end

  describe '#ep_capture' do # rubocop:disable Metrics/BlockLength
    context "when a pawn captures an opponent's pawn en passant" do # rubocop:disable Metrics/BlockLength
      subject(:capture) { described_class.new }
      let(:black_piece) { BlackPawn.new([0, 0], nil, { piece: nil, from_start: nil }) }
      let(:white_piece) { WhitePawn.new([0, 0], nil, { piece: nil, from_start: nil }) }

      it "removes the captured pawn from player one's pieces" do
        piece = capture.instance_variable_get(:@player_two).pieces[0]
        piece.pos = [3, 1]
        white_piece.last_move[:piece] = piece
        white_piece.last_move[:from_start] = true
        move = [2, 1]
        expect { capture.ep_capture(white_piece, move) }.to change {
          capture.instance_variable_get(:@player_two).pieces[0]
        }.from(piece).to(nil)
      end

      it "removes the captured pawn from player two's pieces" do
        capture.change_player
        piece = capture.instance_variable_get(:@player_one).pieces[0]
        piece.pos = [4, 6]
        black_piece.last_move[:piece] = piece
        black_piece.last_move[:from_start] = true
        move = [5, 6]
        expect { capture.ep_capture(black_piece, move) }.to change {
          capture.instance_variable_get(:@player_one).pieces[0]
        }.from(piece).to(nil)
      end

      it 'returns nil if no en passant capture occurred' do
        piece = capture.instance_variable_get(:@player_two).pieces[0]
        white_piece.last_move[:piece] = piece
        white_piece.last_move[:from_start] = false
        move = [6, 6]
        expect(capture.ep_capture(white_piece, move)).to eql(nil)
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
        allow(selected).to receive(:player_select_piece).and_return([1, 2])
        allow(selected).to receive(:player_input_move).and_return([0, 2])
      end

      it 'returns an array' do
        expect(selected.select_piece_and_move(nil)).to be_kind_of(Array)
      end

      it 'calls player_select_piece once' do
        expect(selected).to receive(:player_select_piece).once
        selected.select_piece_and_move(nil)
      end

      it 'calls player_input_move once' do
        expect(selected).to receive(:player_input_move).once
        selected.player_input_move(nil, piece)
      end

      it 'returns the correct order' do
        selected.board[1][2] = piece
        expected_output = [piece, [0, 2]]
        expect(selected.select_piece_and_move(nil)).to eql(expected_output)
      end
    end
  end

  describe '#player_select_piece' do # rubocop:disable Metrics/BlockLength
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
      let(:piece) { BlackRook.new([1, 2], board) }

      before do
        allow(getter).to receive(:puts)
        allow(getter).to receive(:gets).and_return('1,2')
        allow(getter).to receive(:valid_input).and_return(true)
      end

      it 'gets the piece for the move from user' do
        moves = [[2, 2], [3, 2]]
        expect(getter).to receive(:gets).once
        getter.player_select_piece(moves)
      end

      it 'returns the correctly formatted output' do
        moves = [[2, 2], [3, 2]]
        getter.board[1][2] = piece
        expected_output = piece.pos
        expect(getter.player_select_piece(moves)).to eql(expected_output)
      end

      it 'calls valid_piece once' do
        moves = [[2, 2], [3, 2]]
        expect(getter).to receive(:valid_input).once
        getter.player_select_piece(moves)
      end

      it 'calls player_select_piece once if valid_piece returns false' do
        moves = [[2, 2], [3, 2]]
        allow(getter).to receive(:valid_input).and_return(false, true)
        expect(getter).to receive(:player_select_piece).once
        getter.player_select_piece(moves)
      end
    end
  end

  describe '#valid_input' do # rubocop:disable Metrics/BlockLength
    context 'when a player selects a piece' do # rubocop:disable Metrics/BlockLength
      board = [[nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil, nil, nil, nil]]

      subject(:valid) { described_class.new }
      let(:piece) { WhiteRook.new([1, 2], board) }
      let(:opponent_piece) { BlackRook.new([1, 2], board) }

      it 'returns false if board index length is more than 2' do
        moves = [[2, 2], [3, 2]]
        expected_output = false
        input = [0, 0, 0]
        expect(valid.valid_input(input, moves)).to eql(expected_output)
      end

      it 'returns false if index is nil' do
        moves = [[2, 2], [3, 2]]
        valid.board = board
        expected_output = false
        input = [0, 0]
        expect(valid.valid_input(input, moves)).to eql(expected_output)
      end

      it 'returns false if piece belongs to opponent' do
        moves = [[2, 2], [3, 2]]
        valid.board[0][0] = opponent_piece
        expected_output = false
        input = [0, 0]
        expect(valid.valid_input(input, moves)).to eql(expected_output)
      end

      it 'returns true if piece belongs to current player' do
        moves = [[2, 2], [3, 2]]
        valid.board[0][0] = piece
        valid.current_player.pieces << piece
        expected_output = true
        input = [0, 0]
        expect(valid.valid_input(input, moves)).to eql(expected_output)
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
        allow(getter).to receive(:puts)
      end

      it 'gets the move from user' do
        expect(getter).to receive(:gets).once
        getter.player_input_move(nil, piece)
      end

      it 'returns an array' do
        expect(getter.player_input_move(nil, piece)).to be_kind_of(Array)
      end

      it 'returns the correctly formatted output' do
        expected_output = [1, 2]
        expect(getter.player_input_move(nil, piece)).to eql(expected_output)
      end

      it 'calls valid_move once' do
        expect(getter).to receive(:valid_move).once
        getter.player_input_move(nil, piece)
      end

      it 'calls player_input_move once if valid_move returns false' do
        allow(getter).to receive(:valid_move).and_return(false, true)
        expect(getter).to receive(:player_input_move).once
        getter.player_input_move(nil, piece)
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
        moves = [[1, 2]]
        expected_output = true
        expect(valid.valid_move(moves, piece, move)).to eql(expected_output)
      end

      it 'returns false if given move is not array of size 2' do
        move = [1, 2, 3]
        expected_output = false
        moves = [[1, 2, 3]]
        expect(valid.valid_move(moves, piece, move)).to eql(expected_output)
      end

      it 'returns false if x is not a number' do
        move = ['a', 2]
        expected_output = false
        moves = [[3, 4]]
        expect(valid.valid_move(moves, piece, move)).to eql(expected_output)
      end

      it 'returns false if y is not a number' do
        move = [2, 'a']
        expected_output = false
        moves = [[2, 'a']]
        expect(valid.valid_move(moves, piece, move)).to eql(expected_output)
      end

      it 'returns false if x not between 0 and 7 inclusive' do
        move = [21, 1]
        expected_output = false
        moves = [[21, 1]]
        expect(valid.valid_move(moves, piece, move)).to eql(expected_output)
      end

      it 'returns false if y not between 0 and 7 inclusive' do
        move = [1, 21]
        expected_output = false
        moves = [[1, 21]]
        expect(valid.valid_move(moves, piece, move)).to eql(expected_output)
      end

      it 'returns false if move not in available moves of piece' do
        move = [3, 4]
        expected_output = false
        moves = [[3, 4]]
        expect(valid.valid_move(moves, piece, move)).to eql(expected_output)
      end

      it "returns false if move not in player's available moves" do
        move = [3, 4]
        expected_output = false
        moves = [[2, 1]]
        expect(valid.valid_move(moves, piece, move)).to eql(expected_output)
      end
    end
  end

  describe '#change_player' do
    context 'when a round is over' do
      subject(:player_turn) { described_class.new }
      it 'changes the player from player one to player two' do
        expect { player_turn.change_player }.to change {
          player_turn.instance_variable_get(:@current_player)
        }.from(WhitePlayer).to(BlackPlayer)
      end

      it 'changes the player from player two to player one' do
        player_turn.change_player
        expect { player_turn.change_player }.to change {
          player_turn.instance_variable_get(:@current_player)
        }.from(BlackPlayer).to(WhitePlayer)
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
