//
//  AppDelegate.swift
//  Favid View 4b
//
//  Created by Sorin George Budescu on 02/02/18.
//  Copyright © 2018 Sorin George Budescu. All rights reserved.
//

import Cocoa
import BasicsMacKit4b

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    
    public static var shared: AppDelegate
    {
        return NSApplication.shared.delegate as! AppDelegate
    }
    
    public let fileBookmarks = BookmarksManager(fileName: "Favid4bBookmarks.dic")

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        fileBookmarks.load()
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func application(_ sender: NSApplication, openFile filename: String) -> Bool
    {
        //print(sender.mainWindow?.frame)
        DispatchQueue.main.async
        {
            self.mainViewController?.setImage(fromPath: filename)
        }
        
        
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    public var mainViewController: MainViewController?
    {
        return NSApplication.shared.mainWindow?.windowController?.contentViewController as? MainViewController
    }
    
    /*func application(_ sender: NSApplication, openFiles filenames: [String]) {
        print(filenames)
    }*/

}

