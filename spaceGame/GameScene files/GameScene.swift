//
//  GameScene.swift
//  spaceGame
//
//  Created by Abhishek Biswas on 20/04/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene{
    
    let playerView = SKSpriteNode(imageNamed: "playerShip")
    let scoreLabel = SKLabelNode(text: "Score: 0")
    let liveLabel = SKLabelNode(text: "Max Lives: 3")
    private lazy var beginLabel : SKLabelNode = {
        var bLabel = SKLabelNode(text: "Tap To Begin")
        bLabel.fontColor = SKColor.white
        bLabel.fontSize = 100
        bLabel.zPosition = 1
        bLabel.alpha = 0
        return bLabel
    }()
    
    let gameArea : CGRect?
    var gameScore : Int = 0
    var maxLives : Int = 3
    var currentLabel : Int = 0
    var currentGameState : GameState = GameState.preGame
    var lastUpdateTime : TimeInterval = 0
    var deltaTime : TimeInterval = 0
    var amountToMovePerSeconds : CGFloat = 600.0
    
    
    override init(size: CGSize) {
        let aspectRatio : CGFloat = 16.0/9.0
        let playableWidth = size.width / aspectRatio
        let playableMargin = (size.width - playableWidth)/2
        self.gameArea = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.gameScore = 0
        self.currentGameState = GameState.preGame
        self.maxLives = 3
        self.physicsWorld.contactDelegate = self
        
        self.makeMovingBackGround()
        
        self.beginLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(self.beginLabel)
        let fadeInActionTapLabel = SKAction.fadeIn(withDuration: 0.3)
        self.beginLabel.run(fadeInActionTapLabel)
        
        self.playerView.setScale(1)
        self.playerView.position = CGPoint(x: self.size.width/2, y: -self.size.height * 0.2)
        self.playerView.zPosition = 2
        self.playerView.physicsBody = SKPhysicsBody(rectangleOf: self.playerView.size)
        self.playerView.physicsBody?.affectedByGravity = false
        self.playerView.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.playerView.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.playerView.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        self.addChild(self.playerView)
        
    
        self.scoreLabel.fontSize = 50
        self.scoreLabel.fontColor = SKColor.white
        self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.scoreLabel.position = CGPoint(x: self.size.width * 0.20, y: self.size.height + self.scoreLabel.frame.size.height)
        self.scoreLabel.zPosition = 100
        self.addChild(self.scoreLabel)
        
        
        self.liveLabel.fontSize = 50
        self.liveLabel.fontColor = SKColor.white
        self.liveLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        self.liveLabel.position = CGPoint(x: self.size.width * 0.80, y: self.size.height + self.liveLabel.frame.size.height)
        self.liveLabel.zPosition = 100
        self.addChild(self.liveLabel)
        
        
        let moveOnToScreen = SKAction.moveTo(y: self.size.height * 0.9, duration: 0.3)
        self.scoreLabel.run(moveOnToScreen)
        self.liveLabel.run(moveOnToScreen)
    }
    
    
    private func makeMovingBackGround() {
        for i in 0...1{
            let background = SKSpriteNode(imageNamed: "background")
            background.name = "Background"
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2, y: self.size.height * CGFloat(i))
            background.zPosition = 0
            self.addChild(background)
        }
    }
    
    
    private func startGame() {
        self.currentGameState = GameState.inGame
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let tapSeq = SKAction.sequence([fadeOutAction, deleteAction])
        self.beginLabel.run(tapSeq)
        
        let heroShipMove = SKAction.moveTo(y: self.size.height * 0.2, duration: 0.5)
        let startLevelAction = SKAction.run(self.startNewGameLabel)
        let startSeq = SKAction.sequence([heroShipMove, startLevelAction])
        self.playerView.run(startSeq)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }else{
            self.deltaTime = currentTime - self.lastUpdateTime
            self.lastUpdateTime = currentTime
        }
        let amountToMoveBackground = self.amountToMovePerSeconds * CGFloat(self.deltaTime)
        self.enumerateChildNodes(withName: "Background") { (node, ptr) in
            if self.currentGameState == GameState.inGame {
                node.position.y -= amountToMoveBackground
                if node.position.y < -self.size.height {
                    node.position.y += self.size.height * 2
                }
            }
        }
        
    }
    
    
    private func removeLives() {
        self.maxLives -= 1
        self.liveLabel.text = "Max Lives: \(self.maxLives)"
        let scaleUpAnimatingLives = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDownAnimatingLives = SKAction.scale(to: 1, duration: 0.2)
        let scaleChain = SKAction.sequence([scaleUpAnimatingLives, scaleDownAnimatingLives])
        self.liveLabel.run(scaleChain)
        
        if(self.maxLives == 0){
            self.runGameOver()
        }
    }
    

    private func runGameOver() {
        self.currentGameState = GameState.postGame
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Bullet") { (node, ptr) in
            node.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy") { (node, ptr) in
            node.removeAllActions()
        }
        let changeScenceAction = SKAction.run(self.changeGameScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeChainScene = SKAction.sequence([waitToChangeScene, changeScenceAction])
        self.run(changeChainScene)
    }
    
    private func changeGameScene() {
        let gameOverscence = GameOverScene(size: self.size)
        gameOverscence.scaleMode = self.scaleMode
        let gameOverTransition = SKTransition.fade(withDuration: 0.5)
        gameOverscence.gameScore = self.gameScore
        self.view?.presentScene(gameOverscence, transition: gameOverTransition)
    }
    
    
    private func addScore() {
        self.gameScore += 1
        self.scoreLabel.text = "Score: \(self.gameScore)"
        
        if self.gameScore == 10 || self.gameScore == 20 || self.gameScore == 30 {
            self.startNewGameLabel()
        }
    }
    
    
    private func fireSpaceBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = playerView.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        self.addChild(bullet)

        let moveAction = SKAction.moveTo(y: size.height + bullet.size.height, duration: 1)
        let deleteAction = SKAction.removeFromParent()
        let bulletSequenceAction = SKAction.sequence([moveAction, deleteAction])
        bullet.run(bulletSequenceAction)
    }
    
    
    
    private func startNewGameLabel() {
        self.currentLabel += 1
        if self.action(forKey: "spawnEnemy") != nil{
            self.removeAction(forKey: "spawnEnemy")
        }
        var labelDuration : TimeInterval = TimeInterval()
        
        switch self.currentLabel {
            case 1:
                labelDuration = 1.2
                break
            case 2:
                labelDuration = 1
                break
            case 3:
                labelDuration = 0.8
                break
            case 4:
                labelDuration = 0.5
                break
            default:
                labelDuration = 1
                break
        }
        
        let spawn = SKAction.run(self.spawnEnemy)
        let waitToEnemySpawn = SKAction.wait(forDuration: labelDuration)
        let spawnEnemyChain = SKAction.sequence([waitToEnemySpawn, spawn])
        let spawnRunForever = SKAction.repeatForever(spawnEnemyChain)
        self.run(spawnRunForever, withKey: "spawnEnemy")
    }
    
    
    
    private func spawnEnemy() -> Void {
        guard let safeGameArea = self.gameArea else {return}
        let randomStartPoint = UtiliyClass.shared.randomPositionPoints(min: CGRectGetMinX(safeGameArea), max: CGRectGetMaxX(safeGameArea))
        let randomEndPoint = UtiliyClass.shared.randomPositionPoints(min: CGRectGetMinX(safeGameArea), max: CGRectGetMaxX(safeGameArea))
        
        let actualStart = CGPoint(x: randomStartPoint, y: self.size.height * 1.2)
        let actualEnd = CGPoint(x: randomEndPoint, y: -self.size.height * 0.2)
        
        let enemyObject = SKSpriteNode(imageNamed: "enemyShip")
        enemyObject.name = "Enemy"
        enemyObject.setScale(1)
        enemyObject.position = actualStart
        enemyObject.zPosition = 1
        enemyObject.physicsBody = SKPhysicsBody(rectangleOf: enemyObject.size)
        enemyObject.physicsBody?.affectedByGravity = false
        enemyObject.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemyObject.physicsBody?.collisionBitMask = PhysicsCategory.None
        enemyObject.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Bullet
        self.addChild(enemyObject)
        
        
        let enemyMove = SKAction.move(to: actualEnd, duration: 2)
        let deleteEnemyAfterScreenEnd = SKAction.removeFromParent()
        let looseLife = SKAction.run(self.removeLives)
        let enemyRoleChain = SKAction.sequence([enemyMove, deleteEnemyAfterScreenEnd, looseLife])
        if self.currentGameState == GameState.inGame {
            enemyObject.run(enemyRoleChain)
        }
        
        let deltaX = actualEnd.x - actualStart.x
        let deltaY = actualEnd.y - actualStart.y
        let amountRandomRotate = atan2(deltaY, deltaX)
        
        enemyObject.zRotation = amountRandomRotate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if(currentGameState == GameState.preGame){
            self.startGame()
        }
        
        
        if (currentGameState == GameState.inGame) {
            self.fireSpaceBullet()
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for touch in touches {
            let currentPoint = touch.location(in: self)
            let prevPoint = touch.previousLocation(in: self)
            let delta = currentPoint.x - prevPoint.x
            if currentGameState == GameState.inGame {
                self.playerView.position.x += delta
            }
            if let playableArea = self.gameArea {
                if(self.playerView.position.x > (CGRectGetMaxX(playableArea) - (self.playerView.size.width / 2))){
                    self.playerView.position.x = CGRectGetMaxX(playableArea) - (self.playerView.size.width / 2)
                }
                
                if(self.playerView.position.x < (CGRectGetMinX(playableArea) + (self.playerView.size.width))) {
                    self.playerView.position.x = CGRectGetMinX(playableArea) + (self.playerView.size.width / 2)
                }
            }
        }
    }
    
    
    private func spawnExpodeAfterHitting(spawnPosition : CGPoint) -> Void {
        let explodeSprideNode = SKSpriteNode(imageNamed: "explosion")
        explodeSprideNode.position = spawnPosition
        explodeSprideNode.zPosition = 3
        explodeSprideNode.setScale(0)
        self.addChild(explodeSprideNode)
        let scaleInAction = SKAction.scale(to: 1, duration: 0.1)
        let fadeAction = SKAction.fadeOut(withDuration: 0.1)
        let deleteExplode = SKAction.removeFromParent()
        let explodeSeq = SKAction.sequence([scaleInAction, fadeAction, deleteExplode])
        explodeSprideNode.run(explodeSeq)
        
    }
}


extension GameScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            body1 = contact.bodyA
            body2 = contact.bodyB
        }else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if (body1.categoryBitMask == PhysicsCategory.Player && body2.categoryBitMask == PhysicsCategory.Enemy) {
            if body1.node != nil{
                if let body1Pos = body1.node?.position {
                    self.spawnExpodeAfterHitting(spawnPosition: body1Pos)
                }
            }
            if body2.node != nil {
                if let body2Pos = body2.node?.position {
                    self.spawnExpodeAfterHitting(spawnPosition: body2Pos)
                }
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            self.runGameOver()
        }else if (body1.categoryBitMask == PhysicsCategory.Bullet && body2.categoryBitMask == PhysicsCategory.Enemy){
            self.addScore()
            if body2.node != nil {
                if let posYbody2 = body2.node?.position.y, let body2Pos = body2.node?.position{
                    if posYbody2 < self.size.height {
                        self.spawnExpodeAfterHitting(spawnPosition: body2Pos)
                        if body1.node != nil {
                            body1.node?.removeFromParent()
                        }
                        body2.node?.removeFromParent()
                    }else {
                        return
                    }
                }
            }
        }
    }
}
