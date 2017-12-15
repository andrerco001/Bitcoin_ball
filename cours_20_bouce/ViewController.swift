//-------------
import UIKit
import Foundation
import AVFoundation
//-------------
class ViewController: UIViewController {
//-------------
    //Murs1
    @IBOutlet weak var mur_gauche: UIView!
    @IBOutlet weak var mur_haut: UIView!
    @IBOutlet weak var mur_droit: UIView!
    @IBOutlet weak var mur_bas: UIView!
    @IBOutlet weak var balle: UIView!
    
    //Mur 2
        @IBOutlet weak var mur_gauche2: UIView!
        @IBOutlet weak var mur_haut2: UIView!
        @IBOutlet weak var mur_droit2: UIView!
        @IBOutlet weak var mur_bas2: UIView!

    //Mur 3
        @IBOutlet weak var mur_gauche3: UIView!
        @IBOutlet weak var mur_haut3: UIView!
        @IBOutlet weak var mur_droit3: UIView!
        @IBOutlet weak var mur_bas3: UIView!
    
    //Mur 4
        @IBOutlet weak var mur_gauche4: UIView!
        @IBOutlet weak var mur_haut4: UIView!
        @IBOutlet weak var mur_droit4: UIView!
        @IBOutlet weak var mur_bas4: UIView!
    
    //Mur 5
        @IBOutlet weak var mur_gauche5: UIView!
        @IBOutlet weak var mur_haut5: UIView!
        @IBOutlet weak var mur_droit5: UIView!
        @IBOutlet weak var mur_bas5: UIView!
    
    //Game over et finger mover
    @IBOutlet weak var game_over: UIView!
    @IBOutlet weak var finger_mover: UIView!
    
    //timer
    @IBOutlet weak var timer_label: UILabel!
    
    //target et points
    @IBOutlet weak var target: UIView!
    @IBOutlet weak var target2: UIView!
    @IBOutlet weak var target3: UIView!
    @IBOutlet weak var target4: UIView!
    @IBOutlet weak var target5: UIView!
    @IBOutlet weak var target6: UIView!
    @IBOutlet weak var points_label: UILabel!
    
    //message game over
    
    @IBOutlet weak var message_game_over: UIView!
    
    //-------------
    var objet_bounce: Bounce!
    var objet_bounce2: Bounce!
    var objet_bounce3: Bounce!
    var objet_bounce4: Bounce!
    var objet_bounce5: Bounce!
    var cos: Double!
    var sin: Double!
    var mus_background = AVAudioPlayer()
    var aniMusicTimer: Timer!
    
    //Timer
    var aTimer: Timer!
    var game_timer: Timer!
    var sec = 120
   
    //Target
    var points = 0
    var tab_de_target: [UIView]!
    
    
    //-------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSounds()
        player()
        // Target dans le viewDidLoad
        tab_de_target = [target, target2, target3, target4, target5, target6]
        
        objet_bounce = Bounce(ball: balle,
                              left_window: mur_gauche,
                              right_window: mur_droit,
                              top_window: mur_haut,
                              bottom_window: mur_bas)
        
        objet_bounce2 = Bounce(ball: balle,
                              left_window: mur_gauche2,
                              right_window: mur_droit2,
                              top_window: mur_haut2,
                              bottom_window: mur_bas2)
        
                objet_bounce3 = Bounce(ball: balle,
                                      left_window: mur_gauche3,
                                      right_window: mur_droit3,
                                      top_window: mur_haut3,
                                      bottom_window: mur_bas3)
        
                objet_bounce4 = Bounce(ball: balle,
                                      left_window: mur_gauche4,
                                      right_window: mur_droit4,
                                      top_window: mur_haut4,
                                      bottom_window: mur_bas4)
        
                objet_bounce5 = Bounce(ball: balle,
                                      left_window: mur_gauche5,
                                      right_window: mur_droit5,
                                      top_window: mur_haut5,
                                      bottom_window: mur_bas5)
        
        balle.layer.cornerRadius = 22.5
        lancerAnimation()
    }
    //------------- Animation ball
    func lancerAnimation(){
        let degres: Double = Double(arc4random_uniform(360))
        cos = __cospi(degres/180)
        sin = __sinpi(degres/180)
        aTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(animation) , userInfo: nil, repeats: true)
        
        //Timer pour le jeu
        game_timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(keepTimer), userInfo: nil, repeats: true)
    }
    //-----
    @objc func keepTimer(){
        sec -= 1
        timer_label.text = "\(sec) seconds..."
        
    }
    //----
    @objc func animation(){
        //For target - points dans la fonction animation()
        for t in tab_de_target {
            
            // if des points
            if balle.frame.intersects(t.frame)
            {
                //----
                var smallNumber = t.frame.width/2 + 10
                var largeNumber = self.view.frame.width - 10 - t.frame.width/2
                let randomX = arc4random_uniform(UInt32(largeNumber - smallNumber + 1)) + UInt32(smallNumber)
                smallNumber = t.frame.height/2 + 10
                largeNumber = self.view.frame.height - 10 - t.frame.height/2
                let randomY = arc4random_uniform(UInt32(largeNumber - smallNumber + 1)) + UInt32(smallNumber)
                t.center.x = CGFloat(randomX)
                t.center.y = CGFloat(randomY)
                points += 10 // points originale 1
                points_label.text = "\(points) Bitcoin"
            }
        }
        
        //--- Controler le timer
        if sec == 0 {
            aTimer.invalidate()
            aTimer = nil
            game_timer.invalidate()
            game_timer = nil
            sec = 120
        }
        //---
        balle.center.x += CGFloat(cos)
        balle.center.y += CGFloat(sin)
        
        //Balle intersects avec game over le jeu va arreter
        if balle.frame.intersects(game_over.frame)
        {
            aTimer.invalidate(); aTimer = nil
            game_timer.invalidate(); game_timer = nil
            mus_background.stop()
            aniMusicTimer.invalidate(); aniMusicTimer = nil
            messageGameOver()
        }
        //Bounce 1
        sin = objet_bounce.returnCosSinAfterTouch(sin: sin, cos: cos)[0]
        cos = objet_bounce.returnCosSinAfterTouch(sin: sin, cos: cos)[1]
        
        //Bounce 2
        sin = objet_bounce2.returnCosSinAfterTouch(sin: sin, cos: cos)[0]
        cos = objet_bounce2.returnCosSinAfterTouch(sin: sin, cos: cos)[1]
        
        //Bounce 3
        sin = objet_bounce3.returnCosSinAfterTouch(sin: sin, cos: cos)[0]
        cos = objet_bounce3.returnCosSinAfterTouch(sin: sin, cos: cos)[1]
        
       // Bounce 4
        sin = objet_bounce4.returnCosSinAfterTouch(sin: sin, cos: cos)[0]
        cos = objet_bounce4.returnCosSinAfterTouch(sin: sin, cos: cos)[1]
        
       // Bounce 5
        sin = objet_bounce5.returnCosSinAfterTouch(sin: sin, cos: cos)[0]
        cos = objet_bounce5.returnCosSinAfterTouch(sin: sin, cos: cos)[1]
        
    }
    //--- Fonction touchesMoved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch: UITouch = touches.first!
        if touch.view == finger_mover{
            finger_mover.center.x = touch.location(in: self.view).x
            mur_bas.center.x = finger_mover.center.x
        }
        
        //play
//         if touch.view == player {
//                                    player.center.x = touch.location(in: self.view).x
//                                    paddle.center.x = player.center.x
//                            }

        
    }
    
    // Fonction sounds
    func loadSounds()
    {
        do
        {
            mus_background = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: Bundle.main.path(forResource: "background", ofType: "mp3")!))
            mus_background.prepareToPlay()
        }
        catch{ print(error) }
    }
    func player()
    {
        aniMusicTimer = Timer.scheduledTimer(timeInterval: 1,
                                             target: self,
                                             selector: #selector(playerMusic),
                                             userInfo: nil,
                                             repeats: true)
    }
    @objc func playerMusic()
    {
        if mus_background.isPlaying == false
        {
            mus_background.play()
        }
    }
    
    // Fonction message game over
    func messageGameOver(){
        if message_game_over.isHidden == true{
            message_game_over.isHidden = false
        } else {
            message_game_over.isHidden = true
            
        }
    }
    
//------------- Fin du code
}
