//
//  Instrument.swift
//  arex-3
//
//  Created by 兼松 美羽 on 2021/12/02.
//
import UIKit
import Foundation
import SceneKit
import AVFoundation

class Instrument {
    var player: AVAudioPlayer!
    var isPlay: Bool = false
    var modelNode: SCNNode!
    
    @IBOutlet weak var label1: UILabel!

    init (sceneName: String, nodeName: String, parent: SCNNode, audioName: String, delegate: AVAudioPlayerDelegate) {
        // scnファイルからシーンを読み込む
        let scene = SCNScene(named: sceneName)
        // シーンからノードを検索
        modelNode = (scene?.rootNode.childNode(withName: nodeName, recursively: false))!
        // 検出面の子要素にする
        modelNode.position = SCNVector3(0, 0, 0)
        parent.addChildNode(modelNode)
        
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: audioName, ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            player = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            player = nil
        }
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        player.delegate = delegate
        player.prepareToPlay()
    }
    
    func play() {
        player.play()
        isPlay = true
        //モデルが回り続ける
        let rotate = SCNAction.rotateBy(x: 0, y: 1.28, z: 0, duration: 1)
        modelNode.runAction(SCNAction.repeatForever(rotate), forKey: "rotate")
    }
    
    func pause() {
        player.stop()
        isPlay = false
        modelNode.removeAction(forKey: "rotate")
    }
}
