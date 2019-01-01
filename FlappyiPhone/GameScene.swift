//
//  GameScene.swift
//  FlappyiPhone
//
//  Created by Tsznok Wong on 26/1/2016.
//  Copyright (c) 2016 Tsznok Wong. All rights reserved.
//

import SpriteKit
import AVFoundation



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Phone = SKSpriteNode()
    var phoneMass = CGFloat()
    
    var BandPair = SKNode()
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    var Score = Int()
    let scoreLabel = SKLabelNode()
    var scoreShow = Bool()
    var maxScore: Int = 0
    var maxScoreLabel = SKLabelNode()
    
    var coins = Int()
    var coinsLabel = SKLabelNode()
    var coinsIcon = SKSpriteNode()
    
    var died = Bool()
    var restartButton = SKSpriteNode()
    
    
    func restartScene(){
        /* remove nodes*/
        for node in self.children {
            if node.name == "board" || node.name == "gameOver" || node.name == "restartButton" {
                node.shrink(0.2)
            }
            else if node.name != "BGM" {
                node.removeFromParent()
            }
        }
        died = false
        gameStarted = false
        Score = 0
        scoreShow = false
        createGameScene()
    }
    
    func createGameScene(){
        print(self.frame.width, self.frame.height)
        /* Settings */
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        /* Game Name Label */
        let gameName = SKSpriteNode(imageNamed: "gameName")
        setSKSpriteNodeProperty(gameName, name: "gameName", width: self.frame.width - 50, height: (self.frame.width - 50) * 140 / 962, x: self.frame.width / 2, y: self.frame.height * 3 / 4, zPosition: 5, setScale: nil)
        self.addChild(gameName)
        gameName.pop(0.3)
        
        /* Verison Label*/
        let versionLabel = SKLabelNode()
        let release = Bundle.main.releaseVersionNumber
        let build = Bundle.main.buildVersionNumber
        setSKLabelNodeProperty(versionLabel, text: "ver: \(release!)\(build == nil ? "" : "b\(build!)")", name: "versionLabel", x: (self.frame.width / 2 + (self.frame.width - 50) / 4), y: (self.frame.height * 3 / 4 - (self.frame.width - 50) * 140 / 962), fontName: nil, fontSize: 20, fontColor: SKColor.yellow, zPosition: 5)
        self.addChild(versionLabel)
        versionLabel.pop(0.3)
        
        /* Background */
        for i in 0 ..< 2 {
            let Background = SKSpriteNode(imageNamed: "Background")
            setSKSpriteNodeProperty(Background, name: "background", width: self.frame.width, height: self.frame.height, x: CGFloat(i) * self.frame.width, y: 0, zPosition: 0, setScale: nil)
            Background.anchorPoint = CGPoint.zero
            //Background.size = (self.view?.bounds.size)!
            self.addChild(Background)
        }
        
        /* Ground */
        for i in 0 ..< 4 {
            let Ground = SKSpriteNode(imageNamed: "Ground")
            setSKSpriteNodeProperty(Ground, name: "ground", width: self.frame.width, height: 40, x: CGFloat(i) * self.frame.width, y: 20, zPosition: 3, setScale: nil)
            if #available(iOS 8.0, *) {
                Ground.physicsBody = SKPhysicsBody(texture: Ground.texture!, size: Ground.size)
            } else {
                Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
            }
            Ground.physicsBody?.categoryBitMask = Physics.Ground
            Ground.physicsBody?.collisionBitMask = Physics.Phone
            Ground.physicsBody?.contactTestBitMask = Physics.Phone
            Ground.physicsBody?.affectedByGravity = false
            Ground.physicsBody?.isDynamic = false
            self.addChild(Ground)
        }
        
        /* Phone */
        Phone = SKSpriteNode(imageNamed: "Phone")
        setSKSpriteNodeProperty(Phone, name: "phone", width: 39.2, height: 69.6, x: self.frame.width / 2 - Phone.frame.width, y: self.frame.height / 2, zPosition: 2, setScale: nil)
        if #available(iOS 8.0, *) {
            Phone.physicsBody = SKPhysicsBody(texture: Phone.texture!, size: Phone.size)
        } else {
            Phone.physicsBody = SKPhysicsBody(rectangleOf: Phone.size)
        }
        Phone.physicsBody?.categoryBitMask = Physics.Phone
        Phone.physicsBody?.collisionBitMask = Physics.Ground | Physics.Band
        Phone.physicsBody?.contactTestBitMask = Physics.Ground | Physics.Band | Physics.Score
        Phone.physicsBody?.affectedByGravity = false
        Phone.physicsBody?.isDynamic = true
        Phone.physicsBody?.angularDamping = 1.0
        Phone.physicsBody?.density = 1.0
        phoneMass = (Phone.physicsBody?.mass)!
        self.addChild(Phone)
        
        /* Max Score Label */
        setSKLabelNodeProperty(maxScoreLabel,text: "Top: \(maxScore)", name: "maxScoreLabel", x: self.frame.width / 5 * 4, y: self.frame.height * 7 / 8, fontName: nil, fontSize: 45, fontColor: SKColor.white, zPosition: 5)
        self.addChild(maxScoreLabel)
        
        /* Coins Label */
        setSKLabelNodeProperty(coinsLabel, text: "\(coins)", name: "coinsLabel", x: self.frame.width / 5 + 20, y: self.frame.height * 7 / 8, fontName: nil, fontSize: 45, fontColor: SKColor.yellow, zPosition: 5)
        self.addChild(coinsLabel)
        
        /* Coins Icon */
        coinsIcon = SKSpriteNode(imageNamed: "Coin")
        setSKSpriteNodeProperty(coinsIcon, name: "coin", width: nil, height: nil, x: self.frame.width / 10, y: self.frame.height * 8 / 9, zPosition: 5, setScale: 0.075)
        coinsIcon.size = CGSize(width: self.frame.width / 10, height: self.frame.width / 10)
        self.addChild(coinsIcon)
    }
    
    func endGame(){
        scoreLabel.removeFromParent()
        /* Gameover Image */
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        setSKSpriteNodeProperty(gameOver, name: "gameOver", width: self.frame.width * 7 / 8, height: (self.frame.width * 7 / 8) * 120 / 755 , x: self.frame.width / 2, y: self.frame.height * 3 / 4, zPosition: 6, setScale: 0)
        self.addChild(gameOver)
        gameOver.pop(0.3)
        
        /* Board */
        let board = SKNode()
        board.name = "board"
        let comment: SKSpriteNode
        if maxScore == Score {
            comment = SKSpriteNode(imageNamed: "Board2")
        }
        else {
            comment = SKSpriteNode(imageNamed: "Board1")
        }
        setSKSpriteNodeProperty(comment, name: "board", width: self.frame.width * 7 / 8, height: (self.frame.width * 7 / 8) * 501 / 900, x: 0, y: 0, zPosition: 6, setScale: nil)
        board.addChild(comment)
        
        let scoreLabelOnBoard = SKLabelNode()
        setSKLabelNodeProperty(scoreLabelOnBoard, text: "\(Score)", name: "scoreLabelOnBoard", x: comment.frame.width / 4, y: 0, fontName: "04b_19", fontSize: 80, fontColor: SKColor.blue, zPosition: 7)
        board.addChild(scoreLabelOnBoard)
        
        if maxScore != Score {
            let commentScoreLabel = SKLabelNode()
            setSKLabelNodeProperty(commentScoreLabel, text: "\(maxScore - Score)", name: "commentScoreLabel", x: -comment.frame.width / 4, y: -comment.frame.height / 3, fontName: "04b_19", fontSize: 80, fontColor: SKColor.blue, zPosition: 7)
            board.addChild(commentScoreLabel)
        }
        
        board.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        self.addChild(board)
        board.pop(0.3)
        
        restartButton = SKSpriteNode(imageNamed: "RestartButton_Circle")
        setSKSpriteNodeProperty(restartButton, name: "restartButton", width: 100, height: 100, x: self.frame.width / 2, y: self.frame.height / 5, zPosition: 6, setScale: 0)
        self.addChild(restartButton)
        restartButton.pop(0.3)
        
    }
    
    func createPipes(){
        BandPair = SKNode()
        BandPair.name = "bandPair"
        
        let scoreNode = SKSpriteNode()
        setSKSpriteNodeProperty(scoreNode, name: "scoreNode", width: 30, height: 600, x: self.frame.width + 25, y: self.frame.height / 2, zPosition: 100, setScale: nil)
        
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = Physics.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = Physics.Phone
        //scoreNode.color = SKColor.orangeColor()

        if Int(CGFloat.random(min: 0, max: 99)) % 20 == 0{
            let coin = SKSpriteNode(imageNamed: "Coin")
            setSKSpriteNodeProperty(coin, name: "coin", width: 50, height: 50, x: self.frame.width + 25, y: self.frame.height / 2, zPosition: 0, setScale: nil)
            
            coin.physicsBody = SKPhysicsBody(circleOfRadius: 25)
            coin.physicsBody?.affectedByGravity = false
            coin.physicsBody?.isDynamic = false
            coin.physicsBody?.categoryBitMask = Physics.Coin
            coin.physicsBody?.collisionBitMask = 0
            coin.physicsBody?.contactTestBitMask = Physics.Phone
            BandPair.addChild(coin)
        }
        let topBand = SKSpriteNode(imageNamed: "Band")
        let btmBand = SKSpriteNode(imageNamed: "Band")
        
        setSKSpriteNodeProperty(topBand, name: "topBand", width: nil, height: nil, x: self.frame.width + 25, y: self.frame.height / 2 + 375, zPosition: nil, setScale: 0.5)
        topBand.size = CGSize(width: self.frame.width / 7, height: self.frame.width / 7 * 10)
        setSKSpriteNodeProperty(btmBand, name: "tbtmBand", width: nil, height: nil, x: self.frame.width + 25, y: self.frame.height / 2 - 375, zPosition: nil, setScale: 0.5)
        btmBand.size = CGSize(width: self.frame.width / 7, height: self.frame.width / 7 * 10)
        btmBand.zRotation = CGFloat.pi
        if #available(iOS 8.0, *) {
            topBand.physicsBody = SKPhysicsBody(texture: topBand.texture!, size: topBand.size)
            btmBand.physicsBody = SKPhysicsBody(texture: btmBand.texture!, size: btmBand.size)
        } else {
            topBand.physicsBody = SKPhysicsBody(rectangleOf: topBand.size)
            btmBand.physicsBody = SKPhysicsBody(rectangleOf: btmBand.size)
        }
        topBand.physicsBody?.categoryBitMask = Physics.Band
        topBand.physicsBody?.collisionBitMask = Physics.Phone
        topBand.physicsBody?.contactTestBitMask = Physics.Phone
        topBand.physicsBody?.affectedByGravity = false
        topBand.physicsBody?.isDynamic = false
        

        btmBand.physicsBody?.categoryBitMask = Physics.Band
        btmBand.physicsBody?.collisionBitMask = Physics.Phone
        btmBand.physicsBody?.contactTestBitMask = Physics.Phone
        btmBand.physicsBody?.affectedByGravity = false
        btmBand.physicsBody?.isDynamic = false
    
        BandPair.addChild(topBand)
        BandPair.addChild(btmBand)
        BandPair.addChild(scoreNode)
        BandPair.zPosition = 1
        
        let randomPosition = CGFloat.random(min: -200, max: 200)
        BandPair.position.y += randomPosition
        
        BandPair.run(moveAndRemove)
        self.addChild(BandPair)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        if firstBody.categoryBitMask == Physics.Coin && secondBody.categoryBitMask == Physics.Phone || firstBody.categoryBitMask == Physics.Phone && secondBody.categoryBitMask == Physics.Coin {
            coins += 1
            coinsLabel.text = "\(coins)"
            
            if secondBody.categoryBitMask == Physics.Phone {
                firstBody.node?.removeFromParent()
            }
            else{
                secondBody.node?.removeFromParent()
            }
        }
        if firstBody.categoryBitMask == Physics.Score && secondBody.categoryBitMask == Physics.Phone || firstBody.categoryBitMask == Physics.Phone && secondBody.categoryBitMask == Physics.Score {
            Score += 1
            scoreLabel.text = "\(Score)"
            
            self.physicsWorld.gravity.dy -= 0.05
            self.physicsWorld.gravity.dy = self.physicsWorld.gravity.dy < -19.8 ? -19.8 : self.physicsWorld.gravity.dy

            if secondBody.categoryBitMask == Physics.Phone {
                firstBody.node?.removeFromParent()
            }
            else{
                secondBody.node?.removeFromParent()
            }
            if Score > maxScore {
                maxScore = Score
                maxScoreLabel.text = "Top: \(maxScore)"
            }
        }
        else if firstBody.categoryBitMask == Physics.Phone && secondBody.categoryBitMask == Physics.Band || firstBody.categoryBitMask == Physics.Band && secondBody.categoryBitMask == Physics.Phone || firstBody.categoryBitMask == Physics.Phone && secondBody.categoryBitMask == Physics.Ground || firstBody.categoryBitMask == Physics.Ground && secondBody.categoryBitMask == Physics.Phone {
            
            Phone.texture = SKTexture(imageNamed: "Phone_Broken")
            
            enumerateChildNodes(withName: "bandPair", using: {
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            })
            if #available(iOS 9, *){
                let dropSound = SKAudioNode(fileNamed: "DropSoundEffect.wav")
                dropSound.autoplayLooped = false
                self.addChild(dropSound)
                dropSound.run(SKAction.play())
                let remove = SKAction.sequence([SKAction.wait(forDuration: 0.8),SKAction.removeFromParent()])
                dropSound.run(remove)
            }
            else{
                let dropSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "DropSoundEffect", ofType: "wav")!)
                var dropSoundPlayer = AVAudioPlayer()
                do{
                    try dropSoundPlayer = AVAudioPlayer(contentsOf: dropSoundURL)
                } catch{
                    print("Audio Error")
                }
                dropSoundPlayer.volume = 0.4
                dropSoundPlayer.play()
            }
            if died == false {
                let maxDefault = UserDefaults.standard
                maxDefault.setValue(maxScore, forKey: "maxScore")
                maxDefault.synchronize()
                
                let coinDefault = UserDefaults.standard
                coinDefault.setValue(coins, forKey: "coins")
                coinDefault.synchronize()
                
                died = true
                endGame()
            }
        }
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        if #available(iOS 9, *){
            let BGM = SKAudioNode(fileNamed: "Different Heaven - Nekozilla.mp3")
            BGM.autoplayLooped = true
            BGM.name = "BGM"
            self.addChild(BGM)
            BGM.run(SKAction.play())
        }
        else{
            let BGMURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Different Heaven - Nekozilla", ofType: "mp3")!)
            var BGMPlayer = AVAudioPlayer()
            do{
                try BGMPlayer = AVAudioPlayer(contentsOf: BGMURL)
            } catch{
            print("Audio Error")
            }
            BGMPlayer.volume = 0.4
            BGMPlayer.numberOfLoops = -1
            BGMPlayer.play()
        }
        let maxDefault = UserDefaults.standard
        if maxDefault.value(forKey: "maxScore") != nil {
            maxScore = maxDefault.value(forKey: "maxScore") as! NSInteger
        }
        
        let coinDefault = UserDefaults.standard
        if coinDefault.value(forKey: "coins") != nil {
            coins = coinDefault.value(forKey: "coins") as! NSInteger
        }
        restartScene()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        var flapPlayer = AVAudioPlayer()
        if #available(iOS 9, *){
            
        }
        else {
            let flapURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Flap", ofType: "wav")!)
            do{
                try flapPlayer = AVAudioPlayer(contentsOf: flapURL)
            } catch{
                print("Audio Error")
            }
            flapPlayer.volume = 0.4
        }
        
        if gameStarted == false{
            
            gameStarted = true
            Phone.physicsBody?.affectedByGravity = true
            let spawn = SKAction.run({
                () in
                self.createPipes()
            })
            let delay = SKAction.wait(forDuration: 2)
            let spawnDelay = SKAction.sequence([spawn,delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever)
            
            
            let distance = CGFloat(self.frame.width + BandPair.frame.width)
            let moveBands = SKAction.moveBy( x: -distance - 45, y: 0, duration: TimeInterval(distance / CGFloat(100 + Score > 300 ? 300 : 100 + Score)))
            let removeBands = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([moveBands,removeBands])
            Phone.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Phone.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 60))
            if scoreShow == false{
                scoreShow = true
                setSKLabelNodeProperty(scoreLabel, text: "\(Score)", name: "scoreLabel", x: self.frame.width / 2, y: self.frame.height * 13 / 18, fontName: nil, fontSize: 60, fontColor: SKColor.white, zPosition: 7)
                self.addChild(scoreLabel)
            }
            for node in self.children{
                if node.name == "gameName" || node.name == "versionLabel"{
                    node.shrink(0.2)
                }
            }
            if #available(iOS 9, *) {
                let flap = SKAudioNode(fileNamed: "Flap.wav")
                flap.autoplayLooped = false
                self.addChild(flap)
                flap.run(SKAction.play())
                let remove = SKAction.sequence([SKAction.wait(forDuration: 1.0),SKAction.removeFromParent()])
                flap.run(remove)
            } else {
                flapPlayer.play()
            }
        }
        else{
            if died == true{
                
            }
            else{
                Phone.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                Phone.physicsBody?.angularVelocity = 0.0
                Phone.physicsBody?.applyImpulse(CGVector(dx: 0, dy: phoneMass * sqrt(pow(60 / phoneMass, 2) - 4 * (self.physicsWorld.gravity.dy + 9.8))), at: CGPoint(x: (Phone.position.x + CGFloat.random(min: -5, max: 5)), y: Phone.position.y - Phone.frame.height / 2))
                if #available(iOS 9, *) {
                    let flap = SKAudioNode(fileNamed: "Flap.wav")
                    flap.autoplayLooped = false
                    self.addChild(flap)
                    flap.run(SKAction.play())
                    let remove = SKAction.sequence([SKAction.wait(forDuration: 1.0),SKAction.removeFromParent()])
                    flap.run(remove)
                } else {
                    flapPlayer.play()
                }
            }
        }
        
        
        for touch in touches{
            let location = touch.location(in: self)
            if died == true && restartButton.contains(location){
                died = false
                restartButton.removeFromParent()
                restartScene()
            }
        }

        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
            if died == false{
                enumerateChildNodes(withName: "background", using: {
                    (node, error) in
                    let background = node as! SKSpriteNode
                    background.position = CGPoint(x: background.position.x - 1.5 - CGFloat(self.Score > 200 ? 10 : CGFloat(self.Score) / 20), y: background.position.y)
                    if background.position.x <= -background.size.width{
                        background.position = CGPoint(x: background.position.x + background.size.width * 2, y: background.position.y)
                    }
                })
                enumerateChildNodes(withName: "ground", using: {
                    (node, error) in
                    let ground = node as! SKSpriteNode
                    ground.position = CGPoint(x: ground.position.x - 2 - CGFloat(self.Score > 200 ? 10 : CGFloat(self.Score) / 20), y: ground.position.y)
                    if ground.position.x <= -ground.size.width / 2 {
                        ground.position = CGPoint(x: ground.position.x + ground.size.width * 4, y: ground.position.y)
                    }
                })
            }
        
        
        
    }
}
