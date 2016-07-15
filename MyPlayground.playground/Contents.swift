//
//  ViewController.swift
//  VoiceChanger
//
//  Created by Elli Scharlin on 7/15/16.
//  Copyright © 2016 ElliBelly. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer:AVAudioPlayer?
    var audioEngine: AVAudioEngine!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createDirectoryLocation()
        
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
            
            // TODO:GOOGLE WHAT CHANNEL KEYS AND AUDIO SAMPE RATE IS
            let recorderSetting: [String: AnyObject] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func recordBtnPressed(sender: AnyObject) {
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
        audioRecorder?.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch {
            print(error)
        }
        
        
    }
    
    @IBAction func playbackBtnPressed(sender: AnyObject) {
        if let recorder = audioRecorder {
            if !recorder.recording {
                do {
                    
                    let audioFile = try AVAudioFile(forReading: recorder.url)
                    
                    var audioPlayerNode = AVAudioPlayerNode()
                    audioEngine.attachNode(audioPlayerNode)
                    var changePitchEffect = AVAudioUnitTimePitch()
                    changePitchEffect.pitch = 1000
                    audioEngine.attachNode(changePitchEffect)
                    audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
                    audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
                    
                    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
                    
                    
                    audioPlayerNode.play()
                    
                    //                    audioPlayer = try AVAudioPlayer(contentsOfURL: recorder.url)
                    
                    //                    audioPlayerNode.play()
                    //
                    //
                    //                    audioPlayer?.play()
                    //
                    //                    playButton.setImage(UIImage(named: "playing"), forState: UIControlState.Selected)
                    //                    playButton.selected = true
                } catch {
                    print(error)
                }
            }
        }
        
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
    
    
    
}

