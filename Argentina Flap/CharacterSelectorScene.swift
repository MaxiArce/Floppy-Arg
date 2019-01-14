import SpriteKit


class CharacterSelectorScene: SKScene {
    
    var background:SKSpriteNode!
    let backgroundTexture = SKTexture(imageNamed: "characterSelectorBackground.png")
    
    override func didMove(to view: SKView) {
        
        
        background = SKSpriteNode(texture: backgroundTexture)
        background.position = CGPoint(x:self.frame.midX, y: self.frame.midY)
        background.size.height = self.frame.height
        background.size.width = self.frame.width
        background.zPosition = -1
        self.addChild(background)
        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
       
        let touch = touches.first
        
        if let location = touch?.location(in: self)
        {
            
            
            let nodesArray = self.nodes(at: location)
            
            
            if nodesArray.first?.name == "Cristina"
            {
                
                let HomeSceneTemp = HomeScene(fileNamed: "HomeScene")
                run(HomeSceneTemp!.clickSound)
                HomeSceneTemp?.scaleMode = .aspectFit
                HomeSceneTemp?.defaults.set("Cristina", forKey: "Character")
                HomeSceneTemp?.defaults.synchronize()
                self.scene?.view?.presentScene(HomeSceneTemp!, transition: SKTransition.doorway(withDuration: 0.8))
            }
            
            if nodesArray.first?.name == "Macri"
            {
                let HomeSceneTemp = HomeScene(fileNamed: "HomeScene")
                run(HomeSceneTemp!.clickSound)
                HomeSceneTemp?.scaleMode = .aspectFit
                HomeSceneTemp?.defaults.set("Macri", forKey: "Character")
                HomeSceneTemp?.defaults.synchronize()
                self.scene?.view?.presentScene(HomeSceneTemp!, transition: SKTransition.doorway(withDuration: 0.8))
                
            }
            
            if nodesArray.first?.name == "Nestor"
            {
                let HomeSceneTemp = HomeScene(fileNamed: "HomeScene")
                run(HomeSceneTemp!.clickSound)
                HomeSceneTemp?.scaleMode = .aspectFit
                HomeSceneTemp?.defaults.set("Nestor", forKey: "Character")
                HomeSceneTemp?.defaults.synchronize()
                self.scene?.view?.presentScene(HomeSceneTemp!, transition: SKTransition.doorway(withDuration: 0.8))
                
            }
            
            

    }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    
    
}
