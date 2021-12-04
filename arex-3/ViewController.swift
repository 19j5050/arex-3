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
    
    var dancer: Dancer? = nil
    var instrument: Instrument? = nil
    var trickPhoto: TrickPhoto? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面がタップされたことを検知
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapCallback(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
//        initSalamuriPlayer()
//        initPanduriPlayer()
        
        //ラベルのテキストを変更
//        label.text="მოგესალმებით"
        label.text="ようこそ"
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
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) {
            configuration.trackingImages = trackedImages
        }
        sceneView.session.run(configuration)
    }
    
    @objc private func tapCallback(_ sender: UITapGestureRecognizer) {
        //タップした時にタップした座標を取得する
        let touchPoint = sender.location(in: self.sceneView)
        let results = self.sceneView.hitTest(touchPoint, options: [SCNHitTestOption.searchMode : SCNHitTestSearchMode.all.rawValue])
        //タップされたノードを検出
        if let result = results.last {
            guard let hitNodeName2 = result.node.name else { return }
            
            print(hitNodeName2)
            
            switch hitNodeName2 {
            case "obj_0_マテリアル":
                guard let instrument = instrument else {
                    return
                }
                label1.text="サラムリ"
                if (instrument.isPlay) {
                    instrument.pause()
                    label1.text="楽器をタップ"
//                    instrument.swichChara()
                }else {
                    instrument.play()
                }
            case "obj_0_color_15277357":
                guard let instrument = instrument else {
                    return
                }
                label1.text="パンドゥリ"
                if (instrument.isPlay) {
                    instrument.pause()
                    label1.text="楽器をタップ"
                }else {
                    instrument.play()
                }
            case "Cube":
                guard let dancer = dancer else {
                    return
                }
                if (dancer.danced) {
                    dancer.end()
                } else {
                    dancer.start()
                }
            default:
                return
            }
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let configuration = ARImageTrackingConfiguration()
//
//        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) {
//            configuration.trackingImages = trackedImages
//        }
//        sceneView.session.run(configuration)
//    }
    
    // マーカーが検出されたとき呼ばれる
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if(anchor.name == "MusicTicket_Panduri") {
            instrument = Instrument(
                sceneName: "art.scnassets/panduri.scn",
                nodeName: "obj_0_color_15277357",
                parent: node,
                audioName: "stringed instrument",
                delegate: self
            )
        }
        
        if(anchor.name == "MusicTicket_Salamuri") {
            instrument = Instrument(
                sceneName: "art.scnassets/saramuri.scn",
                nodeName: "obj_0_マテリアル",
                parent: node,
                audioName: "stringed instrument2",
                delegate: self
            )
        }
        
        if(anchor.name == "MusicTicket_Doli") {
            dancer = Dancer(musicPath: "stringed instrument3", parent: node)
        }
        if(anchor.name == "MusicTicket_chonguri") {
            trickPhoto = TrickPhoto(movieName: "jojiaMovie", node: node, for: anchor)
//            guard let imageAnchor = anchor as? ARImageAnchor,
//                        let fileUrlString = Bundle.main.path(forResource: "jojiaMovie", ofType: "mp4")
//            else {
//                            return
//            }
//            let videoItem = AVPlayerItem(url: URL(fileURLWithPath: fileUrlString))
//            let player = AVPlayer(playerItem: videoItem)
//            player.play()
//
//            let size = CGSize(width: 480, height: 360)
//            let videoScene = SKScene(size: size)
//
//            let videoNode = SKVideoNode(avPlayer: player)
//            videoNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
//            videoNode.yScale = -1.0
//
//            videoScene.addChild(videoNode)
//
//            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
//                                    height: imageAnchor.referenceImage.physicalSize.height)
//            plane.firstMaterial?.diffuse.contents = videoScene
//            let planeNode = SCNNode(geometry: plane)
//            planeNode.eulerAngles.x = -Float.pi / 2
//            node.addChildNode(planeNode)
        }
    }
    
}
