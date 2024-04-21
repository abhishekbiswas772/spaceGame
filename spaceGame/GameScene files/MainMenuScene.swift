//
//  MainMenuScene.swift
//  spaceGame
//
//  Created by Abhishek Biswas on 21/04/24.
//

import SpriteKit
import GameplayKit


class MainMenuScene : SKScene {
    
    private lazy var background : SKSpriteNode = {
        var backgroundView = SKSpriteNode(imageNamed: "background")
        backgroundView.zPosition = 0
        return backgroundView
    }()
    
    private lazy var creatorName : SKLabelNode = {
        var cName = SKLabelNode(text: "Advance's")
        cName.fontSize = 55
        cName.fontColor = SKColor.white
        cName.zPosition = 1
        return cName
    }()
    
    
    private lazy var gameNameLabel : SKLabelNode = {
        var gName = SKLabelNode(text: "Space")
        gName.verticalAlignmentMode = .center
        gName.fontSize = 150
        gName.fontColor = SKColor.white
        gName.zPosition = 1
        return gName
    }()
    
    private lazy var gameNameLabel2 : SKLabelNode = {
        var gName = SKLabelNode(text: "Defenders")
        gName.verticalAlignmentMode = .center
        gName.fontSize = 150
        gName.fontColor = SKColor.white
        gName.zPosition = 1
        return gName
    }()
    
    private lazy var gameStartLabel : SKLabelNode = {
        var gSName = SKLabelNode(text: "Start Game")
        gSName.fontSize = 150
        gSName.fontColor = SKColor.white
        gSName.zPosition = 1
        gSName.name = "Start Button"
        return gSName
    }()
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.background.position = CGPoint(x: self.size.width / 2, y: self.size.height/2)
        self.addChild(self.background)
        self.creatorName.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.70)
        self.addChild(self.creatorName)
        self.gameNameLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.64)
        self.addChild(self.gameNameLabel)
        self.gameNameLabel2.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.57)
        self.addChild(self.gameNameLabel2)
        self.gameStartLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.40)
        self.addChild(self.gameStartLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
            let pointOfContact = touch.location(in: self)
            if self.gameStartLabel.contains(pointOfContact){
                let sceneToMove = GameScene(size: self.size)
                sceneToMove.scaleMode = self.scaleMode
                let gameInTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMove, transition: gameInTransition)
            }
            
        }
    }
}
