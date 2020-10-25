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
    
    var blocked: [(row: Int, col: Int)] = [(row: Int, col: Int)]()
    
    var player = 1
    
    override func didMove(to view: SKView) {
        blockSize = frame.height / CGFloat(rows)
        grid = Grid(blockSize: blockSize, rows: rows, cols: columns)!
        grid.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(grid)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: view)
        
        if location!.x >= blockSize/2 && location!.x <= (frame.width - blockSize/2) {
            let gamePiece = createPiece(location: location!)
            grid.addChild(gamePiece)
        }
    }
    
    private func getBlock(with location: CGPoint) -> (row: Int, col:Int) {
        let col = Int((location.x - (blockSize / 2)) / blockSize)
        let row = Int(location.y / blockSize)
        return (row, col)
    }
    
    private func possible(block: (row: Int, col:Int)) -> (row: Int, col:Int) {
        var newRow = rows - 1

        blocked.forEach { (blockedRow, blockedCol) in
            if blockedCol == block.col {
                newRow -= 1
            }
        }

        blocked.append((newRow, block.col))

        return blocked.last!
    }
    
    private func createPiece(location: CGPoint) -> SKSpriteNode {
        let color: UIColor = player == 1 ? .red : .blue
        let size = CGSize(width: blockSize, height: blockSize)
        let gamePiece = SKSpriteNode(color: color, size: size)
        let block = possible(block: getBlock(with: location))
        gamePiece.position = grid.gridPosition(row: block.row, col: block.col)
        
        player = player == 1 ? 0 : 1
        return gamePiece
    }
    
}
