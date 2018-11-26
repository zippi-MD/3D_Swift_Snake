//
//  MatricesFunctions.swift
//  Snake
//
//  Created by Alejandro Mendoza on 11/25/18.
//  Copyright © 2018 Alejandro Mendoza. All rights reserved.
//

import Foundation

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

func getFoodCoordinate(matricesWithSnakePlaced matrices: [[[Int]]]) -> Coordinate{
    var randomMatrixSelector = Int.random(in: 0..<matrices.count)
    randomMatrixSelector = 0
    
    var matrix = matrices[randomMatrixSelector]
    var row: Int
    var column: Int
    
    repeat{
        row = Int.random(in: 0..<matrix.count)
        column = Int.random(in: 0..<matrix[0].count)
    } while matrix[row][column] == 1
    
    return Coordinate(matrix: Matrices(rawValue: randomMatrixSelector)!, row: row, column: column)
}


func placeFood(matrices: [[[Int]]], foodCoordinate: Coordinate) -> [[[Int]]]{
    var newMatrices = matrices
    
    newMatrices[foodCoordinate.matrix.rawValue][foodCoordinate.row][foodCoordinate.column] = 4
    
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

func didSnakeAte(snakeHead: SnakeBodyPart, food: Coordinate) -> Bool{
    return(snakeHead.matrix == food.matrix && snakeHead.row == food.row && snakeHead.column == food.column)
}
