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
    
    override func didMove(to view: SKView) {
        blockSize = frame.height / CGFloat(rows)
        grid = Grid(blockSize: blockSize, rows: rows, cols: columns)!
        grid.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(grid)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: view)
        
        if location!.x >= blockSize/2 && location!.x <= (frame.width - blockSize/2) {
            let gamePiece = SKSpriteNode(color: .red, size: CGSize(width: blockSize, height: blockSize))
            let (row, col) = getBlock(with: location!)
            gamePiece.position = grid.gridPosition(row: row, col: col)
            grid.addChild(gamePiece)
        }
    }
    
    private func getBlock(with location: CGPoint) -> (Int, Int) {
        let col = Int((location.x - (blockSize / 2)) / blockSize)
        let row = Int(location.y / blockSize)
        return (row, col)
    }
    
}
