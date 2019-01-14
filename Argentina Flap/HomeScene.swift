import SpriteKit


class HomeScene: SKScene {
    
    var newGameButtonNode:SKSpriteNode!
    var background:SKSpriteNode!
    let backgroundTexture = SKTexture(imageNamed: "BackGroundHome.png")
    let defaults = UserDefaults.standard
    let gameSceneTemp = GameScene(fileNamed: "GameScene")
    var labelDificulty:SKLabelNode!
    var labelImposible:SKLabelNode!
    var buttonCharacterSelected:SKSpriteNode!
    var Selector:SKSpriteNode!
    var animacion:SKAction!
    //sounds
    let musicSound = SKAudioNode(fileNamed: "SuperHimno.mp3")
    let clickSound = SKAction.playSoundFileNamed("click.wav", waitForCompletion: false)
    let switchSound = SKAction.playSoundFileNamed("switch.wav", waitForCompletion: false)

    
    override func didMove(to view: SKView) {
        
        newGameButtonNode = self.childNode(withName: "newGameButton") as? SKSpriteNode
        newGameButtonNode.color = UIColor(white: 1, alpha: 0.5)
        background = SKSpriteNode(texture: backgroundTexture)
        background.position = CGPoint(x:self.frame.midX, y: self.frame.midY)
        background.size.height = self.frame.height
        background.size.width = self.frame.width
        background.zPosition = -2
        self.addChild(background)
        labelDificulty = self.childNode(withName: "labelDificulty") as? SKLabelNode
        labelImposible = self.childNode(withName: "labelImposible") as? SKLabelNode
        setLabels()
        buttonCharacterSelected = self.childNode(withName: "buttonCharacterSelected") as? SKSpriteNode
        setTextureCharacterSelected()
        animateCharacterSelector()
        self.addChild(musicSound)
        
        
        
        
    }
    
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        
        if let location = touch?.location(in: self)
        {
            
        let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameButton"
            {
                self.removeAllActions()
                run(clickSound)
                gameSceneTemp?.dificulty = defaults.string(forKey: "Dificulty")
                gameSceneTemp?.character = defaults.string(forKey: "Character")
                gameSceneTemp?.scaleMode = .aspectFit
                self.scene?.view?.presentScene(gameSceneTemp!, transition: SKTransition.doorsCloseVertical(withDuration: 0.5))
            }
            
            if nodesArray.first?.name  == "changeCharacterButton" || nodesArray.first?.name  == "buttonCharacterSelected"
            {
                self.removeAllActions()
                run(clickSound)
                let characterSelectorSceneTemp =  CharacterSelectorScene(fileNamed: "CharacterSelectorScene")
                characterSelectorSceneTemp?.scaleMode = .aspectFit
                self.scene?.view?.presentScene(characterSelectorSceneTemp!, transition: SKTransition.crossFade(withDuration: 1))
            }
            
         
            if nodesArray.first?.name == "labelDificulty" || nodesArray.first?.name == "buttonDificulty"
            {                       run(switchSound)
                                    switch defaults.string(forKey: "Dificulty")!
                                    {                   
                                                        case "Easy":
                                                            defaults.set("Normal", forKey: "Dificulty")
                                                            defaults.synchronize()
                                                        case "Normal":
                                                            defaults.set("Hard", forKey: "Dificulty")
                                                            defaults.synchronize()
                                                        case "Hard":
                                                            defaults.set("Imposibble", forKey: "Dificulty")
                                                            defaults.synchronize()
                                                        case "Imposibble":
                                                            defaults.set("Easy", forKey: "Dificulty")
                                                            defaults.synchronize()
                                                        
                                                        default:
                                                            break
                                    }
                
                                    setLabels()
                    }
            

            
        }
        
    }
    
    func setLabels()
    {
        let temp = defaults.string(forKey: "Dificulty")!
        switch temp
        {
        case "Easy":
            labelDificulty?.text = "Facil"
            labelImposible.isHidden = true
        case "Normal":
            labelDificulty?.text = "Normal"
            labelImposible.isHidden = true
        case "Hard":
            labelDificulty?.text = "Dificil"
            labelImposible.isHidden = true
        case "Imposibble":
            labelDificulty?.text = "Imposible"
            labelImposible.isHidden = false
            
        default:
            break
        }
    }
    
    func setTextureCharacterSelected()
    {
        var TemporalTexture:SKTexture!
    
        switch defaults.string(forKey: "Character")! {
        case "Macri":
            TemporalTexture = SKTexture(imageNamed: "macri2Full.png")
            buttonCharacterSelected.texture = TemporalTexture
        case "Cristina":
            TemporalTexture = SKTexture(imageNamed: "cristi2Full.png")
            buttonCharacterSelected.texture =  TemporalTexture
        case "Nestor":
            TemporalTexture = SKTexture(imageNamed: "nestorFull.png")
            buttonCharacterSelected.texture = TemporalTexture
        default:
            break
        }
    }
    
        func animateCharacterSelector()
        {
            let textura1 = SKTexture(imageNamed:"CharacterSelectorImage1.png")
            let textura2 = SKTexture(imageNamed: "CharacterSelectorImage2.png")
            animacion = SKAction.animate(with:[textura1,textura2],timePerFrame: 0.8)
            let animacionInfinita = SKAction.repeatForever(animacion)
            Selector = SKSpriteNode(texture: textura1)
            Selector.run(animacionInfinita)
            Selector.position = CGPoint(x: 589.886, y: 379.546)
            Selector.zPosition = -1
            self.addChild(Selector)
        
        
    }
    
 
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
