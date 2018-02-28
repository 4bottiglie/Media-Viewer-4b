//
//  InfoImageBarViewController.swift
//  Media viewer 4b
//
//  Created by Sorin George Budescu on 26/02/18.
//  Copyright © 2018 Sorin George Budescu. All rights reserved.
//

import Cocoa

class InfoImageBarViewController: NSViewController
{
    @IBOutlet weak var lbl_size: NSTextField!
    @IBOutlet weak var lbl_format: NSTextField!
    @IBOutlet weak var lbl_creationDate: NSTextField!
    @IBOutlet weak var lbl_modified_date: NSTextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear()
    {
        
    }
    
    
    @IBAction func onInfoButtonClick(_ sender: Any)
    {
        
    }
    
    
    
    
}
