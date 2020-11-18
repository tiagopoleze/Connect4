import Foundation

let columns = 7
let rows = 6

var board = Array(repeating: Array(repeating: 0, count: columns), count: rows)
board[0][0] = 1
board[0][1] = 2
board[0][2] = 3
board[0][3] = 40
board[1][3] = 41
board[2][3] = 42
board[3][3] = 43
board[4][3] = 44
board[5][3] = 45
board[0][4] = 5
board[0][5] = 6
board[0][6] = 7

for array in board {
    print(array[Int(columns/2)])
}
