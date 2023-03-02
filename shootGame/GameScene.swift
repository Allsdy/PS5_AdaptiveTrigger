//
//  GameScene.swift
//  shootGame
//
//  Created by Allen Yang on 2023/3/1.
//

import SpriteKit
import GameplayKit
import GameController

class GameScene: SKScene {
    
    var bRadius: CGFloat = 16
    var ball = SKSpriteNode()
    var ballPosition = CGPoint(x: -200, y: -300.0)
    
    var bullet = SKSpriteNode()
    var bulletPosition = CGPoint(x: -120, y: -304.0)
    
    var bulletNameTag = 0
    
//    var holdingTrigger = false
    
    var playerIsPullingSlingshot = true
    
    var dualSense: GCDualSenseGamepad = GCDualSenseGamepad()
    var leftThumbstick: GCControllerDirectionPad = GCControllerDirectionPad()
    
    let texture1 = SKTexture(imageNamed: "stand1")
    let texture2 = SKTexture(imageNamed: "fire1")
    let texture3 = SKTexture(imageNamed: "fire2")

    override func didMove(to view: SKView) {
        
        ball = self.childNode(withName: "stand1") as! SKSpriteNode
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.isDynamic = true
        ball.position = ballPosition
        ball.zPosition = 2.0
        
        bullet = SKSpriteNode(imageNamed: "bullet")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func bulletShoot() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bulletNameTag += 1
        
        bullet.position = CGPoint(x: 20, y: 10)
        bullet.zPosition = 1.0
        bullet.name = "bullet" + String(bulletNameTag)
        ball.addChild(bullet)
    }

    func updateControllerAdaptiveTriggers() {
        if let controller = GCController.current?.physicalInputProfile as? GCDualSenseGamepad{
            dualSense = controller
        }else {
                print("Not a dual sense game controller!")
                return
            }
        let adaptiveTrigger = dualSense.rightTrigger

        if playerIsPullingSlingshot {
//        let resistiveStrength = min(1, 0.2 + adaptiveTrigger.value)
        if adaptiveTrigger.value < 0.8 {
//            holdingTrigger = false
            
            adaptiveTrigger.setModeFeedbackWithStartPosition(0, resistiveStrength: adaptiveTrigger.value)
                ball.scale(to: CGSize(width: 75, height: 95))
                ball.texture = texture1

            } else {
//                holdingTrigger = true
                
                adaptiveTrigger.setModeVibrationWithStartPosition(0, amplitude: 1, frequency: 0.08)
//                ball.scale(to: CGSize(width: 125, height: 95))
                ball.texture = texture3
                
                bulletShoot()
            }
        } else if adaptiveTrigger.mode != .off {
            adaptiveTrigger.setModeOff()
            
        }
    }
    
    func moveBall() {
        let leftThumbstick = dualSense.leftThumbstick

        ballPosition.x += CGFloat(leftThumbstick.xAxis.value * 5)
        ball.position = ballPosition
        
        print(ball.position.x)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveBall()
        updateControllerAdaptiveTriggers()
        
        if ball.children != [] {
//            print("im in")
            for i in ball.children {
                i.position.x += CGFloat(5)
                
                if i.position.x > CGFloat(430) {
                    i.removeFromParent()
                }
            }
        }
    }
}
