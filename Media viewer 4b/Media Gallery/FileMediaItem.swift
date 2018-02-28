//
//  FileMediaItem.swift
//  Media viewer 4b
//
//  Created by Sorin George Budescu on 20/02/18.
//  Copyright © 2018 Sorin George Budescu. All rights reserved.
//

import Foundation
import Cocoa

public protocol FileMediaItem: MediaItem
{
    var url: URL { get }
}


public class PhotoMediaItem: FileMediaItem, CustomStringConvertible
{
    public let url: URL
    public let preview: NSImage
    
    public var description: String
    {
        return "Image at URL: \(url)" 
    }
    
    public init?(url: URL)
    {
        guard FileManager.isImage(filePath: url.path)
        else{
            return nil
        }
        self.url = url
        self.preview = NSImage(byReferencing: url)
    }
}
