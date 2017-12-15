//-------- Biblioteques du code
import UIKit
import Foundation
import AVFoundation

//------------- Class viewController que va controller touts les objets, variables, methodes et etc du code
class ViewController: UIViewController {

    //------------- Sections des variables Outlets
    
    //--- Les murs empêchent la continuité de la balle et l'envoient à la secte opposée. Les murs forment avec une view.
    @IBOutlet weak var mur_gauche: UIView!
    @IBOutlet weak var mur_haut: UIView!
    @IBOutlet weak var mur_droit: UIView!
    @IBOutlet weak var mur_bas: UIView!
    @IBOutlet weak var balle: UIView!
    
    //--- A ce moment, les murs 2 à 5 ont été créés, ce qui servirait également d'obstacle à la balle et la tournerait dans une autre direction.
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
    
    /*La view game over aura la fonction d'arrêter le jeu chaque fois que la balle le touche et la glisseront avec le muret et joueront l'un des personnages principaux du jeu, car ils seront responsables de lancer la balle.*/
    @IBOutlet weak var game_over: UIView!
    @IBOutlet weak var finger_mover: UIView!
    
    //--- Le timer_label est une variable qui va informer le temps de jeu.
    @IBOutlet weak var timer_label: UILabel!
    
    //--- Les targets ont été créées pour marquer les points à chaque fois qu'ils entrent en collision avec la balle qui aura alors leur position changée au hasard.
    //--- Les points_label montrera sur l'écran les points obtenus au cours du jeu.
    @IBOutlet weak var target: UIView!
    @IBOutlet weak var target2: UIView!
    @IBOutlet weak var target3: UIView!
    @IBOutlet weak var target4: UIView!
    @IBOutlet weak var target5: UIView!
    @IBOutlet weak var target6: UIView!
    @IBOutlet weak var points_label: UILabel!
    
    //--- La message_game_over apparaîtra sur l'écran chaque fois que la balle touche dans le mur game_over.
    @IBOutlet weak var message_game_over: UIView!
    
    //--- Section aux variables objet_bounce serviront d'obstacles pour la balle, variables cos et sin qui vont controler la position de la balle, variable de la musique de fond et variable qui va contrôler le temp de l'animation de la musique de fond.
    var objet_bounce: Bounce!
    var objet_bounce2: Bounce!
    var objet_bounce3: Bounce!
    var objet_bounce4: Bounce!
    var objet_bounce5: Bounce!
    var cos: Double!
    var sin: Double!
    var mus_background = AVAudioPlayer()
    var aniMusicTimer: Timer!
    
    //--- Variables de contrôle du Timer
    var aTimer: Timer!
    var game_timer: Timer!
    var sec = 60
   
    //--- Variables qui vont contrôler les points le tableau de Target
    var points = 0
    var tab_de_target: [UIView]!
    
    //--- Section viewDidLoad qui va montrer dans la view les commands et fonctions du jeu.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //--- Appelle la fonction du temp et player de la music de fond.
        loadSounds()
        player()
        
        //--- Tabeau de Target dans le viewDidLoad pour montrer dans la view tous les targets qui ont été créés.
        tab_de_target = [target, target2, target3, target4, target5, target6]
        
        //--- Section créant tous les obstacles dans le jeu avec les murs haut, gauche, droit et bas (Bounce jusqu'à Bounce 5).
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
        
        //--- Formate la balle mais devient invisible après avoir utilisé l'image de la balle.
        balle.layer.cornerRadius = 22.5
        
        //--- Appelle la fonction lancerAnimation.
        lancerAnimation()
    }
    //--- Animation balle
    /*Cette fonction est importante pour le mouvement de la balle dans la vue, qui aura une motivation de 360 degrés et aura son sens changé dans les axes cosinus et sinus, avec un velocité de 0.001, effectuant un motif continu et aléatoire jusqu'à ce qu'il entre en collision avec le mur game_over.*/
    
    func lancerAnimation(){
        let degres: Double = Double(arc4random_uniform(360))
        cos = __cospi(degres/180)
        sin = __sinpi(degres/180)
        aTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(animation) , userInfo: nil, repeats: true)
        
        //--- Contrôlle le temps de jeu avec une répétition continue toutes les 1,0 seconde.
        game_timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(keepTimer), userInfo: nil, repeats: true)
    }
    //--- Label qui informera l'heure du jeu sur la view avec un compte à rebours.
    @objc func keepTimer(){
        sec -= 1
        timer_label.text = "\(sec) seconds..."
        
    }
    //--- Fonction animation
    @objc func animation(){
        
        //--- For target - points
        for t in tab_de_target {
            
            //--- if des points à chaque fois que la balle touche les cibles, elles changent de place au hasard.
            if balle.frame.intersects(t.frame)
            {
                /* Séquence de commandes qui contrôlent le mouvement des targets, effectuant un calcul sur les axes x et y, réduisant de la taille des murs et divisant par la taille de la métadade de chaque target. */
                var smallNumber = t.frame.width/2 + 10
                var largeNumber = self.view.frame.width - 10 - t.frame.width/2
                let randomX = arc4random_uniform(UInt32(largeNumber - smallNumber + 1)) + UInt32(smallNumber)
                smallNumber = t.frame.height/2 + 10
                largeNumber = self.view.frame.height - 10 - t.frame.height/2
                let randomY = arc4random_uniform(UInt32(largeNumber - smallNumber + 1)) + UInt32(smallNumber)
                t.center.x = CGFloat(randomX)
                t.center.y = CGFloat(randomY)
                points += 10 // points du jeu
                points_label.text = "\(points) Bitcoin"
            }
        }
        
        //--- Controler le timer du jeu
        if sec == 0 {
            aTimer.invalidate()
            aTimer = nil
            game_timer.invalidate()
            game_timer = nil
            sec = 60
        }
        
        //--- Position de la balle.
        balle.center.x += CGFloat(cos)
        balle.center.y += CGFloat(sin)
        
        //--- Balle intersects avec game over le jeu va arreter le jeu, la musique de fond et va montrer la message game over
        if balle.frame.intersects(game_over.frame)
        {
            aTimer.invalidate(); aTimer = nil
            game_timer.invalidate(); game_timer = nil
            mus_background.stop()
            aniMusicTimer.invalidate(); aniMusicTimer = nil
            messageGameOver()
        }

        //--- sin et cos du Bounce 1
        sin = objet_bounce.returnCosSinAfterTouch(sin: sin, cos: cos)[0]
        cos = objet_bounce.returnCosSinAfterTouch(sin: sin, cos: cos)[1]
        
        //--- sin et cos du Bounce 2
        sin = objet_bounce2.returnCosSinAfterTouch(sin: sin, cos: cos)[0]
        cos = objet_bounce2.returnCosSinAfterTouch(sin: sin, cos: cos)[1]
        
        //--- sin et cos du Bounce 3
        sin = objet_bounce3.returnCosSinAfterTouch(sin: sin, cos: cos)[0]
        cos = objet_bounce3.returnCosSinAfterTouch(sin: sin, cos: cos)[1]
        
       //--- sin et cos du Bounce 4
        sin = objet_bounce4.returnCosSinAfterTouch(sin: sin, cos: cos)[0]
        cos = objet_bounce4.returnCosSinAfterTouch(sin: sin, cos: cos)[1]
        
       //--- sin et cos du Bounce 5
        sin = objet_bounce5.returnCosSinAfterTouch(sin: sin, cos: cos)[0]
        cos = objet_bounce5.returnCosSinAfterTouch(sin: sin, cos: cos)[1]
        
    }
    
    //--- Fonction touchesMoved que changera de place le mur bas et le finger pour contrôller le mouvement de la balle.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch: UITouch = touches.first!
        if touch.view == finger_mover{
            finger_mover.center.x = touch.location(in: self.view).x
            mur_bas.center.x = finger_mover.center.x
        }
    }
    
    //--- Fonction sounds pour musique de fond
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
    
    //--- Fonction message_game_over pour montrer la message a chaque fois que la balle touche le mur game_over
    func messageGameOver(){
        if message_game_over.isHidden == true{
            message_game_over.isHidden = false
        } else {
            message_game_over.isHidden = true
            
        }
    }
    
//------------- Fin du code
}
