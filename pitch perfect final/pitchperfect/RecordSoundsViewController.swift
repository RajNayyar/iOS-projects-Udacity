//
//  RecordSoundsViewController.swift
//  pitchperfect
//
//  Created by Rajpreet on 06/12/17.
//  Copyright © 2017 Rajpreet. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder:AVAudioRecorder!
    @IBOutlet weak var recordinglabel: UITextField!
    @IBOutlet weak var recordbutton: UIButton!
    @IBOutlet weak var stopbutton: UIButton!
    
    override func viewDidLoad() {
         
        super.viewDidLoad()
            }
    override func viewWillAppear(_ animated: Bool) {
     
        print("view will appear")
    }
    override func viewDidAppear(_ animated: Bool) {
      stopbutton.isEnabled=false
        print("view did appear")
        stopbutton.imageView?.contentMode = .scaleAspectFit
        recordbutton.imageView?.contentMode = .scaleAspectFit
        recordinglabel?.textAlignment = NSTextAlignment.center

    }


    @IBAction func RecordButton(_ sender: Any) {
    print("Record Button was pressed!")
        recordinglabel.text="Recording in Progress"
        recordinglabel?.textAlignment = NSTextAlignment.center

       stopbutton.isEnabled=true
        recordbutton.isEnabled=false
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
   
    @IBAction func StopButton(_ sender: Any) {
        print("Stop button was pressed")
        recordinglabel.text="Tap to Record"
        stopbutton.isEnabled=false
        recordbutton.isEnabled=true
        audioRecorder.stop()
        let audioSession=AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if  flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url )
        }
        else
        {
            print("Recording was not succesful ")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="stopRecording"{
            let playSoundsVC=segue.destination as! PlaySoundsViewController
            let recordedAudioURL=sender as! URL
            playSoundsVC.recordedAudioURL=recordedAudioURL
        }
    }
}
