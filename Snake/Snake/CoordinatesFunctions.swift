//
//  CoordinatesFunctions.swift
//  Snake
//
//  Created by Alejandro Mendoza on 11/25/18.
//  Copyright © 2018 Alejandro Mendoza. All rights reserved.
//

import Foundation

struct Coordinate{
    var matrix: Matrices
    var row: Int
    var column: Int
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
                newMatrix = .fifth
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
                newMatrix = .fifth
                newRow = 7 - column
                newColumn = 0
            }
            else{
                newMatrix = matix
                newRow = row + 1
                newColumn = column
            }
        case .left:
            if (column - 1) < 0{
                newMatrix = .third
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
                newMatrix = .sixth
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
                newMatrix = .fifth
                newRow = 7
                newColumn = 7 - column
            }
            else{
                newMatrix = matix
                newRow = row + 1
                newColumn = column
            }
            
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
    case .fourth:
        switch direction {
        case .up:
            if (row - 1) < 0{
                newMatrix = .sixth
                newRow = 7 - column
                newColumn = 7
            }
            else{
                newMatrix = matix
                newRow = row - 1
                newColumn = column
            }
        case .down:
            if (row + 1) > 7{
                newMatrix = .fifth
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
                newMatrix = .third
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
                newRow = 7
                newColumn = row
            }
            else{
                newMatrix = matix
                newColumn = column + 1
                newRow = row
            }
        }
    case .sixth:
        switch direction {
        case .up:
            if (row - 1) < 0{
                newMatrix = .third
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
                newColumn = 7 - row
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
