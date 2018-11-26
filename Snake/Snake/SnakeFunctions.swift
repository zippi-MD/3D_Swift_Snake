//
//  SnakeFunctions.swift
//  Snake
//
//  Created by Alejandro Mendoza on 11/25/18.
//  Copyright © 2018 Alejandro Mendoza. All rights reserved.
//

import Foundation


struct SnakeBodyPart{
    let matrix: Matrices
    var row: Int
    var column: Int
}

struct Snake{
    var direction: Directions = .up
    var body = [SnakeBodyPart]()
    
    mutating func createSnakeHead(){
        direction = .up
        body.append(SnakeBodyPart(matrix: .first, row: 7, column: 3))
    }
    
    mutating func move(){
        var newSnakeBody: [SnakeBodyPart]
        let snakeHead = body.first!
        var oldCoordinate = Coordinate(matrix: snakeHead.matrix, row: snakeHead.row, column: snakeHead.column)
        
        let newCoordinates = getNewCoordinates(matix: snakeHead.matrix, direction: direction, row: snakeHead.row, column: snakeHead.column)
        
        newSnakeBody = [SnakeBodyPart(matrix: newCoordinates.matrix, row: newCoordinates.row, column: newCoordinates.column)]
        
        
        for bodyPart in body.dropFirst(){
            newSnakeBody.append(SnakeBodyPart(matrix: oldCoordinate.matrix, row: oldCoordinate.row, column: oldCoordinate.column))
            
            oldCoordinate.matrix = bodyPart.matrix
            oldCoordinate.row = bodyPart.row
            oldCoordinate.column = bodyPart.column
        }
        
        
        body = newSnakeBody
    }
    
    mutating func grow(){
        let growDirection: Directions
        
        switch direction {
        case .up:
            growDirection = .down
        case .down:
            growDirection = .up
        case .left:
            growDirection = .right
        case .right:
            growDirection = .left
        }
        
        let snakeTail = body.last!
        let newCoordinates = getNewCoordinates(matix: snakeTail.matrix, direction: growDirection, row: snakeTail.row, column: snakeTail.column)
        
        body.append(SnakeBodyPart(matrix: newCoordinates.matrix, row: newCoordinates.row, column: newCoordinates.column))
        
    }
    
    func biteHimself() -> Bool{
        let snakeHead = body.first!
        
        for bodyPart in body.dropFirst(){
            if(bodyPart.matrix == snakeHead.matrix && bodyPart.row == snakeHead.row && bodyPart.column == snakeHead.column){
                return true
            }
        }
        return false
    }
    
    
}
