//
//  GameScene.swift
//  dolbypottersadventure
//
//  Created by Michael Potter on 2/26/24.
//

import SpriteKit
import GameplayKit
import Darwin

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var austin = SKSpriteNode()
    
    var mike = SKSpriteNode()
    
    var wall = SKSpriteNode()
    
    var wall2 = SKSpriteNode()
    
    var jumps = 10
    
    var level = 0
    
    var isRight = true
    
    
    override func didMove(to view: SKView) {
        
        wall = childNode(withName: "wall") as! SKSpriteNode
        wall.color = .brown
        
        wall2 = childNode(withName: "wall2") as! SKSpriteNode
        wall2.color = .brown
        
        austin = childNode(withName: "austin") as! SKSpriteNode
        austin.color = NSColor.green
        austin.physicsBody?.isDynamic = false
        austin.physicsBody?.restitution = 1.5
        
        createMike()
    }
    
    
    func createMike() {
        mike = SKSpriteNode(color: .blue, size: CGSize(width: 75, height: 75))
        mike.position = CGPoint(x: frame.width*0.5, y: frame.height*0.5)
        mike.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 75, height: 75))
        mike.physicsBody?.restitution = 0.2
        mike.physicsBody?.linearDamping = 0.1
        mike.physicsBody?.angularDamping = 0.1
        mike.physicsBody?.friction = 0.2
        mike.physicsBody?.mass = 1
        mike.physicsBody?.affectedByGravity = true
        
        addChild(mike)
    }
    
    override func mouseDown(with event: NSEvent) {
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
            case 0: // move left with A
                fallthrough
            case 123: // move left with arrow key
                mike.physicsBody?.velocity = CGVector(dx: -275, dy: mike.physicsBody?.velocity.dy ?? 0)
                isRight = false
            case 2: // move right with D
                fallthrough
            case 124: // move right with arrow key
                mike.physicsBody?.velocity = CGVector(dx: 275, dy: mike.physicsBody?.velocity.dy ?? 0)
                isRight = true
            case 0x31: // jump with space
                if (jumps == 10  /*&& mike.position.y < 51*/){
                    mike.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1005))
                    jumps = 0
                }
            case 1: // shoot projectile with S
                addProjectile(mike.position, isRight)
            default:
                print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if jumps == 0 {
            jumps = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.jumps = 10
            }
        }
        if mike.position.x > 1024 {
            mike.position = CGPoint(x: 1, y: mike.position.y)
            level += 1
        }
        else if mike.position.x < 0 {
            mike.position = CGPoint(x: 1023, y: mike.position.y)
            if level != 0 {
                level -= 1
            }
        }
        
        switch level {
            case 0:
                wall.position = CGPoint(x: -50.33248901367188,  y: 384.0007019042969)
                austin.isHidden = true
                austin.position = CGPoint(x: -200, y: 200)
            case 1:
                wall.position = CGPoint(x: 1000, y: 200)
                wall2.position = CGPoint(x: -400, y: 0)
                austin.isHidden = false
                austin.position = CGPoint(x: frame.width*0.8, y: frame.height*0.1)
                austin.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            case 2:
                wall.position = CGPoint(x: -0.33248901367188,  y: 200)
                austin.position = CGPoint(x: frame.width*0.2, y: frame.height*0.1)
                wall2.position = CGPoint(x: 400, y: 300)
                wall2.size = CGSize(width: 132.666, height: 400)
                wall2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 132.666, height: 400))
            default:
                level = 2
        }
    }
    
    func addProjectile(_ location: CGPoint, _ facingRight: Bool)  {
        let ball = SKSpriteNode(color: .red, size: CGSize(width: 25, height: 25))
        ball.position = location
        
        addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody?.friction = 0.2
        ball.physicsBody?.mass = 0.5
        ball.physicsBody?.angularDamping = 0.1
        ball.physicsBody?.linearDamping = 0.1
        ball.physicsBody?.restitution = 0.2
        
        if facingRight {
            ball.position.x += 30
            ball.physicsBody?.applyImpulse(CGVector(dx: 500, dy: 0))
        }
        else {
            ball.position.x -= 30
            ball.physicsBody?.applyImpulse(CGVector(dx: -500, dy: 0))
        }
        
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.allowsRotation = false
        
        DispatchQueue.global(qos: .background).async {
            usleep(400000)
            DispatchQueue.main.async{
                ball.removeFromParent()
            }
        }
    }
}
