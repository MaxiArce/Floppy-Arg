import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds



class GameViewController: UIViewController {
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            
            if let scene = HomeScene(fileNamed: "HomeScene") {
                // Set the scale mode to scale to fit the window
//                scene.size.height = scene.frame.size.height - bannerView.frame.size.height
//                scene.size.width = scene.frame.size.width - bannerView.frame.size.width
                scene.scaleMode = .aspectFit
            
                
                // Present the scene
                view.presentScene(scene)
                
               
                
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func showHome()
    {
        
        self.view!.window!.rootViewController!.performSegue(withIdentifier: "gameToHome", sender: self)
    }
    
  
    
}
