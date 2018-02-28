//
//  NSImageViewUtils.swift
//  Favid View 4b
//
//  Created by Sorin George Budescu on 09/02/18.
//  Copyright © 2018 Sorin George Budescu. All rights reserved.
//

import Foundation


public struct NSImageViewUtils
{
    private init(){}
    
    public enum ImageFormat: String
    {
        /// TIFF
        case tiff = "tiff"
        case tif = "tif"
        
        /// JPEG
        case jpeg = "jpeg"
        case jpg = "jpg"
        case jfif = "jfif"
        case jpe = "jpe"
        case jif = "jif"
        case jfi = "jfi"
        
        
        /// JPEG 2000
        case jp2 = "jp2"
        case j2k = "j2k"
        case jpf = "jpf"
        case jpx = "jpx"
        case j2c = "j2c"
        case jpm = "jpm"
        case jpc = "jpc"
        
        /// QuickTime Image
        case qtif = "qtif"
        case qti = "qti"
        case qif = "qif"
        
        case pict = "pict"
        case pct = "pct"
        case pic = "pic"

        case gif = "gif"
        case png = "png"
        case pdf = "pdf"
        
        case psd = "psd"
        
        case icns = "icns"
        
        /// BMP
        case bmp = "bmp"
        case dib = "dib"
        case rle = "rle"
        case _2bp = "2bp"
        
        /// ICO
        case ico = "ico"
        case cur = "cur"
    }
    
}
