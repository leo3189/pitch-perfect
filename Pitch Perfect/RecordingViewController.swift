//
//  RecordingViewController.swift
//  Pitch Perfect
//
//  Created by leonard on 2/7/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordTextLbl: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var buttonSwitched: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Perfect Pitch"
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        
        buttonSwitched = !buttonSwitched

        if buttonSwitched {
            recordTextLbl.text = "Tap to finish recording"
            recordButton.setImage(UIImage(named: "Stop.png"), for: .normal)

            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))

            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default)
            try! session.setActive(true, options: .notifyOthersOnDeactivation)
            
            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()

        } else {
            recordTextLbl.text = "Tap to start recording"
            recordButton.setImage(UIImage(named: "Record.png"), for: .normal)
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "showPlaySoundsVC", sender: audioRecorder.url)
        } else {
            print("Recoding was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlaySoundsVC" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordAudioURL
        }
    }
    

}
