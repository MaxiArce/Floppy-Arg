import SpriteKit
import GameplayKit
import AVFoundation
import GoogleMobileAds

class GameScene: SKScene, SKPhysicsContactDelegate {
    var character:String!
    var dificulty:String!
    var tiempoTubos:TimeInterval = 0
    var distanciaTubos:CGFloat = 0
    var labelFinalPoints = SKLabelNode()
    var car = SKSpriteNode()
    var carTexture = SKTexture()
    var mosca = SKSpriteNode()
    var fondo = SKSpriteNode()
    var tubo1 = SKSpriteNode()
    var tubo2 = SKSpriteNode()
    var restartButton = SKSpriteNode()
    var exitButton = SKSpriteNode()
    var texturaTubo1 = SKTexture()
    var texturaTubo2 = SKTexture()
    var animacion = SKAction()
    var firstTouch = true
    var gameOver = false
    var timer = Timer()
    var labelPoint = SKLabelNode()
    var points = 0
    var boton = UIButton()
    var texturaMosca1 = SKTexture()
    let defaults = UserDefaults.standard
    public let restartButtonTexture = SKTexture(imageNamed: "restartButton.png")
    public let exitButtonTexture = SKTexture(imageNamed: "exitButton.png")
  
    
    //Ads
    var bannerView: GADBannerView!
    
    enum tipoNodo: UInt32 {
        
        
        case mosca = 1
        
        case tubo = 2
        
        case suelo = 3
        
        case espacioTubos = 4
        
        
    }
    
    
    override func didMove(to view: SKView) {
        
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = "ca-app-pub-4193735999860272/7418086140"
        bannerView.rootViewController = self.view?.window?.rootViewController
        let request:GADRequest = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        bannerView.load(request)
        bannerView.frame = CGRectMake(0, view.bounds.height - bannerView.frame.size.height, bannerView.frame.size.width, bannerView.frame.size.height)
        self.view?.addSubview(bannerView)
        bannerView.isHidden = false
        
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -25)
        setDificulty()
        restartGame()
        
        
        
    }
    

    func restartGame()
    {
        
        self.isUserInteractionEnabled = true
        //LABEL PUNTUACION
        
        addLabelPoint()
        
        //MOSCA
        
        añadirMosca()
        addStartImage()
        
        //FONDO
        añadirFondo()
        
        //Suelo
        
        añadirSuelo()
        
        addButtons()
        
        
    }
    
    
    func addButtons()
    {
        restartButton = SKSpriteNode(texture: restartButtonTexture, size: restartButtonTexture.size())
        restartButton.position = CGPoint(x: 0 , y: -200)
        restartButton.zPosition = -5
        restartButton.name = "rst"
        restartButton.isHidden = true
        
        exitButton = SKSpriteNode(texture: exitButtonTexture , size: exitButtonTexture.size())
        exitButton.position = CGPoint(x: 224, y: 470)
        exitButton.zPosition = -5
        exitButton.name = "exit"
        exitButton.isHidden = true
        
        
        self.addChild(exitButton)
        self.addChild(restartButton)
    }
    
    func addLabelPoint()
    {
        labelPoint.fontName = ("Raleway-Light")
        labelPoint.fontSize = 60
        labelPoint.text = "0"
        labelPoint.position  = CGPoint(x: 0, y: 600)
        labelPoint.zPosition = 5
        
        labelFinalPoints.fontName = ("Raleway-Light")
        labelFinalPoints.fontSize = 150
        labelFinalPoints.text = ""
        labelFinalPoints.position  = CGPoint(x: 0, y: 300)
        labelFinalPoints.zPosition = 2
        labelFinalPoints.isHidden = true
        
        self.addChild(labelPoint)
        self.addChild(labelFinalPoints)
    }
    
    
    func addStartImage()
    {
        switch character {
        case "Nestor":
            carTexture = SKTexture(imageNamed: "cajon.png")
        default:
            carTexture = SKTexture(imageNamed: "car.png")
        }
        car = SKSpriteNode(texture: carTexture)
        car.position = CGPoint(x:self.frame.midX , y:self.frame.midY - 500)
        car.zPosition = 2
        self.addChild(car)
    }
    
    func añadirMosca(){
        
        switch(character)
       {
        case "Macri":
        texturaMosca1 = SKTexture(imageNamed:"fly1.png")
        let texturaMosca2 = SKTexture(imageNamed:"fly2.png")
        animacion = SKAction.animate(with:[texturaMosca1,texturaMosca2],timePerFrame: 0.1)
            
        case "Cristina":
            texturaMosca1 = SKTexture(imageNamed:"cristi1.png")
            let texturaMosca2 = SKTexture(imageNamed:"cristi2.png")
            let texturaMosca3 = SKTexture(imageNamed: "cristi3.png")
            animacion = SKAction.animate(with:[texturaMosca1,texturaMosca2,texturaMosca3],timePerFrame: 0.1)
        case "Nestor":
            texturaMosca1 = SKTexture(imageNamed: "nestor1.png")
            let texturaMosca2 = SKTexture(imageNamed: "nestor2.png")
            let texturaMosca3 = SKTexture(imageNamed: "nestor3.png")
            animacion = SKAction.animate(with:[texturaMosca1,texturaMosca2,texturaMosca3],timePerFrame: 0.1)
            
        default:
            break
        }
        
        
        let animacionInfinita = SKAction.repeatForever(animacion)
        
        mosca = SKSpriteNode(texture:texturaMosca1)
        
        mosca.position = CGPoint(x:self.frame.midX , y:self.frame.midY - 480 )
        
        mosca.physicsBody = SKPhysicsBody(circleOfRadius:texturaMosca1.size().height/2)
        mosca.physicsBody!.isDynamic = false
        mosca.physicsBody!.categoryBitMask = tipoNodo.mosca.rawValue
        mosca.physicsBody!.collisionBitMask = tipoNodo.tubo.rawValue
        mosca.physicsBody!.contactTestBitMask = tipoNodo.tubo.rawValue | tipoNodo.espacioTubos.rawValue
        mosca.run(animacionInfinita)
        
        mosca.zPosition = 1
        
        self.addChild(mosca)
        
        mosca.isHidden = true
        
    }
    
        
    func añadirFondo()
    {
        
        let texturaFondo = SKTexture(imageNamed:"fondo.png")
        
        let movimientoFondo = SKAction.move(by: CGVector(dx: -texturaFondo.size().width, dy:0), duration:4)
        
        let movimientoFondoOrigen = SKAction.move(by: CGVector(dx: texturaFondo.size().width, dy:0), duration:0)
        
        let movimientoInfinitoFondo = SKAction.repeatForever(SKAction.sequence([movimientoFondo,movimientoFondoOrigen]))
        
        
        var i:CGFloat = 0
        
        while i < 2  {
            
            
            fondo = SKSpriteNode(texture:texturaFondo)

            
            fondo.position = CGPoint(x:texturaFondo.size().width * i, y: self.frame.midY + bannerView.frame.size.height )
            fondo.size.height = self.frame.height - 50
            fondo.zPosition = -1
            fondo.run(movimientoInfinitoFondo)
            i += 1
            self.addChild(fondo)
        }
        
    }
    
    func añadirSuelo(){
        
        let suelo = SKNode()
        let techo = SKNode()
        
        suelo.position = CGPoint(x:-self.frame.midX, y:(-self.frame.height/2) + bannerView.frame.size.height * 2 )
        techo.position = CGPoint(x:-self.frame.midX, y:(self.frame.height/2))
        
        suelo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:self.frame.width, height:1))
        techo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        suelo.physicsBody!.isDynamic = false
        techo.physicsBody!.isDynamic = false
        
        suelo.physicsBody?.categoryBitMask = tipoNodo.suelo.rawValue
        suelo.physicsBody!.collisionBitMask = tipoNodo.mosca.rawValue
        suelo.physicsBody!.contactTestBitMask = tipoNodo.mosca.rawValue
        techo.physicsBody?.categoryBitMask = tipoNodo.suelo.rawValue
        techo.physicsBody!.collisionBitMask = tipoNodo.mosca.rawValue
        techo.physicsBody!.contactTestBitMask = tipoNodo.mosca.rawValue
        
        self.addChild(suelo)
        self.addChild(techo)
    }
    
    func setDificulty()
    {
        switch dificulty {
        case "Easy":
            distanciaTubos = 1.7
            tiempoTubos = 3.5
        case "Normal":
            distanciaTubos = 1.5
            tiempoTubos = 2.8
        case "Hard":
            distanciaTubos = 1.2
            tiempoTubos = 1.8
        case "Imposibble":
            distanciaTubos = 0.5
            tiempoTubos = 0.8
        default:
            break
        }
    }
    
    @objc func añadirTubosAndEspacios(){
        
        setTexturaTubos()
        
        let moverTubos = SKAction.move(by: CGVector(dx: -3 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 80))
        
        let removerTubos = SKAction.removeFromParent()
        
        let moverRemoverTubos = SKAction.sequence([moverTubos,removerTubos])
        
        let gapDificultad = mosca.size.height * distanciaTubos
        //print(gapDificultad)
        // Numero entre cero y la mitad del alto de la pantalla
        let cantidadMovimientoAleatorio = CGFloat(arc4random() % UInt32(self.frame.height/2))
        
        let compensacionTubos =  cantidadMovimientoAleatorio - self.frame.height / 4
        
        
        
        tubo1 = SKSpriteNode(texture:texturaTubo1)
        tubo1.position = CGPoint(x:self.frame.midX + self.frame.width, y:self.frame.midY + texturaTubo1.size().height / 2 + gapDificultad + compensacionTubos)
        tubo1.zPosition = 0
        
        tubo1.physicsBody = SKPhysicsBody(texture: texturaTubo1, size: tubo1.texture!.size())
        tubo1.physicsBody!.isDynamic = false
        tubo1.physicsBody!.categoryBitMask = tipoNodo.tubo.rawValue
        tubo1.physicsBody!.collisionBitMask = tipoNodo.mosca.rawValue
        tubo1.physicsBody!.contactTestBitMask = tipoNodo.mosca.rawValue
        tubo1.run(moverRemoverTubos)
        
        self.addChild(tubo1)
        
        
        tubo2 = SKSpriteNode(texture:texturaTubo2)
        tubo2.position = CGPoint(x:self.frame.midX + self.frame.width, y:self.frame.midY - texturaTubo2.size().height / 2 - gapDificultad + compensacionTubos)
        tubo2.zPosition = 0
        
        
        tubo2.physicsBody = SKPhysicsBody(texture: texturaTubo2, size: tubo2.texture!.size())
        tubo2.physicsBody!.isDynamic = false
        tubo2.physicsBody!.categoryBitMask = tipoNodo.tubo.rawValue
        tubo2.physicsBody!.collisionBitMask = tipoNodo.mosca.rawValue
        tubo2.physicsBody!.contactTestBitMask = tipoNodo.mosca.rawValue
        tubo2.run(moverRemoverTubos)
        
        self.addChild(tubo2)
        
        //aca se anaden los espacios
        
        let espacio = SKSpriteNode()
        espacio.position = CGPoint(x:self.frame.midX + self.frame.width , y:self.frame.midY + compensacionTubos)
        
        espacio.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:texturaTubo1.size().width , height: self.frame.height))
        espacio.physicsBody!.isDynamic = false
        espacio.zPosition = 1
        espacio.physicsBody!.categoryBitMask = tipoNodo.espacioTubos.rawValue
        espacio.physicsBody!.collisionBitMask = 0
        espacio.physicsBody!.contactTestBitMask = tipoNodo.mosca.rawValue
        espacio.run(moverRemoverTubos)
        
        self.addChild(espacio)
        
    }
    
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if firstTouch == false
        {
            let jump = SKAction.playSoundFileNamed("Jump.wav", waitForCompletion: false)
            run(jump)
        }
        
        
        if gameOver == false
        {
           
            if firstTouch == true{
                self.isUserInteractionEnabled = true
                firstTouch = false
                mosca.isHidden = false
                car.isHidden = true
                let jump = SKAction.playSoundFileNamed("firstJump.m4a", waitForCompletion: false)
                run(jump)
                añadirTubosAndEspacios()
                timer = Timer.scheduledTimer(timeInterval: tiempoTubos, target: self, selector: #selector(self.añadirTubosAndEspacios), userInfo: nil, repeats: true)
            }
            
        self.speed = 1
            
            
        mosca.physicsBody!.isDynamic = true
        
        mosca.physicsBody!.velocity = (CGVector(dx: 0 , dy: 0) )
        
        mosca.physicsBody!.applyImpulse(CGVector(dx: 0 , dy: 180) )
        }
        else
        
        {
            let touch = touches.first!
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            let clickSound = SKAction.playSoundFileNamed("click.wav", waitForCompletion: false)
            for node in nodes
            {
                if node.name == "rst"
                {   run(clickSound)
                    gameOver = false
                    points = 0
                    self.speed = 1
                    self.removeAllChildren()
                    restartGame()
                    
                    break
                }
                if node.name == "exit"
                {
                    run(clickSound)
                    bannerView.isHidden = true
                    let gameSceneTemp = GameScene(fileNamed: "HomeScene")
                    gameSceneTemp?.scaleMode = .aspectFit
                    self.scene?.view?.presentScene(gameSceneTemp!, transition: SKTransition.doorsCloseVertical(withDuration: 0.5))
                }
            }
            
        }
        
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let cuerpoA = contact.bodyA
        let cuerpoB = contact.bodyB
        
        if (cuerpoA.categoryBitMask == tipoNodo.mosca.rawValue && cuerpoB.categoryBitMask == tipoNodo.espacioTubos.rawValue) || (cuerpoA.categoryBitMask == tipoNodo.espacioTubos.rawValue && cuerpoB.categoryBitMask == tipoNodo.mosca.rawValue)
        {
            points += 1
            labelPoint.text = String(points)
        }
            else
            {
                if(cuerpoA.categoryBitMask == tipoNodo.mosca.rawValue && cuerpoB.categoryBitMask == tipoNodo.suelo.rawValue) || (cuerpoA.categoryBitMask == tipoNodo.suelo.rawValue && cuerpoB.categoryBitMask == tipoNodo.mosca.rawValue)
                {
                
                }
                else
                {
                
                //sound crash
                let crashSound = SKAction.playSoundFileNamed("Crash.wav", waitForCompletion: false)
                run(crashSound)
                let finalPoints = String(points)
                
                    
                    if defaults.integer(forKey: "BestScore")<points
                    {
                        defaults.set(points, forKey: "BestScore")
                        defaults.synchronize()
                        print (defaults.integer(forKey: "BestScore"))
                        print("mejor puntaje")
                        
                    }
                    else{
                        
                        print("NO ES EL MEJOR PUNTAJE")
                        
                    }
                    
                gameOver = true
                self.speed = 0
                timer.invalidate()
                labelPoint.text = "GAME OVER"
                labelFinalPoints.isHidden = false
                labelFinalPoints.text = finalPoints
                firstTouch = true
                restartButton.zPosition = 5
                restartButton.isHidden = false
                exitButton.zPosition = 5
                exitButton.isHidden = false
                    
                }
                
            }
        
    }
    
    func setTexturaTubos(){
        
        switch character {
        case "Cristina":
            texturaTubo1 = SKTexture(imageNamed: "Helicoptero.png")
            texturaTubo2 = SKTexture(imageNamed:"cartelCristi.png")
        case "Macri":
            texturaTubo1 = SKTexture(imageNamed: "Helicoptero.png")
            texturaTubo2 = SKTexture(imageNamed:"MacriGato.png")
        case "Nestor":
            texturaTubo1 = SKTexture(imageNamed: "Arsat")
            texturaTubo2 = SKTexture(imageNamed:"Pinguinos.png")
            
        default:
            break
        }

    }
    
    
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}



