//
//  BattleViewController.swift
//  TechMon
//
//  Created by 黒川龍之介 on 2022/02/21.
//

import UIKit

class BattleViewController: UIViewController {
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel: UILabel!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    let techMonManeger = TechMonManager.shared
    
    var playerHP = 100
    var playerMP = 0
    var enemyHP = 200
    var enemyMP = 0
    
    var player: Character!
    var enemy: Character!
    
    var gameTimer: Timer!
    var isPlyerAttackAvailable: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = techMonManeger.player
        enemy = techMonManeger.enemy
        
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.jpg")
        playerHPLabel.text = "\(playerHP) / 100"
        playerMPLabel.text = "\(playerMP) / 20"
        
        enemyNameLabel.text = "龍"
        enemyImageView.image = UIImage(named: "monster.jpg")
        enemyHPLabel.text = "\(enemyHP) / 200"
        enemyMPLabel.text = "\(enemyMP) / 35"
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        gameTimer.fire()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManeger.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManeger.stopBGM()
        techMonManeger.resetStatus()
    }
    
    @objc func updateGame() {
        playerMP += 1
        if playerMP >= 20{
            isPlyerAttackAvailable = true
            playerMP = 20
        }else{
            isPlyerAttackAvailable = false
        }
        
        enemyMP += 1
        if enemyMP >= 35 {
            enemyAttack()
            enemyMP = 0
        }
        
        playerMPLabel.text = "\(playerMP) / 20"
        enemyMPLabel.text = "\(enemyMP) / 35"
    }
    
    func enemyAttack(){
        techMonManeger.damageAnimation(imageView: playerImageView)
        techMonManeger.playSE(fileName: "SE_attack")
        
        playerHP -= 20
        
        playerHPLabel.text = "\(playerHP) / 100"
        
        if playerHP <= 0 {
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool) {
        
        techMonManeger.vanishAnimation(imageView: vanishImageView)
        techMonManeger.stopBGM()
        gameTimer.invalidate()
        isPlyerAttackAvailable = false
        
        var finishMessage: String = ""
        if isPlayerWin {
            techMonManeger.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！！"
        }else{
            techMonManeger.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北…"
        }
        
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func attackAction() {
        if isPlyerAttackAvailable{
            
            techMonManeger.damageAnimation(imageView: enemyImageView)
            techMonManeger.playSE(fileName: "SE_attack")
            
            enemyHP -= 30
            playerMP = 0
            
            enemyHPLabel.text = "\(enemyHP) / 200"
            playerMPLabel.text = "\(playerMP) / 20"
            
            if enemyHP <= 0{
                finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
            }
        }
    }
    
    func updateUI() {
        playerHPLabel.text = "\(player.currentHP) / \(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP) / \(player.maxMP)"
        
        enemyHPLabel.text = "\(enemy.currentHP) / \(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP)"
    }
    
    func judgeBattle(){
        if player.currentHP <= 0{
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }else if enemy.currentHP <= 0{
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }

}
