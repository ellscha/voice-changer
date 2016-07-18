//
//  ViewController.swift
//  VoiceChanger
//
//  Created by Elli Scharlin on 7/15/16.
//  Copyright © 2016 ElliBelly. All rights reserved.
//

import UIKit
import CoreAudioKit
import AVFoundation
import AVKit


class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer:AVAudioPlayer?
    var audioEngine: AVAudioEngine!
    var sliderValue:Float = 1.0
    var timeOrPitch:String = "time"
    var counter = 0
    
    @IBOutlet weak var timeOrPitchSelector: UISegmentedControl!
    @IBOutlet weak var sliderSelector: UISlider!
    
    @IBOutlet weak var chipMunk: UIButton!
    @IBOutlet weak var darthVader: UIButton!
    @IBOutlet weak var boy: UIButton!
    @IBOutlet weak var minion: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.hidden = true
        audioEngine = AVAudioEngine()
        

        // inside viewDidLoad initialize it
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func createDirectoryLocation(){
        guard let directoryURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first else{
            
            print("WHY AM I NOT WORKING!!!")
            return
        }
        
        
        //MARK: INSERTING FROM MHORGA.ORG THE AUDIO ENGINE
        // declare the audio engine as a property
        //MARK: CHANGE THE RATE OF THE PLAYBACK
        
        audioPlayer?.enableRate = true
        audioPlayer?.rate = 2.0
        
        
        // TODO: UNWRAP PROPERLY
        
        let audioFileURL = directoryURL.URLByAppendingPathComponent("VoiceChanger.m4a")
        let audioSession = AVAudioSession.sharedInstance()
        
        // TODO: REMIND JOHANN TO GOOGLE AND LET ME KNOW WHAT DO TRY DOES AND ITS VARIANTS/DEPENDENTS
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
            
            // Define the recorder setting
            let recorderSetting: [String: AnyObject] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC), //format identifier
                AVSampleRateKey: 44100.0, //sample rate in Hertz
                AVNumberOfChannelsKey: 2, //how the audio travels
                AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue //audioQuality constant
            ]
            
            // Initiate and prepare the recorder
            audioRecorder = try AVAudioRecorder(URL: audioFileURL, settings: recorderSetting)
            audioRecorder?.delegate = self
            // TODO: GOOGLE METERING ENABLED -
            audioRecorder?.meteringEnabled = true
            audioRecorder?.prepareToRecord()
            
        } catch {
            print(error)
        }
    }
    
    func enableAndDisableButtons() {
        counter = counter + 1
        if counter%2 == 0 {
            self.stopButton.hidden = true
            self.recordBttn.hidden = false
        }
        else {
            self.recordBttn.hidden = true
            self.stopButton.hidden = false
        }
    }
    
    @IBOutlet weak var recordBttn: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBAction func customButtom(sender: AnyObject) {
        var typeOfChange:String = "time"
        
        var sliderValue = sliderSelector.value
        switch timeOrPitchSelector.selectedSegmentIndex {
        case 1:
            typeOfChange = "pitch"
        case 0:
            typeOfChange = "time"
        default:
            print("Broken")
        }
        print(typeOfChange)
        print(sliderValue)
        
        
        if typeOfChange == "time" {
            sliderSelector.maximumValue = 2.0
            sliderSelector.minimumValue = 0.0
            commonAudioFunction(sliderValue, typeOfChange: "rate")
            
        }
        else if typeOfChange == "pitch"{
            sliderSelector.maximumValue = 1500
            sliderSelector.minimumValue = -1500
            commonAudioFunction(sliderValue, typeOfChange: "pitch")
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func recordBtnPressed(sender: AnyObject) {
        enableAndDisableButtons()
        self.createDirectoryLocation()
        
        if let player = audioPlayer {
            if player.playing {
                player.stop()
                
            }
        }
        
        if let recorder = audioRecorder {
            if !recorder.recording {
                let audioSession = AVAudioSession.sharedInstance()
                
                do {
                    try audioSession.setActive(true)
                    
                    // Start recording
                    recorder.record()
                    
                } catch {
                    print(error)
                }
                
            } else {
                // Pause recording
                recorder.pause()
                
            }
        }
        
        
        
        
    }
    
    @IBAction func stopBtnPressed(sender: AnyObject) {
        enableAndDisableButtons()
        audioRecorder?.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            
            try audioSession.setActive(false)
        } catch {
            print(error)
        }
        
        
    }
    
    
    @IBAction func chipmunkPlayback(sender: UIButton) {
        commonAudioFunction(1000, typeOfChange: "pitch")
    }
    
    
    @IBAction func darthVaderPressed(sender: UIButton) {
        commonAudioFunction(-1000, typeOfChange: "pitch")
    }
    
    @IBAction func playbackPressed(sender: UIButton) {
        commonAudioFunction(0.0, typeOfChange: "pitch")
    }
    
    @IBAction func minionPlayback(sender: UIButton) {
        commonAudioFunction(1500.0, typeOfChange: "pitch")
    }
    
    @IBAction func playSoundSlowly(sender: UIButton) {
        commonAudioFunction(0.5, typeOfChange: "rate")
        
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        commonAudioFunction(1.5, typeOfChange: "rate")
    }
    @IBAction func littleBoy(sender:UIButton){
        commonAudioFunction(415.254, typeOfChange: "pitch")
    }
    // MARK: - AVAudioRecorderDelegate Methods
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Finishing recording")
        }else{
            print("errrrrrror")
        }
    }
    // MARK: - AVAudioPlayerDelegate Methods
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("finishing playing")
    }
    func commonAudioFunction(audioChangeNumber: Float, typeOfChange: String){
        audioRecorder?.stop()
        counter = -1
        enableAndDisableButtons()
        if let recorder = audioRecorder {
            if !recorder.recording {
                do {
                    
                    let audioFile = try AVAudioFile(forReading: recorder.url)
                    print(audioFile.length)
 
                    var audioPlayerNode = AVAudioPlayerNode()
                    
                    audioPlayerNode.stop()
                    audioEngine.stop()
                    audioEngine.reset()
                    
                    audioEngine.attachNode(audioPlayerNode)
                    
                    var changeAudioUnitTime = AVAudioUnitTimePitch()
                    
                    if (typeOfChange == "rate") {
                        
                        changeAudioUnitTime.rate = audioChangeNumber
                        
                    } else {
                        changeAudioUnitTime.pitch = audioChangeNumber
                    }
                    audioEngine.attachNode(changeAudioUnitTime)
                    audioEngine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
                    audioEngine.connect(changeAudioUnitTime, to: audioEngine.outputNode, format: nil)
                    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
                    try audioEngine.start()
                    audioPlayerNode.play()
                    
                } catch {
                    print(error)
                }
            }
        }
    }
}


