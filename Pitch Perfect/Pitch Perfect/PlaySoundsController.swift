//
//  PlaySoundsController.swift
//  Pitch Perfect
//
//  Created by Richard Spencer on 12/24/15.
//  Copyright © 2015 Richard Spencer. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsController: UIViewController {

    var receivedAudio:RecordedAudio!
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.recordingFilePath)
        audioFile = try! AVAudioFile(forReading: receivedAudio.recordingFilePath)
        audioPlayer.enableRate = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PlaySlowAudio(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }
    
    @IBAction func PlayFastAudio(sender: UIButton) {
        playAudioWithVariableRate(2.0)
    }
    
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    
    func playAudioWithVariableRate(rate: Float) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = rate
        audioPlayer.volume = 1.0
        audioPlayer.volume = 1.0

        audioPlayer.play()
    }
    //TODO:  In playChipmunkAudio
    //playAudioWithVariablePitch(1000)
    
    //New Function
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }

}
