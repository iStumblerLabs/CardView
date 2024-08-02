//
//  ViewController.swift
//  Deck
//
//  Created by Alf Watt on 7/28/24.
//

import Cocoa
import CardView

class CardController: NSViewController {
    @IBOutlet var cardView: CardTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
