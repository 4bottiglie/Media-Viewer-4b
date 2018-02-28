//
//  MediaGalleryBarController.swift
//  Favid View 4b
//
//  Created by Sorin George Budescu on 17/02/18.
//  Copyright © 2018 Sorin George Budescu. All rights reserved.
//

import Cocoa
import BasicsMacKit4b

class MediaGalleryBarController: NSViewController
{
    @IBOutlet var rootView: NSView!
    
    private var rootViewHidder: ViewHidder!
    
    @IBOutlet var containerGallery: NSView!
    
    @IBOutlet weak var btn_unlockDirectory: NSButton!
    
    private var containerGalleryHidder: ViewHidder!
    
    private var mediaGallery: MediaGallery4b!
    
    public var onMediaItemSelected: ((_ itemSelected: MediaItem) -> ())?
    
    private var viewDidAppear = false
    
    private var lastPathRequired: String?
    private var lastSelectedImageRequired: String?
    
    private var _isVisible: Bool = true
    public var isVisible: Bool
    {
        get
        {
            return _isVisible
        }
        set(newVisibility)
        {
            self._isVisible = newVisibility
            
            if viewDidAppear
            {
                rootViewHidder.height.isVisible = newVisibility
            }
            
        }
    }
    
    private var _isExpanded: Bool = true
    public var isExpanded: Bool
    {
        get
        {
            return _isExpanded
        }
        set(newExpansion)
        {
            self._isExpanded = newExpansion
            
            if viewDidAppear
            {
                containerGalleryHidder.height.isVisible = newExpansion
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        containerGalleryHidder = ViewHidder(view: containerGallery)
        rootViewHidder = ViewHidder(view: rootView)
        
        rootViewHidder.height.addChild(containerGalleryHidder.height)
        
        viewDidAppear = true
        
        isVisible = _isVisible
        isExpanded = _isExpanded
    }
    
   
    
    
    ///Load media items at the directory path
    /// - param path: the path to load the directory
    /// - param selectingImageAtPath: the image to be selected or nil to not select any photo
    public func loadDirectory(path: String, selectingImageAtPath: String? = nil)
    {
        self.lastPathRequired = path
        self.lastSelectedImageRequired = selectingImageAtPath
        if let mediaItems = self.getMediaFromDirectiory(path: path)
        {
            self.btn_unlockDirectory.isHidden = true
            self.mediaGallery.view.isHidden = false
            self.mediaGallery.mediaItems = mediaItems
            
            if let selectedImage = selectingImageAtPath
            {
                let imagePath = URL(fileURLWithPath: selectedImage)
                
                if let imageIndex = mediaItems.index(where: { (mediaItem) -> Bool in
                    mediaItem.url == imagePath
                })
                {
                    self.mediaGallery.selectItem(atIndex: imageIndex)
                }
            }
            
        }else
        {
            self.btn_unlockDirectory.isHidden = false
            self.mediaGallery.view.isHidden = true
            self.mediaGallery.mediaItems = []
        }
        
        
    }
    
    
  
    
    @IBAction func onUnlockDirectoryButtonTap(_ sender: Any)
    {
        if lastPathRequired != nil
        {
            AppDelegate.shared.fileBookmarks.allowDirectory( URL(fileURLWithPath: lastPathRequired!, isDirectory: true), window: self.view.window!)
            {   isSuccess in
                
                if isSuccess
                {
                    self.loadDirectory(path: self.lastPathRequired!, selectingImageAtPath: self.lastSelectedImageRequired)
                }
            }
        }
        
    }
    
    
    
    /// Get all the media items from the directory
    /// - return a array of the items from the directory or nil if the permission is not granted or an error occured
    private func getMediaFromDirectiory(path: String) -> [FileMediaItem]?
    {
        let dirURL = URL(fileURLWithPath: path, isDirectory: true)
        var mediaItems = [FileMediaItem]()
        if FileManager.default.isDirectoryAndExists(atPath: path)
        {
            
            do
            {
                let filesPaths = try FileManager.default.contentsOfDirectory(atPath: path)
                
                for fileName in filesPaths
                {
                    let fileURL = dirURL.appendingPathComponent(fileName)
                    if let mediaItem = PhotoMediaItem(url: fileURL)
                    {
                        mediaItems.append(mediaItem)
                    }
                    
                }
                
                return mediaItems
            }catch
            {
                print(error.localizedDescription)
                
                return nil
            }
            
        }
        
        return nil
    }
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?)
    {
        if segue.identifier?.rawValue == "MediaGallerySegue"
        {
            mediaGallery = segue.destinationController as! MediaGallery4b
            
            onMediaGalleryLoaded(mediaGallery)
        }
    }
    
    ///method called when the media gallery view controller is loaded
    private func onMediaGalleryLoaded(_ mediaGallery: MediaGallery4b)
    {
        mediaGallery.onMediaItemSelected = { itemSelected in
            self.onMediaItemSelected?(itemSelected)
        }
    }
    
    
    @IBAction func onExpansionButtonClick(_ sender: Any)
    {
        self.isExpanded = !self._isExpanded
        
    }
    
    
    
}
