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
    var food = Coordinate(matrix: .first, row: 0, column: 0)
    var counter = 0
    
    var timer: Timer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }
    
    @objc func sayHi(){
        counter += 1
        print("--------\(counter)-----------")
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
            displayMatrix(matrices.first!)
            return
        }
        
        matrices = placeSnake(matrices: matrices, snake: snake)
        displayMatrix(matrices.first!)
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
        
        snake.body.removeAll(keepingCapacity: true)
        snake.createSnakeHead()
        
        matrices = placeSnake(matrices: matrices, snake: snake)
        food = getFoodCoordinate(matricesWithSnakePlaced: matrices)
        matrices = placeFood(matrices: matrices, foodCoordinate: food)
        displayMatrices(matrices)
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
    
}

