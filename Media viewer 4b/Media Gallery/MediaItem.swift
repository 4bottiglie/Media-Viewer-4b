//
//  MediaItem.swift
//  Favid View 4b
//
//  Created by Sorin George Budescu on 15/02/18.
//  Copyright © 2018 Sorin George Budescu. All rights reserved.
//

import Foundation
import Cocoa


public protocol MediaItem
{
    var preview: NSImage { get }
}


extension NSImage: MediaItem
{
    public var preview: NSImage
    {
        return self
    }
}
