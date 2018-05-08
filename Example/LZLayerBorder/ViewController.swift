//
//  ViewController.swift
//  LZLayerBorder
//
//  Created by lizhaobomb on 05/07/2018.
//  Copyright (c) 2018 lizhaobomb. All rights reserved.
//

import UIKit
import LZLayerBorder

class ViewController: UIViewController {

    @IBOutlet weak var demoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func removeAll(_ sender: Any) {
        demoView.lz_removeAllBorders()
    }
    
    @IBAction func bottom(_ sender: UIButton) {
        demoView.lz_addBorderWith(insets: .zero, borderColor: sender.backgroundColor!, borderWidth: 1, directions: .bottom)
    }
    
    @IBAction func right(_ sender: UIButton) {
        demoView.lz_addBorderWith(insets: .zero, borderColor: sender.backgroundColor!, borderWidth: 1.5, directions: .right)
    }
    
    @IBAction func top(_ sender: UIButton) {
        demoView.lz_addBorderWith(insets: .zero, borderColor: sender.backgroundColor!, borderWidth: 0.5, directions: .top)
    }
    
    @IBAction func left(_ sender: UIButton) {
        demoView.lz_addBorderWith(insets: .zero, borderColor: sender.backgroundColor!, borderWidth: 2, directions: .left)
    }
}

