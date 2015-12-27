//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Richard Spencer on 12/24/15.
//  Copyright © 2015 Richard Spencer. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController , AVAudioRecorderDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.hidden = true
        pauseResumeButton.hidden = true
        recordLabel.text = startRecordingStatus
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //TODO: Find a cool way to control what the label says based on the state microphone enabled
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    let session = AVAudioSession.sharedInstance()
    let startRecordingStatus = "Tap the Microphone to Record"
    let recordingStatus = "Recording"
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    @IBAction func recordAudio(sender: UIButton) {
        sender.enabled = false
        stopButton.hidden = false
        pauseResumeButton.hidden = false
        recordLabel.text = recordingStatus
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let fileName = "recordedAudio.wav"
        let pathArray = [dirPath, fileName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func PauseResumeRecording(sender: UIButton) {
        if (audioRecorder.recording) {
            audioRecorder.pause()
            
            if let resumeImage = UIImage(named: "resumeBlue") {
                pauseResumeButton.setImage(resumeImage, forState: .Normal)
            }
            pauseResumeButton.imageView!.image = UIImage(named: "resumeBlue")
        } else {
            audioRecorder.record()
            if let resumeImage = UIImage(named: "pauseBlue") {
                pauseResumeButton.setImage(resumeImage, forState: .Normal)
            }
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            try! session.setCategory(AVAudioSessionCategoryPlayback)
            recordedAudio = RecordedAudio()
            recordedAudio.recordingFilePath = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("showPlaySoundView", sender: recordedAudio)
        } else {
            print("recording failed")
            recordButton.enabled = true
            stopButton.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPlaySoundView" {
            let playSoundController:PlaySoundsController = segue.destinationViewController as! PlaySoundsController
            let data = sender as! RecordedAudio
            playSoundController.receivedAudio = data
        }
        
    }
}
