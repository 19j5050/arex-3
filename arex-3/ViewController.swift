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
        
        let captureBtn = UIButton(
                    frame: CGRect(x: 0, y: 50, width: 50, height: 50)
                )
                captureBtn.backgroundColor = UIColor(
                    red: 0.1, green: 0.7, blue: 1.0, alpha: 1.0
                )
        //        captureBtn.setTitle("capture", for: .normal)
                captureBtn.addTarget(
                    self,
                    action: #selector(capture),
                    for: .touchUpInside
                )

        //        self.view.backgroundColor = UIColor(
        //            red: 0.1, green: 1.0, blue: 0.7, alpha: 1.0
        //        )
                self.view.addSubview(captureBtn)
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
        }
    }
    
    @objc func capture( sender : Any) {
            print("capture")

            let rect = self.view.bounds

            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
            let context: CGContext = UIGraphicsGetCurrentContext()!
            self.view.layer.render(in: context)
            let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            UIImageWriteToSavedPhotosAlbum(
                capturedImage, self, #selector(saveError), nil
            )
    }

    @objc func saveError( image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            print("Save finished!")
    }
    
}
