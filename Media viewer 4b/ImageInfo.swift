//
//  ImageInfo.swift
//  Media viewer 4b
//
//  Created by Sorin George Budescu on 26/02/18.
//  Copyright © 2018 Sorin George Budescu. All rights reserved.
//

import Foundation
import BasicsMacKit4b
import ImageUtilsKit

public struct ImageInfo
{
    public let size: NSSize
    public let format: String
    public let creationDate: Date
    public let modifiedDate: Date
    
    public let metadata: IUKImageMetadata
}

public extension ImageInfo
{
    /// - return the image info from the path, of nil if not an image
    public static func fromPath(imagePath: String) -> ImageInfo?
    {
        if let imgSource = CGImageSource.fromURL(url: URL(fileURLWithPath: imagePath))
        {
            let metadata = IUKImageMetadata(source: imgSource)
            let properties = IUKImageProperties.from(source: imgSource)
            
        }
        
  
        return nil
    }
}
