//
//  LeftPanelViewController.swift
//  Favid View 4b
//
//  Created by Sorin George Budescu on 09/02/18.
//  Copyright © 2018 Sorin George Budescu. All rights reserved.
//

import Cocoa

class LeftPanelViewController: NSViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer!.backgroundColor = NSColor.parseColor("#3B3B3B")?.cgColor
    }
    
}
