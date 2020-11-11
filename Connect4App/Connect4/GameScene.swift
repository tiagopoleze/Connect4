//
//  GameScene.swift
//  Connect4
//
//  Created by Tiago Ferreira on 25/10/20.
//

import SpriteKit

class GameScene: SKScene {
    let rows = 6
    let columns = 7
    var blockSize: CGFloat!
    var grid: Grid!
    
    var board: [[Int]]!
    
    let blockedPiece = -1
    let emptyPiece = 0
    let playerPice = 1
    let aiPiece = 2
    
    override func didMove(to view: SKView) {
        blockSize = frame.height / CGFloat(rows)
        grid = Grid(blockSize: blockSize, rows: rows, cols: columns)!
        grid.position = CGPoint(x: frame.midX, y: frame.midY)
        
        board = createBoard()
        
        addChild(grid)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        if player == 0 {
        //            return
        //        }
        let location = touches.first?.location(in: view)
        if location!.x >= blockSize/2 && location!.x <= (frame.width - blockSize/2) {
            let gamePiece = createPiece(location: location!, player: playerPice)
            grid.addChild(gamePiece)
        }
    }
    
    private func createPiece(location: CGPoint, player: Int) -> SKSpriteNode {
        let color: UIColor = player == 1 ? .red : .blue
        let size = CGSize(width: blockSize, height: blockSize)
        let gamePiece = SKSpriteNode(color: color, size: size)
        let initialBlock = getBlock(with: location)
        if isValidPosition(internalBoard: board, col: initialBlock.col) {
            if let row = getNextOpenRow(internalBoard: board, col: initialBlock.col) {
                dropPiece(row: row, col: initialBlock.col, piece: playerPice)
                gamePiece.position = grid.gridPosition(row: (rows-1-row), col: initialBlock.col)
                if winningMove(internalBoard: board, piece: player) {
                    print("ganhou")
                }
            }
        }
        return gamePiece
    }
    
    private func getBlock(with location: CGPoint) -> (row: Int, col:Int) {
        let col = Int((location.x - (blockSize / 2)) / blockSize)
        let row = Int(location.y / blockSize)
        return (row, col)
    }
    
    
    private func dropPiece(row: Int, col: Int, piece: Int) {
        board[row][col] = piece
    }
    
    private func isValidPosition(internalBoard: [[Int]], col: Int) -> Bool {
        return internalBoard[rows-1][col] == 0 && internalBoard[rows-1][col] != blockedPiece
    }
    
    private func getNextOpenRow(internalBoard: [[Int]], col: Int) -> Int? {
        for r in 0..<rows {
            if internalBoard[r][col] == 0 {
                return r
            }
        }
        return nil
    }
    
    
    private func winningMove(internalBoard: [[Int]], piece: Int) -> Bool {
        // Check horizontal locations for win
        for c in 0..<columns-3 {
            for r in 0..<rows {
                if internalBoard[r][c] == piece && internalBoard[r][c+1] == piece && internalBoard[r][c+2] == piece && internalBoard[r][c+3] == piece {
                    return true
                }
            }
        }
        
        // Check vertical locations for win
        for c in 0..<columns {
            for r in 0..<rows-3 {
                if internalBoard[r][c] == piece && internalBoard[r+1][c] == piece && internalBoard[r+2][c] == piece && internalBoard[r+3][c] == piece {
                    return true
                }
            }
        }
        
        // Check positively sloped diaganols
        for c in 0..<columns-3 {
            for r in 0..<rows-3 {
                if internalBoard[r][c] == piece && internalBoard[r+1][c+1] == piece && internalBoard[r+2][c+2] == piece && internalBoard[r+3][c+3] == piece {
                    return true
                }   
            }
        }
        
        // Check negatively sloped diaganols
        for c in 0..<columns-3 {
            for r in 3..<rows {
                if internalBoard[r][c] == piece && internalBoard[r-1][c+1] == piece && internalBoard[r-2][c+2] == piece && internalBoard[r-3][c+3] == piece {
                    return true
                }
            }
        }
        return false
    }
    
    private func createBoard() -> [[Int]] {
        return Array(repeating: Array(repeating: emptyPiece, count: columns), count: columns)
    }
    
    private func evaluateWindow(window: [Int], piece: Int, pieceOpp: Int) -> Int {
        var score = 0
        
        if window.reduce(0, { (result, index) -> Int in
            index == piece ? result + 1 : result + 0
        }) == 4 {
            score += 100
        }
        else if (window.reduce(0, { (result, index) -> Int in
            index == piece ? result + 1 : result + 0
        }) == 3 && window.reduce(0, { (result, index) -> Int in
            index == emptyPiece ? result + 1 : result + 0
        }) == 1) {
            score += 5
        }
        
        else if (window.reduce(0, { (result, index) -> Int in
            index == piece ? result + 1 : result + 0
        }) == 2 && window.reduce(0, { (result, index) -> Int in
            index == emptyPiece ? result + 1 : result + 0
        }) == 2) {
            score += 2
        }
        
        if (window.reduce(0, { (result, index) -> Int in
            index == pieceOpp ? result + 1 : result + 0
        }) == 3 && window.reduce(0, { (result, index) -> Int in
            index == emptyPiece ? result + 1 : result + 0
        }) == 1) {
            score -= 4
        }
        
        return score
    }
    
    private func scorePosition(internalBoard: [[Int]],piece: Int, pieceOpp: Int) -> Int {
        var score = 0
        
        // Score center column
        score += scoreCenterColumn(internalBoard: internalBoard, piece: piece)
        
        // Score Horizontal
        score += scoreHorinzontal(internalBoard: internalBoard, piece: piece, pieceOpp: pieceOpp)
        
        // Score Vertical
        score += scoreVertical(internalBoard: internalBoard)
        
        // Score positive sloped diagonal
        score += scorePositiveSlopedDiagonal(internalBoard: internalBoard)
        
        return score
    }
    
    private func scoreCenterColumn(internalBoard: [[Int]], piece: Int) -> Int {
        
        var actualIndex = 0
        let colPerTwo = Int(columns/2)
        
        let centerArray = internalBoard.reduce([Int]()) { result, array in
            if actualIndex <= colPerTwo {
                actualIndex += 1
                return result + array
            }
            return result
        }
        return centerArray.reduce(0) { result, number in
            if number == piece { return result + 1 }
            return result
        } * 3
    }
    
    private func scoreHorinzontal(internalBoard: [[Int]], piece: Int, pieceOpp: Int) -> Int {
        var actualIndexRow = 0
        var actualColIndex = 0
        var window: [Int] = []
        
        for i in 0..<rows {
            let rowArray = internalBoard.reduce([Int]()) { result, array in
                if i == actualIndexRow {
                    return result + array
                }
                return result
            }
            actualIndexRow += 1
            
            for (index, number) in rowArray.enumerated() {
                if index == actualColIndex {
                    window.append(number)
                }
            }
            actualColIndex += 1
            
        }
//        for r in range(ROW_COUNT):
//          row_array = [int(i) for i in list(board[r, :])]
//          for c in range(COLUMN_COUNT - 3):
//              window = row_array[c:c + WINDOW_LENGTH]
//              score += evaluate_window_negamax(window, piece, piece_opp)
        
        return evaluateWindow(window: window, piece: piece, pieceOpp: pieceOpp)
    }
    
    private func scoreVertical(internalBoard: [[Int]]) -> Int {
        
//        for c in range(COLUMN_COUNT):
//            col_array = [int(i) for i in list(board[:, c])]
//            for r in range(ROW_COUNT - 3):
//                window = col_array[r:r + WINDOW_LENGTH]
//                score += evaluate_window_negamax(window, piece, piece_opp)
        
        return 0
    }
    
    private func scorePositiveSlopedDiagonal(internalBoard: [[Int]]) -> Int {
//        for r in range(ROW_COUNT - 3):
//            for c in range(COLUMN_COUNT - 3):
//                window = [board[r + i][c + i] for i in range(WINDOW_LENGTH)]
//                score += evaluate_window_negamax(window, piece, piece_opp)
//
//        for r in range(ROW_COUNT - 3):
//            for c in range(COLUMN_COUNT - 3):
//                window = [board[r + 3 - i][c + i] for i in range(WINDOW_LENGTH)]
//                score += evaluate_window_negamax(window, piece, piece_opp)
        return 0
    }
    
    private func isTerminalNode(internalBoard: [[Int]], piece: Int, piece_opp: Int) -> Bool {
        return winningMove(internalBoard: internalBoard, piece: piece) || winningMove(internalBoard: internalBoard, piece: piece_opp) || getValidLocations(internalBoard: internalBoard).count == 0
    }
    
    private func getValidLocations(internalBoard: [[Int]]) -> [Int] {
        var validLocations = [Int]()
        for col in 0..<columns {
            if isValidPosition(internalBoard: internalBoard, col: col) {
                validLocations.append(col)
            }
        }
        return validLocations
    }
    func negamax(internalBoard: [[Int]], piece: Int, pieceOpp: Int, detph: Int, alpha: Int, beta: Int) -> Bool {
//    def negamax(board, piece, piece_opp, depth, alpha, beta):
//        valid_locations = get_valid_locations(board)
//        is_terminal = is_terminal_node_negamax(board, piece, piece_opp)
//        if depth == 0 or is_terminal:
//            if is_terminal:
//                if winning_move(board, piece):
//                    return (None, 100000000000000)
//                elif winning_move(board, piece_opp):
//                    return (None, -10000000000000)
//                else:  # Game is over, no more valid moves
//                    return (None, 0)
//            else:  # Depth is zero
//                return (None, score_position_negamax(board, piece, piece_opp))
//
//        value = -math.inf
//        column = random.choice(valid_locations)
//        for col in valid_locations:
//            row = get_next_open_row(board, col)
//            b_copy = board.copy()
//                drop_piece(b_copy, row, col, piece)
//            new_score = -negamax(b_copy, piece_opp, piece, depth - 1, alpha, beta)[1]
//            if new_score > value:
//                value = new_score
//                column = col
//            if poda_alpha_beta:
//                alpha = max(alpha, value)
//                if alpha >= beta:
//                    break
//        return column, value
        return true
    }
    
    //    for i in range(partidas_jogo):
    //        board = create_board()
    //        if tipo_obstaculo == 1:
    //            block_position(board)
    //        elif tipo_obstaculo == 2:
    //            planta_jogadas(board)
    //
    //        print_board(board)
    //        game_over = False
    //
    //        pygame.init()
    //
    //        screen = pygame.display.set_mode(size)
    //        draw_board(board)
    //        pygame.display.update()
    //
    //        myfont = pygame.font.SysFont("monospace", 37)
    //
    //        while not game_over:
    //            numero_turno = 0
    //
    //            for event in pygame.event.get():
    //
    //                if event.type == pygame.QUIT:
    //                    sys.exit()
    //
    //                if event.type == pygame.MOUSEMOTION:
    //                    pygame.draw.rect(screen, BLACK, (0,0, width, SQUARESIZE))
    //                    posx = event.pos[0]
    //                    if turn == PLAYER:
    //                        if tipo_jogo == PLAYER_VS_IA:
    //                            pygame.draw.circle(screen, RED, (posx, int(SQUARESIZE/2)), RADIUS)
    //
    //                pygame.display.update()
    //
    //                if tipo_jogo == PLAYER_VS_IA:
    //                    nome_player_1 = "Player"
    //
    //                    if event.type == pygame.MOUSEBUTTONDOWN:
    //                        pygame.draw.rect(screen, BLACK, (0,0, width, SQUARESIZE))
    //                        #print(event.pos)
    //                        # Ask for Player 1 Input
    //                        if turn == PLAYER:
    //                            draw_turn_color(screen, RED, (35, 33))
    //
    //                            posx = event.pos[0]
    //                            col = int(math.floor(posx / SQUARESIZE))
    //
    //                            if is_valid_location(board, col):
    //                                row = get_next_open_row(board, col)
    //                                drop_piece(board, row, col, PLAYER_PIECE)
    //
    //                                if winning_move(board, PLAYER_PIECE):
    //                                    pygame.draw.rect(screen, BLACK,(0,0,300,50))
    //                                    draw_turn_color(screen, BLACK, (40, 33))
    //                                    label = myfont.render("Player wins!!", 1, RED)
    //                                    screen.blit(label, (35, 10))
    //                                    game_over = True
    //                                    placar_player_1 += 1
    //
    //                                turn += 1
    //                                turn = turn % 2
    //
    //                                print_board(board)
    //                                draw_board(board)
    //
    //
    //
    //
    //            # Ask for Player 1 IA Input
    //            if turn == PLAYER:
    //                if tipo_jogo == IA_VS_IA:
    //                    draw_turn_color(screen, RED, (35, 33))
    //
    //                    nome_player_1 = "IA-1"
    //
    //                    if tipo_ia[0] == MINIMAX_PRUNING or tipo_ia[0] == MINIMAX_NO_PRUNING:
    //                        poda_alpha_beta = tipo_ia[0] == MINIMAX_PRUNING
    //                        col, minimax_score = minimax(board, 5, -math.inf, math.inf, True)
    //                    elif tipo_ia[0] == NEGAMAX_PRUNING or tipo_ia[0] == NEGAMAX_NO_PRUNING:
    //                        poda_alpha_beta = tipo_ia[0] == NEGAMAX_PRUNING
    //                        col, score = negamax(board, AI_PIECE, PLAYER_PIECE, 5, -math.inf, math.inf)
    //
    //                    if is_valid_location(board, col):
    //                        row = get_next_open_row(board, col)
    //                        drop_piece(board, row, col, PLAYER_PIECE)
    //
    //                        if winning_move(board, PLAYER_PIECE):
    //                            pygame.draw.rect(screen, BLACK, (0, 0, 300, 50))
    //                            draw_turn_color(screen, BLACK, (35, 33))
    //                            label = myfont.render("IA-1 wins!!", 1, RED)
    //                            screen.blit(label, (40,10))
    //                            game_over = True
    //                            placar_player_1 += 1
    //
    //                        turn += 1
    //                        turn = turn % 2
    //
    //                        print_board(board)
    //                        draw_board(board)
    //
    //
    //            # # Ask for Player 2 IA Input
    //            if turn == AI and not game_over:
    //                draw_turn_color(screen, YELLOW, (35, 33))
    //
    //                nome_player_2 = "IA-2"
    //
    //                if tipo_ia[1] == MINIMAX_PRUNING or tipo_ia[1] == MINIMAX_NO_PRUNING:
    //                    poda_alpha_beta = tipo_ia[1] == MINIMAX_PRUNING
    //                    col, minimax_score = minimax(board, 5, -math.inf, math.inf, True)
    //                elif tipo_ia[1] == NEGAMAX_PRUNING or tipo_ia[1] == NEGAMAX_NO_PRUNING:
    //                    poda_alpha_beta = tipo_ia[1] == NEGAMAX_PRUNING
    //                    col, score = negamax(board, AI_PIECE, PLAYER_PIECE, 5, -math.inf, math.inf)
    //
    //                if is_valid_location(board, col):
    //                    row = get_next_open_row(board, col)
    //                    drop_piece(board, row, col, AI_PIECE)
    //
    //                    if winning_move(board, AI_PIECE):
    //                        draw_turn_color(screen, BLACK, (35, 33))
    //                        label = myfont.render("IA-2 wins!!", 1, YELLOW)
    //                        screen.blit(label, (40,10))
    //                        game_over = True
    //                        placar_player_2 += 1
    //
    //                    print_board(board)
    //                    draw_board(board)
    //
    //                    turn += 1
    //                    turn = turn % 2
    //
    //            if game_over:
    //                pygame.time.wait(2000)
    //
    //    placar((nome_player_1, placar_player_1), (nome_player_2, placar_player_2), partidas_jogo)
    
}
