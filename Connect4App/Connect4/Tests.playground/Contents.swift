import Foundation

let rows = 6
let columns = 7
let blockedPiece = -1
let emptyPiece = 0
let playerPice = 1
let aiPiece = 2

var board: [[Int]] = Array(repeating: Array(repeating: playerPice, count: columns), count: columns)


private func scorePosition(piece: Int, piece_opp: Int) -> Int {
    var score = 0
    
    let colPerTwo = Int(columns/2)
    
    let centerArray = board.reduce([Int]()) { result, array in
    print(array)
        print(array[colPerTwo])
        
        return result
    }
    
    let centerCount = centerArray.reduce(0) { result, index in
        index == piece ? result + 1 : result
    }
    score += centerCount * 3
    
    return score
}
print(scorePosition(piece: 1, piece_opp: 2))
