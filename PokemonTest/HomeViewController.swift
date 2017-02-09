//
//  HomeViewController.swift
//  PokemonTest
//
//  Created by Thai Duong on 2/8/17.
//  Copyright © 2017 Thai Duong. All rights reserved.
//

import UIKit
import AVFoundation
class HomeViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    let user = UserDefaults.standard
    var playAudio : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSound()
        NotificationCenter.default.addObserver(self, selector: #selector(playMusic(notification: )), name: NSNotification.Name("Music"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        
    }
    @IBAction func playDidTapped(_ sender: UIButton) {
        playAudio.stop()
        let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
        playViewController.buttonCenter = playButton.center
        self.present(playViewController, animated: true, completion: nil)
    }
    func setupSound() {
        do {
            playAudio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Quirky-Puzzle-Game-Menu", ofType: "mp3")!))
            guard playAudio.prepareToPlay() else {
                return
            }
            playAudio.numberOfLoops = -1
            if user.bool(forKey: "Music") {
                playAudio.play()
            }
        } catch let error {
            print("error: \(error.localizedDescription)")
        }
    }

    func setupUI() {
        if (UserDefaults.standard.object(forKey: "highscore") != nil) {
            let highScore = user.integer(forKey: "highscore")
            highScoreLabel.text = "HIGH SCORE " + " : \(highScore)"
        } else {
            highScoreLabel.text = "HIGH SCORE " + " : 0"
        }
        
        if (UserDefaults.standard.object(forKey: "score") != nil) {
            let score = user.integer(forKey: "score")
            scoreLabel.text = "\(score)"
        } else {
            scoreLabel.text = "0"
        }
    }
    
    @objc
    func playMusic(notification: Notification) {
        let info = notification.userInfo?["music"] as! Bool
        if info {
            playAudio.play()
        } else {
            playAudio.stop()
        }
    }

}
