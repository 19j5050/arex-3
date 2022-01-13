
import Foundation
import AVFoundation
import SceneKit


class Dancer {
    // ダンサーが表示される親のノード
    var parent: SCNNode
    // アニメーションの配列
    var animations = [String: CAAnimation]()
    // 音楽プレイヤー
    var musicPlayer: AVAudioPlayer!
    // 踊っているかの状態
    var danced: Bool = false
    
    init(musicPath: String, parent: SCNNode) {
        let audioPath = Bundle.main.path(forResource: musicPath, ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            let audioError: NSError = error
            print(audioError)
            musicPlayer = nil
        }
        
        // Load the character in the idle animation
        let idleScene = SCNScene(named: "art.scnassets/animation/idleFixed.dae")!
        // This node will be parent of all the animation models
        let node = SCNNode()
        // Add all the child nodes to the parent node
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        self.parent = parent
        self.loadAnimations()
        self.idel()
    }
    
    /// 踊り始めて、音楽を再生する
    public func start() {
        musicPlayer.play()
        self.dancing()
    }
    
    /// 踊りを止めて、音楽を停止する
    public func end() {
        musicPlayer.stop()
        self.idel()
    }
    
    private func dancing() {
        parent.addAnimation(animations["dancing"]!, forKey: "dancing")
        danced = true
    }
    
    private func idel() {
        parent.addAnimation(animations["idle"]!, forKey: "idle")
        danced = false
    }
    
    private func loadAnimations () {
        // Load the character in the idle animation
        let idleScene = SCNScene(named: "art.scnassets/animation/idleFixed.dae")!
        // This node will be parent of all the animation models
        let node = SCNNode()
        // Add all the child nodes to the parent node
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        // Set up some properties
        node.position = SCNVector3(0, 0, 0)
//        node.rotation = SCNVector4(1, 0, 0, -0.3 * Double.pi)
        node.scale = SCNVector3(0.015, 0.015, 0.015)
        
        // Add the node to the scene
        parent.addChildNode(node)
       
        // Load all the DAE animations
        self.loadAnimation(withKey: "idle", sceneName: "art.scnassets/animation/idleFixed", animationIdentifier: "idleFixed-1")
        self.loadAnimation(withKey: "dancing", sceneName: "art.scnassets/animation/DancingFixed", animationIdentifier: "DancingFixed-1")
    }
    
    /// アニメーションをanimatuons配列に追加する
    private func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
            // The animation will only play once
            animationObject.repeatCount = .infinity
            // To create smooth transitions between animations
            animationObject.fadeInDuration = CGFloat(1)
            animationObject.fadeOutDuration = CGFloat(0.5)
            
            // Store the animation for later use
            self.animations[withKey] = animationObject
        }
    }
}
