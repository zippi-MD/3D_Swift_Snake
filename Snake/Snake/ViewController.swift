//
//  ViewController.swift
//  Snake
//
//  Created by Alejandro Mendoza on 11/25/18.
//  Copyright © 2018 Alejandro Mendoza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var snake = Snake()
    
    var matrices = [[[Int]]]()
    var oldMatrices = [[[Int]]]()
    
    var food = Coordinate(matrix: .first, row: 0, column: 0)
    var counter = 0
    
    var valuesToUpdate = [String]()
    
    var timer: Timer? = nil
    
    var updateMatricesTimer: Timer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }
    
    @objc func sayHi(){
        counter += 1
        print("--------\(counter)-----------")
        oldMatrices = matrices
        matrices = removeSnake(matrices: matrices, snake: snake)
        snake.move()
        
        if snake.biteHimself(){
            print("Se mordió")
            let ac = UIAlertController(title: "Perdiste", message: "Volver a jugar?", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Si!", style: .default){
                [unowned self] _ in
                self.startGame()
            }
            ac.addAction(accept)
            present(ac, animated: true)
            stopTimer()
            return
        }
        
        if didSnakeAte(snakeHead: snake.body.first!, food: food){
            snake.grow()
            matrices = placeSnake(matrices: matrices, snake: snake)
            food = getFoodCoordinate(matricesWithSnakePlaced: matrices)
            matrices = placeFood(matrices: matrices, foodCoordinate: food)
            compareMatrices(oldMatrices: oldMatrices, actualMatrices: matrices)
            displayMatrix(matrices.first!)
            return
        }
        
        matrices = placeSnake(matrices: matrices, snake: snake)
        compareMatrices(oldMatrices: oldMatrices, actualMatrices: matrices)
        displayMatrix(matrices.first!)
    }
    
    @objc func updateMatrices(){
        if !valuesToUpdate.isEmpty{
            print(valuesToUpdate.removeFirst())
        }
    }
    
    func startGame(){
        matrices.removeAll(keepingCapacity: true)
        
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
        
        oldMatrices = matrices
        
        snake.body.removeAll(keepingCapacity: true)
        snake.createSnakeHead()
        
        matrices = placeSnake(matrices: matrices, snake: snake)
        food = getFoodCoordinate(matricesWithSnakePlaced: matrices)
        matrices = placeFood(matrices: matrices, foodCoordinate: food)
        
        compareMatrices(oldMatrices: oldMatrices, actualMatrices: matrices)
        
        displayMatrices(matrices)
        startMatrixUpdate()
        startTimer()
    }

    
    @IBAction func snakeDown(_ sender: Any) {
        
        if(snake.direction == .down || snake.direction == .up){
            return
        }
        snake.direction = .down
    }
    
    @IBAction func snakeUp(_ sender: Any) {
        
        if(snake.direction == .up || snake.direction == .down){
            return
        }
        snake.direction = .up
    }
    
    @IBAction func snakeRight(_ sender: Any) {
        
        if(snake.direction == .right || snake.direction == .left){
            return
        }
        snake.direction = .right
    }
    
    @IBAction func snakeLeft(_ sender: Any) {
        
        if(snake.direction == .left || snake.direction == .right){
            return
        }
        snake.direction = .left
    }
    
    
    
    func startTimer(){
        if timer == nil{
            timer = Timer.scheduledTimer(
                                            timeInterval: 1.0,
                                            target: self,
                                            selector: #selector(sayHi),
                                            userInfo: nil,
                                            repeats: true
                                        )
        }
    }
    
    func stopTimer(){
        if timer != nil{
            timer?.invalidate()
            timer = nil
        }
    }
    
    func startMatrixUpdate(){
        if updateMatricesTimer == nil{
            updateMatricesTimer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(updateMatrices),
                userInfo: nil,
                repeats: true)
        }
    }
    
    func compareMatrices(oldMatrices: [[[Int]]], actualMatrices: [[[Int]]]){
        for (matrixIndex, matrix) in actualMatrices.enumerated(){
            for (rowIndex, row) in matrix.enumerated(){
                if matrices[matrixIndex][rowIndex] != oldMatrices[matrixIndex][rowIndex]{
                    let value = Int(row.compactMap(){String($0)}.joined(separator: ""), radix: 2) ?? 0
                    valuesToUpdate.append("\(matrixIndex):\(rowIndex):\(value)")
                }
                
            }
        }
    }
    
}

