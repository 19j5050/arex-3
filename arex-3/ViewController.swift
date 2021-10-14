import UIKit
import SceneKit
import ARKit
import AVFoundation


//extension SCNNode {
//    // var rotating = true
//    private struct additional {
//        static var rotating: Bool = true
//    }
//
//    var rotating: Bool {
//        get {
//            guard let isRotate = objc_getAssociatedObject(self, &additional.rotating) as? Bool else {
//                return false
//            }
//            return isRotate
//        }
//        set {
//            objc_setAssociatedObject(self, &additional.rotating, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//
//    func rotate(){
//        let rotate = SCNAction.rotateBy(x: 0, y: self.deg2rad(360.0), z: 0, duration: 10)
//        self.runAction(SCNAction.repeatForever(rotate))
//
//        if (rotating) {
//            let rotate = SCNAction.rotateBy(x: 0, y: self.deg2rad(360.0), z: 0, duration: 10)
//            self.runAction(SCNAction.repeatForever(rotate))
//            rotating = true
//        } else {
//            self.removeAllActions()
//            rotating = false
//        }
//    }
//
//    func deg2rad(_ number: CGFloat) -> CGFloat {
//        return number * .pi / 180
//    }
//}

class ViewController: UIViewController, ARSCNViewDelegate, AVAudioPlayerDelegate, UIGestureRecognizerDelegate {
    
    var audioPlayer:AVAudioPlayer!
    
    @IBOutlet var button:UIButton!
    @IBOutlet var sceneView: ARSCNView!//スマホ画面操作
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label1: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面がタップされたことを検知

        
        let saramuriTap = UITapGestureRecognizer(target: self, action: #selector(tap2(_:)))
        saramuriTap.delegate = self
        sceneView.addGestureRecognizer(saramuriTap)
        
        let panduriTap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        panduriTap.delegate = self
        sceneView.addGestureRecognizer(panduriTap)
        
        //ラベルのテキストを変更
        label.text="მოგესალმებით"
        label1.text="楽器をタップ"
        // UILabelの文字列から、attributedStringを作成
        let attrText = NSMutableAttributedString(string: label.text!)
        //NSAttributedStringを使う時は、文字の一部の色やフォントを変更したり、異なるフォントや色の文字を混ぜたい時
        // フォントカラーを設定
        label.textColor = UIColor.blue
        label1.textColor = UIColor.blue
        // attributedTextとしてUILabelに追加します.
        label.attributedText = attrText
        // システムフォントをサイズ36に設定
        label.font = UIFont.systemFont(ofSize: 36)
        label1.font = UIFont.systemFont(ofSize: 36)
        
        // デリゲートを設定
        sceneView.delegate = self
        // シーンを作成して登録
        sceneView.scene = SCNScene()
        // ライトの追加
        sceneView.autoenablesDefaultLighting = true;
        //sceneView内に表示するNodeに無指向性の光を追加するオプションです。
        // 画像認識の参照用画像をアセットから取得
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
        sceneView.session.run(configuration)
    }
    
    
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        //タップした時にタップした座標を取得する
        let touchPoint = sender.location(in: self.sceneView)
        let results = self.sceneView.hitTest(touchPoint, options: [SCNHitTestOption.searchMode : SCNHitTestSearchMode.all.rawValue])
        //タップされたノードを検知
        if let result = results.first {
            guard let hitNodeName = result.node.name else { return }
            guard hitNodeName == "obj_0_color_15277357" else { return }
            
//            var  angle: CGFloat = 180.0
//             angle += 1.0
            
            if let panduri = result.node.parent {
                //ラベルのテキストを変更
                label1.text = "ალელუია იავნანა"
                label1.font = UIFont.systemFont(ofSize: 36)
                
                let actMove = SCNAction.move(by: SCNVector3(0, 0, 0.1), duration: 0.2)
                panduri.runAction(actMove)
                
                //音楽再生停止
                if ( audioPlayer.isPlaying ){
                    audioPlayer.stop()
                    label1.text="楽器をタップ"
                    
                    //button.setTitle("Stop", for: UIControl.State())
                }
                else{
                    audioPlayer.play()
                    //button.setTitle("Play", for: UIControl.State())
                }
            }
        }
    }
//        if let result = results.first {
//            guard let hitNodeName = result.node.name else { return }
//            guard hitNodeName == "obj_0_マテリアル" else { return }
//
////            var  angle: CGFloat = 180.0
////             angle += 1.0
//
//            if let saramuri = result.node.parent {
//                //ラベルのテキストを変更
//                label1.text = "ალელუია იავნანა"
//                label1.font = UIFont.systemFont(ofSize: 36)
//
//                let actMove = SCNAction.move(by: SCNVector3(0, 0, 0.1), duration: 0.2)
//                saramuri.runAction(actMove)
//
//                //音楽再生停止
//                if ( audioPlayer.isPlaying ){
//                    audioPlayer.stop()
//                    label1.text="楽器をタップ"
//
//                    //button.setTitle("Stop", for: UIControl.State())
//                }
//                else{
//                    audioPlayer.play()
//                    //button.setTitle("Play", for: UIControl.State())
//                }
//            }
//        }
//    }
    
    @objc private func tap2(_ sender: UITapGestureRecognizer) {
        //タップした時にタップした座標を取得する
        let touchPoint2 = sender.location(in: self.sceneView)
        let results2 = self.sceneView.hitTest(touchPoint2, options: [SCNHitTestOption.searchMode : SCNHitTestSearchMode.all.rawValue])
        //タップされたノードを検出
        if let result2 = results2.last {
            guard let hitNodeName2 = result2.node.name else { return }
            guard hitNodeName2 == "obj_0_マテリアル" else { return }
            
            if let saramuri = result2.node.parent {
                //ラベルのテキストを変更
                label1.text = "ალელუია იავნანა"
                label1.font = UIFont.systemFont(ofSize: 36)
                
                let actMove2 = SCNAction.move(by: SCNVector3(0, 0, 0.1), duration: 0.2)
                saramuri.runAction(actMove2)
                
                //音楽再生停止
                if ( audioPlayer.isPlaying ){
                    audioPlayer.stop()
                    label1.text="楽器をタップ"
                    //button.setTitle("Stop", for: UIControl.State())
                }
                else{
                    audioPlayer.play()
                    //doli.runAction(SCNAction .repeatForever(SCNAction .rotateBy(x: 0, y: 0.1, z: 0, duration: 1)))
                    //button.setTitle("Play", for: UIControl.State())
                }
            }
        }
    }
    
    
    // マーカーが検出されたとき呼ばれる
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if(anchor.name == "MusicTicket_Panduri") {
            // scnファイルからシーンを読み込む
            let scene = SCNScene(named: "art.scnassets/panduri.scn")
            // シーンからノードを検索
            let modelNode = (scene?.rootNode.childNode(withName: "obj_0_color_15277357", recursively: false))!
            //モデルが回り続ける
            let rotate = SCNAction.rotateBy(x: 0, y: 1.28, z: 0, duration: 1)
            modelNode.runAction(SCNAction.repeatForever(rotate))
            // 検出面の子要素にする
            modelNode.position = SCNVector3(0, 0, 0)
            node.addChildNode(modelNode)
                    
            // 再生する audio ファイルのパスを取得
            let audioPath = Bundle.main.path(forResource: "y2mate.com -  ირაკლი ახალაია Irakli Akhalaia  Fanduri ფანდური", ofType:"mp3")!
            let audioUrl = URL(fileURLWithPath: audioPath)
            // auido を再生するプレイヤーを作成する
            var audioError:NSError?
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            } catch let error as NSError {
                audioError = error
                audioPlayer = nil
            }
            // エラーが起きたとき
            if let error = audioError {
                print("Error \(error.localizedDescription)")
            }
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
        
        if(anchor.name == "MusicTicket_Salamuri") {
            // scnファイルからシーンを読み込む
            let scene = SCNScene(named: "art.scnassets/saramuri.scn")
            // シーンからノードを検索
            let modelNode2 = (scene?.rootNode.childNode(withName: "obj_0_マテリアル", recursively: false))!
            //モデルが回り続ける
            let rotate = SCNAction.rotateBy(x: 0, y: 1.28, z: 0, duration: 1)
            modelNode2.runAction(SCNAction.repeatForever(rotate))
            // 検出面の子要素にする
            modelNode2.position = SCNVector3(0, 0, 0)
            node.addChildNode(modelNode2)
            
            // 再生する audio ファイルのパスを取得
            let audioPath2 = Bundle.main.path(forResource: "y2mate.com - ალელუია იავნანა  Hallelujah Lullaby  ნატო კახიძე ეკა მამალაძე ვახტანგ კახიძე", ofType:"mp3")!
            let audioUrl = URL(fileURLWithPath: audioPath2)
            
            // auido を再生するプレイヤーを作成する
            var audioError:NSError?
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            } catch let error as NSError {
                audioError = error
                audioPlayer = nil
            }
            // エラーが起きたとき
            if let error = audioError {
                print("Error \(error.localizedDescription)")
            }
            
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
    
    // ボタンがタップされた時の処理
    /*@IBAction func buttonTapped(_ sender : Any) {
     if ( audioPlayer.isPlaying ){
     audioPlayer.stop()
     button.setTitle("Stop", for: UIControl.State())
     }
     else{
     audioPlayer.play()
     button.setTitle("Play", for: UIControl.State())
     }
     }*/
    
//    func deg2rad(_ number: CGFloat) -> CGFloat {
//        return number * .pi / 180
//    }
    }
}
