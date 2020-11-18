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
            let gamePiece = createPiece(location: location!, piece: playerPice)
            grid.addChild(gamePiece)
        }
    }
    
    private func createPiece(location: CGPoint, piece: Int) -> SKSpriteNode {
        let color: UIColor = piece == 1 ? .red : .blue
        let size = CGSize(width: blockSize, height: blockSize)
        let gamePiece = SKSpriteNode(color: color, size: size)
        let initialBlock = getBlock(with: location)
        if isValidPosition(internalBoard: board, col: initialBlock.col) {
            if let row = getNextOpenRow(internalBoard: board, col: initialBlock.col) {
                dropPiece(row: row, col: initialBlock.col, piece: playerPice)
                gamePiece.position = grid.gridPosition(row: (rows-1-row), col: initialBlock.col)
                
                if winningMove(internalBoard: board, piece: piece) {
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
        return internalBoard[rows-1][col] == 0
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
}
