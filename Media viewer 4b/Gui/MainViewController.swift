//
//  ViewController.swift
//  Favid View 4b
//
//  Created by Sorin George Budescu on 02/02/18.
//  Copyright © 2018 Sorin George Budescu. All rights reserved.
//

import Foundation
import Cocoa
import Quartz
import AppKit

class MainViewController: NSViewController
{
    
    @IBOutlet weak var imgView_main: GImageView!
    
    private var canChangeZoom = true
    
    private var mediaBarGallery: MediaGalleryBarController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
   
    
    //didres
    
    public var image: NSImage?
    {
        get
        {
            return imgView_main.image
        }
        set(newImage)
        {
            imgView_main.image = newImage
        }
    }
    
    ///Set the image from the path and load the other images from the same directory
    public func setImage(fromPath path: String)
    {
        DispatchQueue.main.async
        {
            self.mediaBarGallery.loadDirectory(path: URL(fileURLWithPath: path).deletingLastPathComponent().path, selectingImageAtPath: path)
            self.imgView_main.image = NSImage(byReferencingFile: path)
            
            let properties = ImageInfo.fromPath(imagePath: path)
        }
        
        
        mediaBarGallery.isVisible = true
    }
    
    
    

    override func prepare(for segue: NSStoryboardSegue, sender: Any?)
    {
        if segue.identifier?.rawValue == "MediaGalleryBarSegue"
        {
            mediaBarGallery = segue.destinationController as! MediaGalleryBarController
            setupMediaBarGallery()
        }
    }
    
    private func setupMediaBarGallery()
    {
        mediaBarGallery.onMediaItemSelected = { itemSelected in
            self.image = itemSelected.preview
        }
        
        mediaBarGallery.isVisible = false
    }
    
}

