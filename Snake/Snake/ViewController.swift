//
//  ViewController.swift
//  Snake
//
//  Created by Alejandro Mendoza on 11/25/18.
//  Copyright © 2018 Alejandro Mendoza. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreMotion
import AVFoundation

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    let impact = UIImpactFeedbackGenerator()
    let motionManager = CMMotionManager()
    var player = AVAudioPlayer()
    
    var manager : CBCentralManager!
    var myBluetoothPeripheral : CBPeripheral!
    var myCharacteristic : CBCharacteristic!
    
    var isMyPeripheralConected = false
    var didStartedNewGame = false
    var didLoseGame = false
    
    @IBOutlet var snakeSizeLabel: UILabel!
    @IBOutlet var matrixPositionLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    
    var snake = Snake()
    
    var matrices = [[[Int]]]()
    var oldMatrices = [[[Int]]]()
    
    var food = Coordinate(matrix: .first, row: 0, column: 0)
    
    var valuesToUpdate = [String]()
    
    var timer: Timer? = nil
    
    var updateMatricesTimer: Timer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil)
        startGyroData()
        startGame()
    }
    
    func startGyroData(){
        motionManager.accelerometerUpdateInterval = 0.1
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!){
            [unowned self] (data, error) in
            if let gyroData = data{
                if(gyroData.acceleration.x * 10 > 4){
                    self.snakeDown(self)
                }
                if(gyroData.acceleration.x * 10 < -4){
                    self.snakeUp(self)
                }
                if(gyroData.acceleration.y * 10 > 4){
                    self.snakeRight(self)
                }
                if(gyroData.acceleration.y * 10 < -4){
                    self.snakeLeft(self)
                }
            }
        }
    }
    
    func playSoundFor(_ sound: Sounds){
        
        var path: String?
        
        if sound == .eat{
            path = Bundle.main.path(forResource: "eat", ofType : "mp3")
        }
        if sound == .lose{
            path = Bundle.main.path(forResource: "lose", ofType : "mp3")
        }
        
        if let soundPath = path{
            let url = URL(fileURLWithPath : soundPath)
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player.play()
                
            } catch {
                
                print ("There is an issue with this code!")
                
            }
        }
        
        
        
    }
    
    @objc func sayHi(){
        oldMatrices = matrices
        matrices = removeSnake(matrices: matrices, snake: snake)
        snake.move()
        
        matrixPositionLabel.text = "Posición: \(snake.body.first!.matrix.rawValue + 1)"
        
        if snake.biteHimself(){
            print("Se mordió")
            didLoseGame = true
            playSoundFor(.lose)
            writeValue()
            let ac = UIAlertController(title: "Perdiste", message: "¿Volver a jugar?", preferredStyle: .alert)
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
            snakeSizeLabel.text = "Tamaño: \(snake.body.count)"
            playSoundFor(.eat)
            matrices = placeSnake(matrices: matrices, snake: snake)
            food = getFoodCoordinate(matricesWithSnakePlaced: matrices)
            matrices = placeFood(matrices: matrices, foodCoordinate: food)
            compareMatrices(oldMatrices: oldMatrices, actualMatrices: matrices)
            return
        }
        
        matrices = placeSnake(matrices: matrices, snake: snake)
        compareMatrices(oldMatrices: oldMatrices, actualMatrices: matrices)
    }
    
    @objc func updateMatrices(){
        if !valuesToUpdate.isEmpty{
            writeValue()
        }
    }
    
    func startGame(){
        
        didStartedNewGame = true
        stepper.value = 0.5
        
        snakeSizeLabel.text = "Tamaño: 1"
        matrixPositionLabel.text = "Posición: 1"
        speedLabel.text = "Velocidad: 0.5"
        
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
        
        startTimer()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        speedLabel.text = "Velocidad: \(String(format: "%.1f", sender.value))"
        stopTimer()
        startTimer()
    }
    

    
    @IBAction func snakeDown(_ sender: Any) {
        
        if(snake.direction == .down || snake.direction == .up){
            return
        }
        snake.direction = .down
        impact.impactOccurred()
    }
    
    @IBAction func snakeUp(_ sender: Any) {
        
        if(snake.direction == .up || snake.direction == .down){
            return
        }
        snake.direction = .up
        impact.impactOccurred()
    }
    
    @IBAction func snakeRight(_ sender: Any) {
        
        if(snake.direction == .right || snake.direction == .left){
            return
        }
        snake.direction = .right
        impact.impactOccurred()
    }
    
    @IBAction func snakeLeft(_ sender: Any) {
        
        if(snake.direction == .left || snake.direction == .right){
            return
        }
        snake.direction = .left
        impact.impactOccurred()
    }
    
    
    
    func startTimer(){
        if timer == nil{
            timer = Timer.scheduledTimer(
                                            timeInterval: stepper.value,
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
                    valuesToUpdate.append("\(matrixIndex):\(rowIndex):\(value)\n")
                }
                
            }
        }
    }
    
//    Bluetooth
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        var msg = ""
        
        switch central.state {
            
        case .poweredOff:
            msg = "Bluetooth is Off"
        case .poweredOn:
            msg = "Bluetooth is On"
            manager.scanForPeripherals(withServices: nil, options: nil)
        case .unsupported:
            msg = "Not Supported"
        default:
            msg = "😔"
            
        }
        
        print("STATE: " + msg)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("Name: \(peripheral.name)")
        
        if peripheral.name == "BT05" {
            
            self.myBluetoothPeripheral = peripheral
            self.myBluetoothPeripheral.delegate = self
            
            manager.stopScan()
            manager.connect(myBluetoothPeripheral, options: nil)
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isMyPeripheralConected = true
        print("Conectado correctamente con: \(peripheral.name ?? "no tiene nombre...")")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isMyPeripheralConected = false
        print("Se perdió la conexión con el dispositivo")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let servicePeripheral = peripheral.services as [CBService]! {
            
            for service in servicePeripheral {
                
                peripheral.discoverCharacteristics(nil, for: service)
                
            }
            
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let characterArray = service.characteristics as [CBCharacteristic]! {
            
            for cc in characterArray {
                
                if(cc.uuid.uuidString == "FFE1") {
                    
                    myCharacteristic = cc
                    
                    peripheral.readValue(for: cc)
                }
                
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if (characteristic.uuid.uuidString == "FFE1") {
            
            let readValue = characteristic.value
            
            let value = (readValue! as NSData).bytes.bindMemory(to: Int.self, capacity: readValue!.count).pointee
            
            print (value)
            startMatrixUpdate()
        }
    }
    
    func writeValue() {
        
        if isMyPeripheralConected {
            var dataToSend: Data
            
            if didStartedNewGame{
                dataToSend = "8:0:0\n".data(using: String.Encoding.utf8)!
                didStartedNewGame.toggle()
                myBluetoothPeripheral.writeValue(dataToSend, for: myCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
                return
            }
            
            if didLoseGame{
                dataToSend = "9:0:0\n".data(using: String.Encoding.utf8)!
                didLoseGame.toggle()
                myBluetoothPeripheral.writeValue(dataToSend, for: myCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
                return
            }
            
            else{
                let info = valuesToUpdate.removeFirst()
                dataToSend = info.data(using: String.Encoding.utf8)!
                myBluetoothPeripheral.writeValue(dataToSend, for: myCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
            }
        } else {
            print("Not connected")
        }
    }
    
    
    
}

