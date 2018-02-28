//
//  MainWindowController.swift
//  Media viewer 4b
//
//  Created by Sorin George Budescu on 21/02/18.
//  Copyright © 2018 Sorin George Budescu. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSWindowDelegate
{
    public static let MAIN_WINDOW_FRAME_RECT_TAG = "MAIN_WINDOW_FRAME_RECT_TAG"

    override func windowDidLoad() {
        super.windowDidLoad()
    
        restoreFrameRect()
        
    }
    
    
    func windowDidResize(_ notification: Notification) {
        //print(self.window?.frame)
    }
    
    func windowWillClose(_ notification: Notification)
    {
        storeFrameRect()
    }
    
    ///Store the frame rect
    private func storeFrameRect()
    {
        let value = NSStringFromRect(self.window!.frame)
        
        UserDefaults.standard.set(value, forKey: MainWindowController.MAIN_WINDOW_FRAME_RECT_TAG)
    }
    
    ///Restore the frame rect, if stored before
    private func restoreFrameRect()
    {
        if let value = UserDefaults.standard.string(forKey: MainWindowController.MAIN_WINDOW_FRAME_RECT_TAG)
        {
            self.window!.setFrame(NSRectFromString(value), display: true)
            ///self.window?.setFrameFrom(value)
        }
    }
    

}
