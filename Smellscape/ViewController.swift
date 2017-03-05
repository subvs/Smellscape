//
//  ViewController.swift
//  Smellscape
//
//  Created by Vishal Srivastava on 3/4/17.
//  Copyright © 2017 Subversus Interactive. All rights reserved.
//

import UIKit

import AVFoundation


enum SmellType {
    case pumpkin
    case apple
    case flower
    case pine
    case rain
    case nothing
}


class Smell {
    var theSmellType: SmellType = .nothing
    var name = "[name]"
    var color: UIColor = .black
    var theIntensity:CGFloat = 0.0
    
    init(_ smellType: SmellType, intensity: CGFloat) {
        theSmellType = smellType
        
        switch smellType {
        case .pumpkin:
            name = "Fresh Fall Pumpkin"
            color = .orange
        case .apple:
            name = "Fresh Pressed Apple"
            color = .red
        case .flower:
            name = "First Bloom"
            color = .magenta
        case .pine:
            name = "Fresh Cut Pine"
            color = .green
        case .rain:
            name = "Meadows & Rain"
            color = .cyan
        case .nothing:
            name = "No smell..."
            color = .clear
        }
        
        theIntensity = intensity
    }
}

enum NpcType {
    case trolls
    case applePie
    case nothing
}

class Npc {
    var image: UIImage?
    var npcType: NpcType
    
    init(_ theNpcType: NpcType = .nothing) {
        self.npcType = theNpcType
        
        let imageName: String
        switch theNpcType {
        case .trolls: imageName = "trolls.png"
        case .applePie: imageName = "pie.png"
        default: imageName = "trolls.png"
        }
        
        self.image = UIImage(named: imageName)!
    }
}


enum TileType {
    case plain //0
    case pine //1
    case water //2
    case island //3
    case pumpkin //4
    case flower //5
    case apple //6
}


let tileDimension: CGFloat = 200.0

class Tile {
    var imageView: UIImageView?
    var tileType: TileType
    let pos: CGPoint
    
    init(_ theTileType: TileType, x: Int, y: Int) {
        self.tileType = theTileType
        
        self.pos = CGPoint(x: x, y: y)
        
        let imageName: String
        switch theTileType {
            case .plain: imageName = "plain.png"
            case .pine: imageName = "pine.png"
            case .water: imageName = "water.png"
            case .island: imageName = "island.png"
            case .pumpkin: imageName = "pumpkin.png"
            case .flower: imageName = "flower.png"
            case .apple: imageName = "plain.png"
        }
        
        self.imageView = UIImageView(image: UIImage(named: imageName)!)
        self.imageView!.frame = CGRect(x: CGFloat(x)*tileDimension, y: CGFloat(y)*tileDimension, width: tileDimension, height: tileDimension)
    }
}




var tilesByString: [String] = [
    "🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊🌱🌱🌊🌊",
    "🌊🌊🌊🌊🌴🌴🌊🌊🌊🌱🌱🌱🌱🌊",
    "🌊🌊🌊🌴🌴🌴🌴🌊🌊🌱🌱🌱🌱🌱",
    "🌊🌊🌴🌴🌴🌴🌊🌊🌊🌱🌱🌱🌱🌱",
    "🌴🌊🌊🌊🌊🌊🌊🌲🌲🌲🌲🌲🌲🌱",
    "🌴🌊🌱🌱🌱🌱🌲🌲🌲🌲🌲🌲🌲🌲",
    "🌴🌊🌱☔️🌱🌱🌲🌲🌲🌲🌲🌲🌲🌲",
    "🌴🌊🌊☔️🌱🌱🌱🌱🌱🌊🌱🌲🌲🌲",
    "🌴🌴🌊🌱🌱🌱🌱🌱🌱🌊🌊🌱🌱🌲",
    "🌴🌴☔️☔️🌱🌱🌊🌸🌸🌊🌊🌱🌱🌱",
    "🌴☔️☔️🌱🌱🌱🌊🌊🌊🌊🌱🌱🌱🌱",
    "🌊🌊🌊🌱🌱🌱🌱🌱🌱🌱🌱🍎🍎🌱",
    "🌊🌊🌊🌊🌊🌱🌱🌱🌱🌱🌱🌱🌱🌱",
    "🌊🌊🌊🌊🌱🌱🌱🌱🌱🌱🌱🌱🌱🌱",
    "🌊🌊🌊🌱🌱🌱🌱🌱🌱🌱🌱🍎🍎🌱",
    "🌊🌊🌊🌊🌊🌸🌸🌸🌱🌱🌱🌱🌱🌱",
    "🌊🌊🌊🌊🌊🌊🌸🌱🌱🌱🌱🌱🌱🌱"
]

enum Direction {
    case north
    case south
    case east
    case west
    case nothing
}

class Move {
    var speechString = ""
    var direction: Direction = .nothing
    var theSmell = Smell(.nothing, intensity: 0.0)
    var theNpc = Npc(.nothing)
    
    init(dir: Direction, speech: String, smell: Smell, npc: Npc = Npc(.nothing)) {
        speechString = speech
        direction = dir
        theSmell = smell
        theNpc = npc
    }
}

var scriptMoves = [
    // [nothing]
    Move(dir: .nothing,
         speech: "",
         smell: Smell(.nothing, intensity: 0.0)),
    // [nothing]
    Move(dir: .nothing,
         speech: "Wake up! A sorceress has cast a blindness spell upon you! You can barely see in front of you. The Wizard can reverse the spell.  He's on Aloha Island to the west",
         smell: Smell(.nothing, intensity: 0.0)),
    // Go west
    Move(dir: .west,
         speech: "",
        smell: Smell(.nothing, intensity: 0.0)),
    // Go west again
    Move(dir: .west,
         speech: "What's that faint scent to the north? Reminds me of Christmas. Take a whiff!",
        smell: Smell(.pine, intensity: 0.25)),
    // Go north
    Move(dir: .north,
         speech: "Great! Way to follow your nose! Notice the pine smell getting stronger? We're getting close!",
        smell: Smell(.pine, intensity: 0.5)),
    // Go north again
    Move(dir: .north,
         speech: "We're here in Christmas Valley.  There's a bunch of chopped wood on the ground",
         smell: Smell(.pine, intensity: 1.0)),
    // Take the wood
    Move(dir: .nothing,
         speech: "OK, we took the wood",
         smell: Smell(.pine, intensity: 1.0)),
    
    // Build a raft
    Move(dir: .nothing,
         speech: "Great! You put a raft together using the wood.  But now you're starving",
         smell: Smell(.pine, intensity: 1.0)),
    
    // Go west
    Move(dir: .west,
         speech: "Continuing west",
         smell: Smell(.pine, intensity: 0.5)),
    
    // Go west again
    Move(dir: .west,
         speech: "Three trolls appear.  They have a puzzle.  Guess which one of us has an Apple Pie, and you may have it",
         smell: Smell(.nothing, intensity: 0.0),
         npc: Npc(.trolls)),
    // Sniff the left troll
    Move(dir: .nothing,
         speech: "OK",
         smell: Smell(.nothing, intensity: 0.0),
         npc: Npc(.trolls)),
    // Sniff the middle troll
    Move(dir: .nothing,
         speech: "OK",
         smell: Smell(.nothing, intensity: 0.0),
         npc: Npc(.trolls)),
    // Sniff the right troll
    Move(dir: .nothing,
         speech: "OK!", //"Whoa"
         smell: Smell(.apple, intensity: 1.0),
         npc: Npc(.trolls)),
    // Point at right troll
    Move(dir: .nothing,
         speech: "Great, you found the correct troll!  The trolls give you their Apple Pie",
         smell: Smell(.apple, intensity: 1.0),
         npc: Npc(.applePie)),
    // Eat the pie
    Move(dir: .nothing,
         speech: "You ate the pie, and feel ready to sail",
         smell: Smell(.nothing, intensity: 0.0)),
    // Go west
    Move(dir: .west,
         speech: "",
         smell: Smell(.nothing, intensity: 0.0)),
    // Go south
    Move(dir: .south,
         speech: "We're at the water now",
         smell: Smell(.rain, intensity: 0.0)),
    // Get on the raft
    Move(dir: .west,
         speech: "You're on the raft",
         smell: Smell(.nothing, intensity: 0.0)),
]

let numXTiles = 14
let numYTiles = tilesByString.count

//var tilesByInt: [[Int]] = [[]]

var tiles: [[Tile]] = Array(repeating: Array(repeating: Tile(.plain, x: 0, y: 0), count: numXTiles), count: numYTiles)

var currentPosition = CGPoint(x: 8, y: 8)

var gameAreaView = UIScrollView()

var playerView = UIImageView(image: UIImage(named: "player.png"))

var npcView = UIImageView()

let synthesizer = AVSpeechSynthesizer()

var moveIdx = 0

class ViewController: UIViewController {
    
    var skipButton = UIButton()
    
    var smellMeterImageView = UIImageView()
    var percentLabel = UILabel()
    var scentNameLabel = UILabel()

    var currentSmellType: SmellType = .nothing
    var currentNpcType: NpcType = .nothing


    override func viewDidLoad() {
        
        

        

        
        /*
        smells.append(s1)
        smells.append(s2)
        smells.append(s3)
        smells.append(s4)
        smells.append(s5)
 */
        
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height - 150.0
        gameAreaView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        gameAreaView.clipsToBounds = true
        self.view.addSubview(gameAreaView)
        
        
        //tilesByEnum =
        
        var y: Int = 0
        for row in tilesByString {
            var x: Int = 0
            for theChar in row.characters {
                switch theChar {
                    case "🌱":
                        tiles[y][x] = Tile(.plain, x: x, y: y)
                    case "🌲":
                        tiles[y][x] = Tile(.pine, x: x, y: y)
                    case "🌊":
                        tiles[y][x] = Tile(.water, x: x, y: y)
                    case "🌴":
                        tiles[y][x] = Tile(.island, x: x, y: y)
                    case "🎃":
                        tiles[y][x] = Tile(.pumpkin, x: x, y: y)
                    case "🌸":
                        tiles[y][x] = Tile(.flower, x: x, y: y)
                    case "🍎":
                        tiles[y][x] = Tile(.apple, x: x, y: y)
                    default:
                        tiles[y][x] = Tile(.plain, x: x, y: y)
                }
                
                gameAreaView.addSubview(tiles[y][x].imageView!)
                x += 1
            }
            y += 1
        }
        
        gameAreaView.backgroundColor = .black
        
        self.view.backgroundColor = .black
        
        super.viewDidLoad()
        
        
        
        
        smellMeterImageView.frame = CGRect(x: 0, y: 625, width: 120, height: 120)
        smellMeterImageView.image = UIImage(named: "blur_mask.png")!.withRenderingMode(.alwaysTemplate)
        smellMeterImageView.alpha = 0.6
        
        self.view.addSubview(smellMeterImageView)
        

        
        
        
        
        
        
        
        percentLabel = UILabel(frame: smellMeterImageView.frame)
        percentLabel.textAlignment = .center
        percentLabel.textColor = .black
        
        self.view.addSubview(percentLabel)
        

        
        
        
        scentNameLabel = UILabel(frame: CGRect(x: 120, y: 625, width: 400, height: 120))
        scentNameLabel.font = UIFont(name: "BodoniSvtyTwoITCTT-Book", size: 30.0)
        scentNameLabel.textAlignment = .left
        
        self.view.addSubview(scentNameLabel)
        
        
        
        //skipButton.hidden = true
        skipButton.addTarget(self, action: #selector(ViewController.skipButtonTapped), for: .touchUpInside)
        skipButton.backgroundColor = .clear
        skipButton.frame = self.view.frame
        //self.view.addSubview(skipButton)
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.window!.addSubview(skipButton)
        //appDelegate.window!.bringSubview(toFront: skipButton)


        self.view.addSubview(skipButton)
        
        
        playerView.frame = CGRect(x: currentPosition.x*tileDimension, y: currentPosition.y*tileDimension, width: tileDimension, height: tileDimension)
        gameAreaView.addSubview(playerView)
        
        
        npcView.frame = CGRect(x: currentPosition.x*tileDimension, y: currentPosition.y*tileDimension - tileDimension*3.0, width: tileDimension, height: tileDimension)
        gameAreaView.addSubview(npcView)
        
        
        
        
        update()
    }
    
    func skipButtonTapped(sender: AnyObject, event: UIEvent) {
        
/*
    
        // downcast sender as a UIView
        let buttonView = sender as! UIView;
        
        // get any touch on the buttonView
        
        
        

        guard let touch = event.allTouches?.first else { return }
        let point = touch.location(in: buttonView)
            
        if point.x < 100.0 {
            currentPosition.x -= 1
        }
        else if point.x > UIScreen.main.bounds.width - 100.0 {
            currentPosition.x += 1
        }
        else if point.y < 100.0 {
            currentPosition.y -= 1
        }
        else if point.y > UIScreen.main.bounds.height - 100.0 {
            currentPosition.y += 1
        }
        else { // middle
            
        }
 */

        
        
        moveIdx += 1
        
        update()
    }
    
    
    
    
    func update() {
        
        let move = scriptMoves[moveIdx]
        
        switch move.direction {
        case .north:
            currentPosition.y -= 1
        case .south:
            currentPosition.y += 1
        case .east:
            currentPosition.x += 1
        case .west:
            currentPosition.x -= 1
        case .nothing: break
        }
        
        
        /*
        if currentPosition.y > 5 {
            self.setSmell(smells[2], intensity: 0.75)
        } else if currentPosition.y <= 5 {
            self.setSmell(smells[3], intensity: 0.25)
        }
        
*/
        

        
        let origNpcType = self.currentNpcType
        
        let npc = move.theNpc
        
        self.currentNpcType = npc.npcType
        
        
        
        if self.currentNpcType == .nothing {
            npcView.image = move.theNpc.image
            npcView.frame = CGRect(x: currentPosition.x*tileDimension, y: currentPosition.y*tileDimension - tileDimension*3.0, width: tileDimension, height: tileDimension)
        }
        
        UIView.animate(withDuration: 0.85, delay: 0.0, options: [], animations: {
            
            playerView.frame = CGRect(x: currentPosition.x*tileDimension, y: currentPosition.y*tileDimension, width: tileDimension, height: tileDimension)
        }, completion: { (finished: Bool) in
            //self.isOpen = true
            
            
            synthesizer.stopSpeaking(at: .immediate)
            //let utterance = AVSpeechUtterance(string: "The three trolls line up in front of you, each looking guiltier than the next.")
            let utterance = AVSpeechUtterance(string: move.speechString)
            utterance.rate = 0.5
            synthesizer.speak(utterance)
            
            if self.currentNpcType != origNpcType {
                npcView.image = move.theNpc.image
                npcView.frame = CGRect(x: currentPosition.x*tileDimension, y: currentPosition.y*tileDimension - tileDimension*3.0, width: tileDimension, height: tileDimension)
                UIView.animate(withDuration: 0.85, delay: 0.0, options: [], animations: {
                    if move.theNpc.npcType != .nothing {
                        npcView.frame = CGRect(x: currentPosition.x*tileDimension, y: currentPosition.y*tileDimension - tileDimension, width: tileDimension, height: tileDimension)
                    }
                    
                    
                }, completion: { (finished: Bool) in
                    
                    
                })
            }
            

        })
        
        
        UIView.animate(withDuration: 0.75, delay: 0.25, options: [], animations: {
            
            let w = gameAreaView.frame.width
            let h = gameAreaView.frame.height
            gameAreaView.contentOffset = CGPoint(x: currentPosition.x*tileDimension - (w-tileDimension)/2.0, y: currentPosition.y*tileDimension - (h-tileDimension)/2.0)

        }, completion: { (finished: Bool) in
            //self.isOpen = true
        })
        
        
        
        //gameAreaView.contentOffset = .zero
        
        // Set smell and intensity
        
        
        setSmell()
        
        
        // Invisible skip button needs to stay on top
        self.view.bringSubview(toFront: skipButton)

    }
    
    func setSmell() {
        
        let origSmellType = self.currentSmellType
        
        let move = scriptMoves[moveIdx]
        let smell = move.theSmell
        
        self.currentSmellType = smell.theSmellType
                
        
        let intensity = smell.theIntensity
        

        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        smellMeterImageView.tintColor = smell.color
        
        


        percentLabel.text = "\(Int(intensity * 100))%"

        
        
        

        scentNameLabel.textColor = smell.color
        scentNameLabel.text = smell.name

        //label.backgroundColor = .yellow
        
        
        
        
        
        
        if fabs(intensity) < 0.001 {
            smellMeterImageView.alpha = 0.0
            scentNameLabel.alpha = 0.0
            percentLabel.alpha = 0.0
        }
        else {
            smellMeterImageView.alpha = 1.0
            scentNameLabel.alpha = 1.0
            percentLabel.alpha = 1.0
            
        }
        
        
        
        smellMeterImageView.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
        percentLabel.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
        UIView.animate(withDuration: Double(1.0 / intensity), delay: 0.0, options: .repeat, animations: {
            
            self.smellMeterImageView.transform = CGAffineTransform(scaleX: 0.25 + intensity*0.75, y: 0.25 + intensity*0.75)
            self.percentLabel.transform = CGAffineTransform(scaleX: 0.25 + intensity*0.75, y: 0.25 + intensity*0.75)
        }, completion: { (finished: Bool) in
            //self.isOpen = true
        })
        
        if origSmellType != smell.theSmellType {
            scentNameLabel.transform = CGAffineTransform(translationX: 1000.0, y: 0.0)
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                
                self.scentNameLabel.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
            }, completion: { (finished: Bool) in
                //self.isOpen = true
            })
        }
        


    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

