import UIKit

enum Directions{
    case up, down, left, right
}

enum Matrices: Int{
    case first, second, third, fourth, fifth, sixth
}

struct SnakeBodyPart{
    let matrix: Matrices
    var row: Int
    var column: Int
}

struct Snake{
    var direction: Directions
    var body: [SnakeBodyPart]
}

struct Coordinate{
    var matrix: Matrices
    var row: Int
    var column: Int
}

func generateLedMatrix(rows: Int, columns: Int) -> [[Int]]{
    var ledMatrix = [[Int]]();
    
    let rows = 8;
    let columns = 8;
    
    for columm in 0..<columns{
        ledMatrix.append([Int]())
        for _ in 0..<rows{
            ledMatrix[columm].append(0)
        }
    }
    
    return ledMatrix
}

func displayMatrix(_ matrix: [[Int]]){
    for row in matrix{
        print(row)
    }
}

func displayMatrices(_ matrices: [[[Int]]]){
    for (index, matrix) in matrices.enumerated(){
        print("---------\(Matrices(rawValue: index)!)----------")
        displayMatrix(matrix)
    }
}

func createSnake() -> Snake{
    return Snake(direction: .up, body: [SnakeBodyPart(matrix: .first, row: 7, column: 3)])
}


func placeFood(_ matrices: [[[Int]]]) -> [[[Int]]]{
    var newMatrices = matrices
    
    let randomMatrixSelector = Int.random(in: 0..<newMatrices.count)
    
    var matrix = newMatrices[randomMatrixSelector]
    var row: Int
    var column: Int
    
    repeat{
        row = Int.random(in: 0..<matrix.count)
        column = Int.random(in: 0..<matrix[0].count)
    } while matrix[row][column] == 1
    
    newMatrices[randomMatrixSelector][row][column] = 1
    
    return newMatrices
}

func removeSnake(matrices: [[[Int]]], snake: Snake) -> [[[Int]]]{
    var newMatrices = matrices
    
    for bodyPart in snake.body{
        newMatrices[bodyPart.matrix.rawValue][bodyPart.row][bodyPart.column] = 0
    }
    
    return newMatrices
}

func placeSnake(matrices: [[[Int]]], snake: Snake) -> [[[Int]]]{
    var newMatrices = matrices
    
    for bodyPart in snake.body{
        newMatrices[bodyPart.matrix.rawValue][bodyPart.row][bodyPart.column] = 1
    }
    
    return newMatrices
}

func growSnake(_ snake: Snake) -> Snake{
    let growDirection: Directions
    
    var newSnake = snake
    
    switch snake.direction {
    case .up:
        growDirection = .down
    case .down:
        growDirection = .up
    case .left:
        growDirection = .right
    case .right:
        growDirection = .left
    }
    
    let snakeTail = snake.body.last!
    let newCoordinates = getNewCoordinates(matix: snakeTail.matrix, direction: growDirection, row: snakeTail.row, column: snakeTail.column)
    
    newSnake.body.append(SnakeBodyPart(matrix: newCoordinates.matrix, row: newCoordinates.row, column: newCoordinates.column))
    
    return newSnake
}

func move(_ snake: Snake) -> Snake{
    var movedSnake: Snake
    let snakeHead = snake.body.first!
    var oldCoordinate = Coordinate(matrix: snakeHead.matrix, row: snakeHead.row, column: snakeHead.column)
    
    let newCoordinates = getNewCoordinates(matix: snakeHead.matrix, direction: snake.direction, row: snakeHead.row, column: snakeHead.column)
    
    movedSnake = Snake(direction: snake.direction, body: [SnakeBodyPart(matrix: newCoordinates.matrix, row: newCoordinates.row, column: newCoordinates.column)])
    
    for bodyPart in snake.body.dropFirst(){
        movedSnake.body.append(SnakeBodyPart(matrix: oldCoordinate.matrix, row: oldCoordinate.row, column: oldCoordinate.column))
        
        oldCoordinate.matrix = bodyPart.matrix
        oldCoordinate.row = bodyPart.row
        oldCoordinate.column = bodyPart.column
    }
    
    
    return movedSnake
}

func getNewCoordinates(matix: Matrices, direction: Directions, row: Int, column: Int) -> Coordinate{
    var newRow: Int
    var newColumn: Int
    var newMatrix: Matrices
    
    switch matix {
    case .first:
        switch direction {
        case .up:
            if (row - 1) < 0{
                newMatrix = .sixth
                newRow = 7
            }
            else{
                newMatrix = matix
                newRow = row - 1
            }
            newColumn = column
        case .down:
            if (row + 1) > 7{
                newMatrix = .third
                newRow = 0
            }
            else{
                newMatrix = matix
                newRow = row + 1
            }
            newColumn = column
        case .left:
            if (column - 1) < 0{
                newMatrix = .second
                newColumn = 7
            }
            else{
                newMatrix = matix
                newColumn = column - 1
            }
            newRow = row
        case .right:
            if (column + 1) > 7{
                newMatrix = .fourth
                newColumn = 0
            }
            else{
                newMatrix = matix
                newColumn = column + 1
            }
            newRow = row
        }
    case .second:
        switch direction {
        case .up:
            if (row - 1) < 0{
                newMatrix = .sixth
                newRow = column
                newColumn = 0
            }
            else{
                newMatrix = matix
                newRow = row - 1
                newColumn = column
            }
        case .down:
            if (row + 1) > 7{
                newMatrix = .third
                newRow = column
                newColumn = 0
            }
            else{
                newMatrix = matix
                newRow = row + 1
                newColumn = column
            }
        case .left:
            if (column - 1) < 0{
                newMatrix = .fifth
                newColumn = 7
            }
            else{
                newMatrix = matix
                newColumn = column - 1
            }
            newRow = row
        case .right:
            if (column + 1) > 7{
                newMatrix = .first
                newColumn = 0
            }
            else{
                newMatrix = matix
                newColumn = column + 1
            }
            newRow = row
        }
    case .third:
        switch direction {
        case .up:
            if (row - 1) < 0{
                newMatrix = .first
                newRow = 7
            }
            else{
                newMatrix = matix
                newRow = row - 1
            }
            newColumn = column
        case .down:
            if (row + 1) > 7{
                newMatrix = .fifth
                newRow = 7
            }
            else{
                newMatrix = matix
                newRow = row + 1
            }
            newColumn = column
        case .left:
            if (column - 1) < 0{
                newMatrix = .second
                newRow = 7
                newColumn = row
            }
            else{
                newMatrix = matix
                newColumn = column - 1
                newRow = row
            }
        case .right:
            if (column + 1) > 7{
                newMatrix = .fourth
                newColumn = row
                newRow = 7
            }
            else{
                newMatrix = matix
                newColumn = column + 1
                newRow = row
            }
        }
    case .fourth:
        switch direction {
        case .up:
            if (row - 1) < 0{
                newMatrix = .sixth
                newRow = column
                newColumn = 7
            }
            else{
                newMatrix = matix
                newRow = row - 1
                newColumn = column
            }
        case .down:
            if (row + 1) > 7{
                newMatrix = .third
                newColumn = 7
                newRow = column
            }
            else{
                newMatrix = matix
                newRow = row + 1
                newColumn = column
            }
        case .left:
            if (column - 1) < 0{
                newMatrix = .first
                newColumn = 7
            }
            else{
                newMatrix = matix
                newColumn = column - 1
            }
            newRow = row
        case .right:
            if (column + 1) > 7{
                newMatrix = .fifth
                newColumn = 0
            }
            else{
                newMatrix = matix
                newColumn = column + 1
            }
            newRow = row
        }
    case .fifth:
        switch direction {
        case .up:
            if (row - 1) < 0{
                newMatrix = .sixth
                newRow = 0
            }
            else{
                newMatrix = matix
                newRow = row - 1
            }
            newColumn = column
        case .down:
            if (row + 1) > 7{
                newMatrix = .third
                newRow = 7
            }
            else{
                newMatrix = matix
                newRow = row + 1
            }
            newColumn = column
        case .left:
            if (column - 1) < 0{
                newMatrix = .fourth
                newColumn = 7
            }
            else{
                newMatrix = matix
                newColumn = column - 1
            }
            newRow = row
        case .right:
            if (column + 1) > 7{
                newMatrix = .second
                newColumn = 0
            }
            else{
                newMatrix = matix
                newColumn = column + 1
            }
            newRow = row
        }
    case .sixth:
        switch direction {
        case .up:
            if (row - 1) < 0{
                newMatrix = .fifth
                newRow = 0
                newColumn = 7 - column
            }
            else{
                newMatrix = matix
                newRow = row - 1
                newColumn = column
            }
        case .down:
            if (row + 1) > 7{
                newMatrix = .first
                newRow = 0
            }
            else{
                newMatrix = matix
                newRow = row + 1
            }
            newColumn = column
        case .left:
            if (column - 1) < 0{
                newMatrix = .second
                newColumn = row
                newRow = 0
            }
            else{
                newMatrix = matix
                newColumn = column - 1
                newRow = row
            }
        case .right:
            if (column + 1) > 7{
                newMatrix = .fourth
                newRow = 0
                newColumn = row
            }
            else{
                newMatrix = matix
                newColumn = column + 1
                newRow = row
            }
        }
    
    }
    return Coordinate(matrix: newMatrix, row: newRow, column: newColumn)
}

var matrices = [[[Int]]]()

let firstMatrix = generateLedMatrix(rows: 8, columns: 8)
matrices.append(firstMatrix)

let secondMatrix = generateLedMatrix(rows: 8, columns: 8)
matrices.append(secondMatrix)

let thirdMatrix = generateLedMatrix(rows: 8, columns: 8)
matrices.append(thirdMatrix)

let fourthMatrix = generateLedMatrix(rows: 8, columns: 8)
matrices.append(fourthMatrix)

let fifthMatrix = generateLedMatrix(rows: 8, columns: 8)
matrices.append(fifthMatrix)

let sixthMatrix = generateLedMatrix(rows: 8, columns: 8)
matrices.append(sixthMatrix)

var oldMatrices = matrices

var snake = createSnake()


matrices = placeSnake(matrices: matrices, snake: snake)
matrices = placeFood(matrices)


matrices = removeSnake(matrices: matrices, snake: snake)

snake = move(snake)
snake.direction = .left
snake = move(snake)
snake.direction = .down
snake = growSnake(snake)
snake = move(snake)
snake = move(snake)
snake = move(snake)
snake.direction = .left
snake = move(snake)
snake = move(snake)
snake = move(snake)


matrices = placeSnake(matrices: matrices, snake: snake)

displayMatrices(matrices)

for (matrixIndex, matrix) in matrices.enumerated(){
    for (rowIndex, row) in matrix.enumerated(){
        
        if matrices[matrixIndex][rowIndex] != oldMatrices[matrixIndex][rowIndex]{
            let value = Int(row.compactMap(){String($0)}.joined(separator: ""), radix: 2) ?? 0
            print("\(matrixIndex):\(rowIndex):\(value)")
        }
        
    }
}

