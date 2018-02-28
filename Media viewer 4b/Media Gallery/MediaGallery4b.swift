//
//  MediaGallery4b.swift
//  Favid View 4b
//
//  Created by Sorin George Budescu on 15/02/18.
//  Copyright © 2018 Sorin George Budescu. All rights reserved.
//

import Cocoa
import BasicsMacKit4b

class MediaGallery4b: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegate
{
    
    @IBOutlet weak var scrollCollectionView: NSScrollView!
    @IBOutlet weak var collectionClipView: NSClipView!

    @IBOutlet weak var collectionView: ListenableCollectionView!
    
    public var mouseDraggedFlag = false
    
    public var onMediaItemSelected: ((_ itemSelected: MediaItem) -> ())?
    
    private var _mediaItems = [MediaItem]()
    ///The media items
    public var mediaItems: [MediaItem]
    {
        get
        {
            return _mediaItems
        }
        set(newMediaItems)
        {
            self._mediaItems = newMediaItems
            self.collectionView.reloadData()
        }
    }

    private var manualScrollHandler: ManualScrollHandler!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
        manualScrollHandler = ManualScrollHandler(handledView: collectionClipView)
        
        collectionView.onMouseDown = { event in
            
            self.manualScrollHandler.mouseDown(with: event)
            
            self.mouseDraggedFlag = false
            
            return false
        }
        
        collectionView.onMouseUp = { event in
            
            self.manualScrollHandler.mouseUp(with: event)
            
            self.mouseDraggedFlag = false
            
            return false
        }
        
        collectionView.onMouseDragged = { event in
            
            self.manualScrollHandler.mouseDragged(with: event)
            
            self.mouseDraggedFlag = true
            
            return false
        }
        
    }
    
    override func mouseDown(with event: NSEvent) {
        manualScrollHandler.mouseDown(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        manualScrollHandler.mouseUp(with: event)
    }
    
    override func mouseDragged(with event: NSEvent) {
        manualScrollHandler.mouseDragged(with: event)
    }
    
    
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem
    {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GalleryItemCellView"), for: indexPath)
        
        guard let collectionViewItem = item as? GalleryItemCellView
        else {
            return item
        }
        collectionViewItem.image = mediaItems[indexPath.item].preview
        
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>)
    {
        collectionView.deselectAll(self)
        if !self.mouseDraggedFlag
        {
            let index = indexPaths.first!.item
            selectItem(atIndex: index)
            onMediaItemSelected?(mediaItems[index])
            
        }
        
    }
    
    /// Select the item
    public func selectItem(atIndex index: Int)
    {
        let indexPath = IndexPath(item: index, section: 0)
        
        collectionView.selectItems(at: Set(arrayLiteral: indexPath), scrollPosition: .bottom)
        let item = mediaItems[index]
        self.view.window!.title = (item as? FileMediaItem)?.url.lastPathComponent ?? ""
    }
    
    
    
    
    
    
    
}
