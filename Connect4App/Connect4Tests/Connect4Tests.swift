//
//  Connect4Tests.swift
//  Connect4Tests
//
//  Created by Tiago Ferreira on 25/10/20.
//

import XCTest
@testable import Connect4

class Connect4Tests: XCTestCase {
    let gameScene = GameScene()
    
    func testCreatePiece() throws {
        let board = gameScene.createBoard()
        let result = gameScene.isValidPosition(internalBoard: board, col: 0)
        XCTAssertTrue(result, "Fail to create a piece in am empty board")
    }
    
    func testGetBlock() throws {
        gameScene.blockSize = 2
        let assert = (row: 0, col: 0)
        let block = gameScene.getBlock(with: CGPoint(x: 0, y: 0))
        XCTAssert(block == assert, "Block was \(block), and the assert was \(assert)")
    }
    
    func testDropPiece() throws {
        let board = gameScene.createBoard()
        let row = 0
        let col = 0
        let piece = 1
        let newBoard = gameScene.dropPiece(internalBoard: board, row: row, col: col, piece: piece)
        XCTAssert(newBoard[row][col] == piece, "Failed to put the piece in the right position")
    }
    
    func testIsValidPosition() throws {
        let board = gameScene.createBoard()
        let result = gameScene.isValidPosition(internalBoard: board, col: 1)
        XCTAssertTrue(result, "Fail to validate position in an empty board.")
    }
    
    func testGetNextOpenRow() throws {
        let board = gameScene.createBoard()
        let result = gameScene.getNextOpenRow(internalBoard: board, col: 0)
        XCTAssertNotNil(result, "Failed to get next open row")
    }

    func testWinningMove() throws {
        let board = gameScene.createBoard()
        let piece = 1
        let result = gameScene.winningMove(internalBoard: board, piece: piece)
        XCTAssertFalse(result, "Won in an empty board???")
    }
    
    func testWinningMoveWin() throws {
        var board = gameScene.createBoard()
        let piece = 1
        board = gameScene.dropPiece(internalBoard: board, row: 0, col: 0, piece: 1)
        board = gameScene.dropPiece(internalBoard: board, row: 1, col: 0, piece: 1)
        board = gameScene.dropPiece(internalBoard: board, row: 2, col: 0, piece: 1)
        board = gameScene.dropPiece(internalBoard: board, row: 3, col: 0, piece: 1)
        let result = gameScene.winningMove(internalBoard: board, piece: piece)
        XCTAssertTrue(result, "This is an winning move")
    }
    
    func testCreateBoard() throws {
        let board = gameScene.createBoard()
        XCTAssertGreaterThan(board.count, 0, "Board was not created")
    }
    
    func testEvaluateWindow() throws {
        
    }
    
    func testIsTerminalNode() throws {
        let board = gameScene.createBoard()
        let piece = 1
        let oppPiece = 2
        let result = gameScene.isTerminalNode(internalBoard: board, piece: piece, piece_opp: oppPiece)
        XCTAssertFalse(result, "Terminal node in an empty board?")
    }
    
    func testGetValidLocations() throws {
        let board = gameScene.createBoard()
        let result = gameScene.getValidLocations(internalBoard: board)
        XCTAssert(result.count == gameScene.columns, "You must have all columns available in an empty board")
    }
    
    func testScorePosition() throws {
        let board = gameScene.createBoard()
        let piece = 1
        let oppPiece = 2
        let result = gameScene.scorePosition(internalBoard: board, piece: piece, pieceOpp: oppPiece)
        XCTAssertGreaterThanOrEqual(result, 0, "Failed to get the score \(result)")
    }
    
    func testNegamax() throws {
        let board = gameScene.createBoard()
        let piece = 1
        let oppPiece = 2
        let depth = 0
        let assert: (Int?, Int) = (nil, 0)
        let result = gameScene.negamax(internalBoard: board, piece: piece, pieceOpp: oppPiece, depth: depth)
        XCTAssert(result == assert, "The most simple test for Negamax")
    }
    
}
