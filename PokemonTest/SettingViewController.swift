//
//  SettingViewController.swift
//  PokemonTest
//
//  Created by Thai Duong on 2/8/17.
//  Copyright © 2017 Thai Duong. All rights reserved.
//

import UIKit
import AVFoundation
class SettingViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var musicSwitch: UISwitch!
    
    let userDefault = UserDefaults.standard
    var clickAudio: AVAudioPlayer!
    var toggleAudio: AVAudioPlayer!
    var cancelAudio: AVAudioPlayer!
    
    var genSelected = [1, 2, 3, 4, 5, 6]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupSound()
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        userDefault.set(genSelected, forKey: "GenSelected")
    }
    
    @IBAction func backDidTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func musicDidSwitch(_ sender: UISwitch) {
        NotificationCenter.default.post(name: NSNotification.Name("Music"), object: nil, userInfo: ["music": sender.isOn])
        if soundSwitch.isOn {
            if sender.isOn {
                clickAudio.play()
            } else {
                toggleAudio.play()
            }
        }
        
        userDefault.set(sender.isOn, forKey: "Music")
    }
    
    @IBAction func soundDidSwitch(_ sender: UISwitch) {
        if sender.isOn {
            clickAudio.play()
        }
        
        userDefault.set(sender.isOn, forKey: "Sound Effect")
    }
}

extension SettingViewController {
    func getData() {
//        genSelected = userDefault.value(forKey: "GenSelected") as! [Int]
    }
    
    func setupUI() {
        soundSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        musicSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        soundSwitch.isOn = userDefault.bool(forKey: "Sound Effect")
        musicSwitch.isOn = userDefault.bool(forKey: "Music")
    }
    
    func setupSound() {
        do {
            clickAudio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "UIClick", ofType: "wav")!))
        } catch let error {
            print("error: \(error.localizedDescription)")
        }
        
        do {
            toggleAudio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "UIToggle", ofType: "wav")!))
        } catch let error {
            print("error: \(error.localizedDescription)")
        }
        
        do {
            cancelAudio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "firered_00A3", ofType: "wav")!))
        } catch let error {
            print("error: \(error.localizedDescription)")
        }
    }
}
