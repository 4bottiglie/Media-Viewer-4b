//
//  GalleryItemCellView.swift
//  Favid View 4b
//
//  Created by Sorin George Budescu on 16/02/18.
//  Copyright © 2018 Sorin George Budescu. All rights reserved.
//

import Cocoa
import BasicsMacKit4b

class GalleryItemCellView: NSCollectionViewItem {

    @IBOutlet weak var imgView: NSImageView!
    @IBOutlet weak var backgroundEffectView: NSVisualEffectView!
    
    public static let SELECTED_BORDER_COLOR = NSColor.parseColor("#00B4F0")!.withAlphaComponent(0.6).cgColor
    
    override var isSelected: Bool
    {
        didSet
        {
            if isSelected
            {
                self.backgroundEffectView.alphaValue = 1
                self.backgroundEffectView.layer!.borderWidth = 5
                
            }else
            {
                self.backgroundEffectView.alphaValue = 0.6
                self.backgroundEffectView.layer!.borderWidth = 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.backgroundEffectView.wantsLayer = true
        self.backgroundEffectView.alphaValue = 0.6
        self.backgroundEffectView.wantsLayer = true
        self.backgroundEffectView.layer!.borderColor = GalleryItemCellView.SELECTED_BORDER_COLOR
        self.backgroundEffectView.layer!.borderWidth = 0
    }
    
    public var image: NSImage?
    {
        get
        {
            return imgView.image
        }
        set(newImage)
        {
            self.imgView.image = newImage
        }
    }
    
    
   /* override func mouseDown(with event: NSEvent)
    {
        super.mouseDown(with: event)
        
        self.isSelected = !isSelected
        
        if isSelected
        {
            self.backgroundEffectView.layer?.backgroundColor = NSColor.red.cgColor
        }else
        {
            self.backgroundEffectView.layer?.backgroundColor = nil
        }
        
    }*/
    
    
    
}
