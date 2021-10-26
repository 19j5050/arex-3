import UIKit
import SceneKit
import ARKit
import AVFoundation


class ViewController: UIViewController, ARSCNViewDelegate, AVAudioPlayerDelegate, UIGestureRecognizerDelegate {
    
    var panduliPlayer: AVAudioPlayer!
    var salamuriPlayer: AVAudioPlayer!
    
    @IBOutlet var button:UIButton!
    @IBOutlet var sceneView: ARSCNView!//スマホ画面操作
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label1: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面がタップされたことを検知
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapCallback(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        initSalamuriPlayer()
        initPanduriPlayer()
        
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
    
    /// サラムリの音声を初期化するメソッド
    func initSalamuriPlayer() {
        // 再生する audio ファイルのパスを取得
        let audioPath2 = Bundle.main.path(forResource: "jojia2", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath2)
        
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            salamuriPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            salamuriPlayer = nil
        }
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        
        salamuriPlayer.delegate = self
        salamuriPlayer.prepareToPlay()
    }
    
    /// パンドゥリの音声を初期化するメソッド
    func initPanduriPlayer() {
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: "jojia", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            panduliPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            panduliPlayer = nil
        }
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        panduliPlayer.delegate = self
        panduliPlayer.prepareToPlay()
    }
    
    @objc private func tapCallback(_ sender: UITapGestureRecognizer) {
        //タップした時にタップした座標を取得する
        let touchPoint = sender.location(in: self.sceneView)
        let results = self.sceneView.hitTest(touchPoint, options: [SCNHitTestOption.searchMode : SCNHitTestSearchMode.all.rawValue])
        //タップされたノードを検出
        if let result = results.last {
            guard let hitNodeName2 = result.node.name else { return }
            guard let targetNode = result.node.parent else { return }
            
            switch hitNodeName2 {
            case "obj_0_マテリアル":
                self.playSalamuri(targetNode: targetNode)
            case "obj_0_color_15277357":
                self.playPanduri(targetNode: targetNode)
            default:
                return
            }
        }
    }
    
    /// パンドゥリを再生するメソッド
    /// もし、サラムリが再生されていたら止める
    func playPanduri(targetNode: SCNNode) {
        print("*** playPanduri() ***")
        label1.text = "ალელუია იავნანა"
        label1.font = UIFont.systemFont(ofSize: 36)
        
        let actMove = SCNAction.move(by: SCNVector3(0, 0, 0.1), duration: 0.2)
        targetNode.runAction(actMove)
        
        // *** サラムリを止める ***
        if salamuriPlayer.isPlaying {
            salamuriPlayer.stop()
        }
        
        //音楽再生停止
        if ( panduliPlayer.isPlaying ){
            panduliPlayer.stop()
            label1.text="楽器をタップ"
            
            //button.setTitle("Stop", for: UIControl.State())
        } else{
            panduliPlayer.play()
            //button.setTitle("Play", for: UIControl.State())
        }
    }
    
    /// サラムリを再生するメソッド
    /// もし、パンドゥリが再生されていたら止める
    func playSalamuri(targetNode: SCNNode) {
        print("*** playSaramuri() ***")
        label1.text = "ალელუია იავნანა"
        label1.font = UIFont.systemFont(ofSize: 36)
        
        let actMove2 = SCNAction.move(by: SCNVector3(0, 0, 0.1), duration: 0.2)
        targetNode.runAction(actMove2)
        
        // *** パンドゥリを止める ***
        if panduliPlayer.isPlaying {
            panduliPlayer.stop()
        }
        
        //音楽再生停止
        if ( salamuriPlayer.isPlaying ){
            print("audioPlayer.isPlaying")
            salamuriPlayer.stop()
            label1.text="楽器をタップ"
            //button.setTitle("Stop", for: UIControl.State())
        } else{
            print("!audioPlayer.isPlaying")
            salamuriPlayer.play()
            //doli.runAction(SCNAction .repeatForever(SCNAction .rotateBy(x: 0, y: 0.1, z: 0, duration: 1)))
            //button.setTitle("Play", for: UIControl.State())
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
