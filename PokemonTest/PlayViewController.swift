//
//  PlayViewController.swift
//  PokemonTest
//
//  Created by Thai Duong on 2/8/17.
//  Copyright © 2017 Thai Duong. All rights reserved.
//

import UIKit
import AVFoundation
class PlayViewController: UIViewController {

    @IBOutlet weak var timeCircle: ProgressCircleBar!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var descriptionPokemonLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!
    @IBOutlet weak var centerImageContraint: NSLayoutConstraint!
    
    var buttonCenter: CGPoint!
    var amount: Int = 0
    var indexPokemon: Int = 0
    var pokemon: Pokemon?
    var namesAnswers: [String] = []
    var isAnswer = false
    var score = 0
    let user = UserDefaults.standard
    
    var playAudio: AVAudioPlayer!
    var incorrectAudio: AVAudioPlayer!
    var correctAudio: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeCircle.seconds = 10.0*1000.0
        timeCircle.timeInterval = 0.0
        aButton.isHidden = true
        bButton.isHidden = true
        cButton.isHidden = true
        dButton.isHidden = true
        amount = Database.defaults.getAmountData()
        getData()
        setupTimer()
        setupSound()
        self.transitioningDelegate = self
    }
    
    
    @IBAction func backDidTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        playAudio.stop()
        NotificationCenter.default.post(name: NSNotification.Name("Music"), object: nil, userInfo: ["music": user.bool(forKey: "Music")])
    }
    
    @IBAction func answerDidTapped(_ sender: UIButton) {
        isAnswer = true
        guard let text = sender.titleLabel?.text else {
            return
        }
        if text == pokemon!.name {
            sender.backgroundColor = UIColor(red: 102.0/255, green: 214.0/255.0, blue: 0.0, alpha: 1.0)
            score += 1
            if user.bool(forKey: "Sound Effect") {
                correctAudio.play()
            }
        } else {
            sender.backgroundColor = UIColor(red: 247.0/255.0, green: 53.0/255.0, blue: 35.0 / 255.0, alpha: 1.0)
            let button = [aButton, bButton, cButton, dButton].filter({ (button) -> Bool in
                return button?.titleLabel!.text == pokemon!.name
            }).first
            button!?.backgroundColor = UIColor(red: 102.0/255, green: 214.0/255.0, blue: 0.0, alpha: 1.0)
            if user.bool(forKey: "Sound Effect") {
                incorrectAudio.play()
            }
        }
        aButton.isUserInteractionEnabled = false
        bButton.isUserInteractionEnabled = false
        cButton.isUserInteractionEnabled = false
        dButton.isUserInteractionEnabled = false
        scoreLabel.text = "\(score)"
        setupImageAfterAnswer()
    }
}

extension PlayViewController {
    func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0/1000.0, repeats: true) { (timer) in
            if self.timeCircle.timeInterval < self.timeCircle.seconds {
                self.timeCircle.timeInterval += 1.0
            }
            else {
//                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                
//                self.present(homeViewController, animated: true, completion: nil)
//                homeViewController.playButton.setImage(UIImage(named: "Button_Replay@3x.png"), for: UIControlState.normal)
                
//                if self.user.integer(forKey: "highscore") < self.score {
//                        self.user.set(self.score, forKey: "highscore")
//                }
//                self.user.set(self.score, forKey: "score")
//                self.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "Time's Up!", message: "Score: \(self.score)", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.playAudio.stop()
                    NotificationCenter.default.post(name: NSNotification.Name("Music"), object: nil, userInfo: ["music": self.user.bool(forKey: "Music")])
                    if self.user.integer(forKey: "highscore") < self.score {
                        self.user.set(self.score, forKey: "highscore")
                    }
                    self.user.set(self.score, forKey: "score")
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true
                    , completion: nil)
                timer.invalidate()
            }
        }
    }
    func setupSound() {
        do {
            playAudio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "8-Bit-Mayhem", ofType: "mp3")!))
            playAudio.numberOfLoops = -1
            if user.bool(forKey: "Music") {
                playAudio.play()
            }
        } catch let error {
            print("error: \(error.localizedDescription)")
        }
        
        do {
            correctAudio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "firered_00FA", ofType: "wav")!))
        } catch let error {
            print("error: \(error.localizedDescription)")
        }
        
        do {
            incorrectAudio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "firered_00A3", ofType: "wav")!))
        } catch let error {
            print("error: \(error.localizedDescription)")
        }
    }
    func getData() {
        isAnswer = false
        indexPokemon = Int(arc4random()) % amount + 1
        pokemon = Database.defaults.getDataPokemon(index: "\(indexPokemon)")
        namesAnswers = Database.defaults.getIncorrectName(index: "\(indexPokemon)", count: amount)!
        namesAnswers.append(pokemon!.name)
        setupUI()
    }
    
    func setupUI() {
        descriptionPokemonLabel.text = ""
        self.view.backgroundColor = UIColor(hexString: pokemon!.color)
        setupImageBeforeAnswer()
        
    }
    
    func setupImageBeforeAnswer() {
        let blackImage = UIImage.processPixels(in: UIImage(named: pokemon!.imageName)!)
        self.pokemonImageView.image = blackImage
        pokemonImageView.frame.origin = CGPoint(x: self.view.frame.width, y: pokemonImageView.frame.origin.y)
        descriptionPokemonLabel.frame.origin = CGPoint(x: self.view.frame.width + 8, y: descriptionPokemonLabel.frame.origin.y)
        UIView.animate(withDuration: 0.5, animations: {
            self.pokemonImageView.frame.origin = CGPoint(x: self.view.frame.width / 2.0 - self.pokemonImageView.frame.width / 2.0, y: self.pokemonImageView.frame.origin.y)
            self.descriptionPokemonLabel.frame.origin = CGPoint(x: self.view.frame.width / 2.0 - self.pokemonImageView.frame.width / 2.0 - 8, y: self.descriptionPokemonLabel.frame.origin.y)
        }) { (completed) in
            self.setupButton()
        }
    }
    
    func setupImageAfterAnswer() {
        if isAnswer {
            UIView.transition(with: pokemonImageView, duration: 1.0, options: .transitionFlipFromLeft, animations: {
                self.pokemonImageView.image = UIImage(named: self.pokemon!.imageName)
            }, completion: { (completed) in
                if completed {
                    //self.descriptionPokemonLabel.text = self.pokemon!.tag + " " + self.pokemon!.name
                    self.setupButton()
                    UIView.animate(withDuration: 0.5, animations: {
                        self.pokemonImageView.frame.origin = CGPoint(x: -self.pokemonImageView.frame.width, y: self.pokemonImageView.frame.origin.y)
                        self.descriptionPokemonLabel.frame.origin = CGPoint(x: -self.pokemonImageView.frame.width + 8, y: self.descriptionPokemonLabel.frame.origin.y)
                    }, completion: { (completed) in
                        if completed {
                            self.getData()
                        }
                    })
                }
            })
        }
    }
    
    func setupButton() {
        if !isAnswer {
            aButton.backgroundColor = .white
            bButton.backgroundColor = .white
            cButton.backgroundColor = .white
            dButton.backgroundColor = .white
            
            var i = Int(arc4random()) % namesAnswers.count
            aButton.setTitle(namesAnswers[i], for: .normal)
            namesAnswers.remove(at: i)
            i = Int(arc4random()) % namesAnswers.count
            bButton.setTitle(namesAnswers[i], for: .normal)
            namesAnswers.remove(at: i)
            i = Int(arc4random()) % namesAnswers.count
            cButton.setTitle(namesAnswers[i], for: .normal)
            namesAnswers.remove(at: i)
            dButton.setTitle(namesAnswers.first!, for: .normal)
            namesAnswers.removeAll()
            
            aButton.isHidden = false
            bButton.isHidden = false
            cButton.isHidden = false
            dButton.isHidden = false
            aButton.isUserInteractionEnabled = true
            bButton.isUserInteractionEnabled = true
            cButton.isUserInteractionEnabled = true
            dButton.isUserInteractionEnabled = true
        } else {
            aButton.isHidden = true
            bButton.isHidden = true
            cButton.isHidden = true
            dButton.isHidden = true
        }
    }
}
extension PlayViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = TransitionAnimator()
        transition.duration = 0.5
        transition.isPush = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = TransitionAnimator()
        transition.duration = 0.5
        transition.isPush = false
        return transition
    }
}
