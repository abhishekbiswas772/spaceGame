//
//  GameOverScene.swift
//  spaceGame
//
//  Created by Abhishek Biswas on 21/04/24.
//

import SpriteKit
import GameplayKit

class GameOverScene : SKScene {
    
    let background = SKSpriteNode(imageNamed: "background")
    var gameScore : Int = 0
    
    private lazy var scoreLabel : SKLabelNode = {
       var sLabel = SKLabelNode(text: "Score: 0")
        sLabel.fontSize = 125
        sLabel.fontColor = SKColor.white
        sLabel.zPosition = 1
        return sLabel
    }()
    
    private lazy var gameOverLabel : SKLabelNode = {
        var gOverLabel = SKLabelNode(text: "Game Over")
        gOverLabel.fontSize = 150
        gOverLabel.fontColor = SKColor.white
        gOverLabel.zPosition = 1
        return gOverLabel
    }()
    
    private lazy var highScoreLabel : SKLabelNode = {
        var hScoreLbl = SKLabelNode(text: "High Score: 0")
        hScoreLbl.fontSize = 120
        hScoreLbl.fontColor = SKColor.white
        hScoreLbl.zPosition = 1
        return hScoreLbl
    }()
    
    
    private lazy var restartLabelBtn : SKLabelNode = {
        var rLabelBtn = SKLabelNode(text: "Restart")
        rLabelBtn.fontSize = 100
        rLabelBtn.zPosition = 1
        rLabelBtn.fontColor = SKColor.white
        return rLabelBtn
    }()
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.background.size = self.size
        self.background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.background.zPosition = 0
        self.addChild(self.background)
        self.gameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        self.addChild(self.gameOverLabel)
        self.scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.55)
        self.scoreLabel.text = "Score: \(self.gameScore)"
        self.addChild(self.scoreLabel)
        self.getHighScoreAndMakeLabel()
        self.restartLabelBtn.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.3)
        self.addChild(self.restartLabelBtn)
    }
    
    
    private func getHighScoreAndMakeLabel() {
        if let highScore = UserDefaults.standard.object(forKey: "high_score") as? Int {
            if self.gameScore > highScore {
                UserDefaults.standard.set(self.gameScore, forKey: "high_score")
                UserDefaults.standard.synchronize()
                self.highScoreLabel.text = "High Score: \(self.gameScore)"
            } else {
                self.highScoreLabel.text = "High Score: \(highScore)"
            }
        } else {
            UserDefaults.standard.set(self.gameScore, forKey: "high_score")
            UserDefaults.standard.synchronize()
            self.highScoreLabel.text = "High Score: \(self.gameScore)"
        }
        self.highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.45)
        self.addChild(self.highScoreLabel)
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
            let pointOfTouch = touch.location(in: self)
            if self.restartLabelBtn.contains(pointOfTouch){
                let sceneToMove = GameScene(size: self.size)
                sceneToMove.scaleMode = self.scaleMode
                let gameInTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMove, transition: gameInTransition)
            }
        }
    }
}
