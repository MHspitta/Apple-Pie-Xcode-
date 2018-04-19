//
//  ViewController.swift
//  Apple Pie
//
//  Created by Michael Hu on 18-04-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    // list of words to play with
    var listOfWords = ["banaan", "sendnudes", "lol", "mhspitta", "test", "kanibaal", "ijs", "zomer", "techno", "moon", "ezel", "rolex" , "apple"]
    
    // Max incorrect moves
    let incorrectMovesAllowed = 7
    
    // Variables win/lose
    var totalWins = 0 {
        
        // start new round if var is changed
        didSet {
            newRound()
        }
    }
    
    var totalLosses = 0 {
        didSet {
            newRound()
        }
    }
    
    // Tree Image
    @IBOutlet weak var treeImageView: UIImageView!
    
    //First label for correct word
    @IBOutlet weak var correctWordLabel: UILabel!
    
    //Second label for score
    @IBOutlet weak var scoreLabel: UILabel!
    
    //Collection of all buttons
    @IBOutlet var letterButtons: [UIButton]!
    
    //Actions for button that's being tapped
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        // disable the button after pressed
        sender.isEnabled = false
        
        // each button has a title in normal state
        let letterString = sender.title(for: .normal)!
        
        // Put the character lowercased in constant letter
        let letter = Character(letterString.lowercased())
        
        // the letter that's being pressed
        currentGame.playerGuessed(letter: letter)
        
        // update gamestate
        updateGameState()
    }
    
    // function game state
    func updateGameState() {
        
        // Check for game state, lose, win or still playing
        if currentGame.incorrectMovesRemaining == 0 {
        totalLosses += 1
        }
        else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
        }
        else {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRound()
    }
    
    // Struct game
    struct Game {
        
        // Properties
        var word: String
        var incorrectMovesRemaining: Int
        var guessedLetters: [Character]
        
        // Get the characters of formatted word
        var formattedWord: String {
            var guessedWord = ""
            
            // Iterate over word
            for letter in word.characters {
                
                // Check if letter pressed is in the words
                if guessedLetters.contains(letter) {
                    
                    // Add letter to guessed word
                    guessedWord += "\(letter)"
                }
                else {
                    guessedWord += "_"
                }
            }
            return guessedWord
        }

        // Retrieve the guessed letter
        mutating func playerGuessed(letter: Character) {
            
            // Append letter
            guessedLetters.append(letter)
            
            // Check if character is correct
            if !word.characters.contains(letter) {
                
                // decrement incorrectMovesRemaining
                incorrectMovesRemaining -= 1
            }
        }
    }
    
    // Variable Game
    var currentGame: Game!
    
    // Function to start new round
    func newRound () {
        
        // Check if list of words is empty
        if !listOfWords.isEmpty {
            
            // NewWord by removing the first one from list
            let newWord = listOfWords.removeFirst()
            
            // initilize instance(currentgame) for Game
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
            
            enableLetterButtons(true)
        
            //  update after each new games
            updateUI()
        }
        // If listOfWords is empty, disable all buttons
        else {
            enableLetterButtons(false)
        }
    }
    
    // Function to enable/disable all letter buttons
    func enableLetterButtons(_ enable: Bool) {
        
        // Iterate over all letter buttons
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    // Function update
    func updateUI() {
        
        var letters = [String]()
        
        // Append the correct letters to the currentGame/formatted word
        for letter in currentGame.formattedWord.characters {
            letters.append(String(letter))
        }
        
        // Word with spacing
        let wordWithSpacing = letters.joined(separator: " ")
        
        correctWordLabel.text = wordWithSpacing
        
        // Label which represents the score
        scoreLabel.text = "Wins: \(totalWins)  Losses: \(totalLosses)"
        
        // Tree image according to the remaining moves
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

