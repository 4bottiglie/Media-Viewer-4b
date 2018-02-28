//
//  GImageView.swift
//  Favid View 4b
//
//  Created by Sorin George Budescu on 05/02/18.
//  Copyright © 2018 Sorin George Budescu. All rights reserved.
//

import Cocoa
import BasicsMacKit4b

class GImageView: NSView
{
    @IBOutlet var view: NSView!
    @IBOutlet weak var imgViewer: NSImageView!

    @IBOutlet weak var scrollView: ListenableScrollView!
    @IBOutlet weak var clipView: CenteringClipView!
    
    @IBOutlet weak var container_imgView: NSView!
    
    private var imgViewWidthConstraint: NSLayoutConstraint!
    private var imgViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageCell: NSImageCell!
    
    public var keepZoomCoefficientOnImageChange = true
    
    public var continueDraggingWithSpeed: Bool
    {
        get
        {
            return manualScrollHandler.continueDraggingWithSpeed
        }
        set(newValue)
        {
            self.manualScrollHandler.continueDraggingWithSpeed = newValue
        }
    }

    
    @IBOutlet weak var container_location: NSBox!
    @IBOutlet weak var lbl_locationY: NSTextField!
    @IBOutlet weak var lbl_locationX: NSTextField!
    
    
    public var continueZoomWithSpeed = true
    
    private var mouseTrakingArea: NSTrackingArea? = nil
    
     private var _zoomCoefficient: CGFloat = 1
    ///The zoom coefficient, 1-based = 100% of the image
    public var zoomCoefficient: CGFloat
    {
        get
        {
            return _zoomCoefficient
        }
        set(newZoomCoefficient)
        {
            _zoomCoefficient = newZoomCoefficient
            manualScrollHandler.zoomCoefficient = self.invertedZoomCoefficient
            updateZoom()
        }
    }
    
    /// A value to automatically change the zoom in and zoom out coefficient when a event occur, if negative will invert the zoom in/out with out/in
    /// this value should be 0 < x < 1, never 0 or 1
    public var zoomChangeCoefficient: CGFloat = 0.2
    
    private var lastZoomCoefficient: CGFloat = 1
    
    private var manualScrollHandler: ManualScrollHandler!
    
    //public var endZoomSize
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        commonInit()
    }
    
    
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        commonInit()
        
    }
    
    /// Common init of the view
    private func commonInit()
    {
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "GImageView"), owner: self, topLevelObjects: nil)
        
        self.addSubview(self.view)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: self.view, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        let width = imgViewer.image?.size.width ?? 0
        let height = imgViewer.image?.size.height ?? 0
        
        imgViewWidthConstraint = NSLayoutConstraint(item: imgViewer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        imgViewWidthConstraint.isActive = true
        
        imgViewHeightConstraint = NSLayoutConstraint(item: imgViewer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        imgViewHeightConstraint.isActive = true
        
        
        self.scrollView.wantsLayer = true
        self.scrollView.layer!.backgroundColor = NSColor.blue.cgColor
        
        self.scrollView.onWheelScrolled = { event in
            self.handleWheelScroll(event: event)
            
            return true
        }
        
        imgViewer.unregisterDraggedTypes()
        scrollView.unregisterDraggedTypes()
        clipView.unregisterDraggedTypes()
        view.unregisterDraggedTypes()
        
        self.registerForDraggedTypes([.fileURL])
        
        manualScrollHandler = ManualScrollHandler(handledView: clipView)
        
    }
    
    ///Handle the scroll view wheel scroll
    func handleWheelScroll(event: NSEvent)
    {
        let  center = convertToLocalPoint(fullWindowPoint: event.locationInWindow)
        //let center = event.locationInWindow
        
        DispatchQueue.main.async
        {
            if event.deltaY > 0
            {
                self.zoomCoefficient /= ( 1 - self.zoomChangeCoefficient )
                self.updateZoom(centerPoint: center, animated: true)
            }else if event.deltaY < 0
            {
                self.zoomCoefficient *= ( 1 - self.zoomChangeCoefficient )
                self.updateZoom(centerPoint: center, animated: true)
            }
        }
        
        
        
        
    }
    
    
    
    
    
    override func mouseDown(with event: NSEvent)
    {
        super.mouseDown(with: event)
        manualScrollHandler.mouseDown(with: event)
    }
    
    
    override func mouseUp(with event: NSEvent)
    {
        super.mouseUp(with: event)
        
        manualScrollHandler.mouseUp(with: event)
        
        
    }
    

    
    
    override func mouseDragged(with event: NSEvent)
    {
        manualScrollHandler.mouseDragged(with: event)
    }
    
    
    
    override func rightMouseUp(with event: NSEvent)
    {
        super.rightMouseUp(with: event)
    }
    
    
   
    
    
    ///Update the zoom basing on the coefficient
    /// - param centerPoint: the point into the view to preserve the location, will automatically be converted into the image location
    private func updateZoom(centerPoint: CGPoint = CGPoint.zero, animated: Bool = true)
    {
        checkCoefficient()
        
        let invertedZoomCoefficient = self.invertedZoomCoefficient
        
        let newWidth = clipView.frame.width * invertedZoomCoefficient
        let newHeight = clipView.frame.height * invertedZoomCoefficient
        
        
        let percentX = centerPoint.x / clipView.frame.width
        let percentY = centerPoint.y / clipView.frame.height
        
        let widthOffset = (clipView.bounds.width - newWidth) * percentX
        let heightOffset = (clipView.bounds.height - newHeight) * percentY
        
        
        let newMinX = clipView.bounds.minX + widthOffset
        
        let newMinY = clipView.bounds.minY + heightOffset
        
        let newBounds = CGRect(x: newMinX , y: newMinY, width: newWidth, height: newHeight)
        
        if animated
        {
            NSAnimationContext.runAnimationGroup({ (context) in
                clipView.animator().bounds = newBounds
                
            }) {/*onfinish*/}
        }else
        {
            clipView.bounds = newBounds
        }
        
        
        lastZoomCoefficient = invertedZoomCoefficient
       
    }
    
    ///The inverted zoom coefficient, used to zoom the view
    private var invertedZoomCoefficient: CGFloat
    {
        return 1.0 / _zoomCoefficient
    }
    
    ///Check the coefficient and normalize it
    private func checkCoefficient()
    {
        if _zoomCoefficient <= 0.01
        {
            _zoomCoefficient = 0.01
        }else if _zoomCoefficient > 10
        {
            _zoomCoefficient = 10
        }
    }
    
    
  
    
    /// Convert the view point into a image point
    /// The point will be calculate basing on the origin, the x and the y position may result negative
    public func toImagePoint(viewPoint: CGPoint) -> CGPoint
    {
        let rect = self.clipView.documentRect
        let visibleRect = self.clipView.visibleRect
        
        let x = rect.minX + abs(visibleRect.minX - rect.minX) + viewPoint.x
        let y = rect.minY + abs(visibleRect.minY - rect.minY) + viewPoint.y
        
        return CGPoint(x: x, y: y)
    }
    
    
    /// Convert the view point into a image point
    /// The point will be calculate basing on the origin, the x and the y position may result negative
    public func toVisibleRectPoint(viewPoint: CGPoint) -> CGPoint
    {
        let visibleRect = self.clipView.visibleRect
        
        return CGPoint(x: visibleRect.minX + viewPoint.x, y: visibleRect.minY + viewPoint.y)
    }
    
    /// Convert the view point into a image point
    /// The point will basing on the origin 0,0 bottom/left and the x and the y will be always positive
    public func toAbsoluteImagePoint(viewPoint: CGPoint) -> CGPoint
    {
        let rect = self.clipView.documentRect
        let visibleRect = self.clipView.visibleRect
        
        let x = abs(visibleRect.minX - rect.minX) + viewPoint.x
        let y = abs(visibleRect.minY - rect.minY) + viewPoint.y
        
        return CGPoint(x: x, y: y)
    }
    
    
    
    ///Zoom in with the zoom coefficient
    public func zoomIn(centerPoint: CGPoint = CGPoint.zero, animated: Bool = true)
    {
        //zoom(coefficient: 0.5, centerPoint: centerPoint, animated: animated)
    }
    
  
   
    ///Zoom out with the zoom coefficient
    ///- param coefficient: the percent to zoom out, if negative will zoom in
    public func zoomOut(centerPoint: CGPoint = CGPoint.zero, animated: Bool = true)
    {
        //zoom(coefficient: -0.5, centerPoint: centerPoint, animated: animated)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation
    {
        if checkExtension(sender)
        {
            return NSDragOperation.copy
        }
        
        return NSDragOperation()
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteBoard = sender.draggingPasteboard().propertyList(forType:  NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = pasteBoard[0] as? String
        else
        {
            return false
        }
        
        if FileManager.default.isFileAndExists(atPath: path)
        {
            self.image = NSImage(byReferencingFile: path)
        }else if FileManager.default.isDirectoryAndExists(atPath: path)
        {
            print("Dir requested:\(path)")
            //TODO load directory
        }
        
        
        return true
    }
    
    ///Check the extension of the sender file
    /// - return true if is a valid extension, false if not
    private func checkExtension(_ sender: NSDraggingInfo) -> Bool
    {
        guard   let board = sender.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType("NSFilenamesPboardType")) as? NSArray,
                let path = board[0] as? String
        else
        {
            return false
        }
        
        if FileManager.default.isDirectoryAndExists(atPath: path)
        {
            return true
        }
        
        let fileExtension = URL(fileURLWithPath: path).pathExtension
        return NSImageViewUtils.ImageFormat(rawValue: fileExtension.lowercased()) != nil
    }
    
    private var _image: NSImage? = nil
    public var image: NSImage?
    {
        get
        {
            return _image
        }
        set(newImage)
        {
            self._image = newImage
            
            
            imgViewer.image = newImage
            
            if keepZoomCoefficientOnImageChange
            {
                self.lastZoomCoefficient = self.zoomCoefficient
                resetImagesDimensions(animated: true)
            }else
            {
                resetImagesDimensions(animated: false)
                zoomToFit()
                //resetZoom()
            }
            
            
        }
    }

    
    ///Reset the images dimensions
    private func resetImagesDimensions(animated: Bool = true)
    {
        if let image = imgViewer.image
        {
            let newBounds = CGRect(x: 0 , y: 0, width: clipView.frame.width, height: clipView.frame.height)
            
            if animated
            {
                NSAnimationContext.runAnimationGroup({ (context) in
                    clipView.animator().bounds = newBounds
                    
                    imgViewWidthConstraint.animator().constant = image.size.width
                    imgViewHeightConstraint.animator().constant = image.size.height
                    
                }) {/*onfinish*/}
            }else
            {
                clipView.bounds = newBounds
                
                imgViewWidthConstraint.constant = image.size.width
                imgViewHeightConstraint.constant = image.size.height
            }
        }
    }
    
    /// Reset the zoom to the original scale
    public func resetZoom(animated: Bool = true)
    {
        self.zoomCoefficient = 1
        self.lastZoomCoefficient = 1
        
        resetImagesDimensions(animated: animated)
    }
    
    ///Zoom the image to fit the current visible frame
    public func zoomToFit(animated: Bool = true)
    {
        if let image = self.image
        {
            let newZoomX = clipView.frame.width / image.size.width
            let newZoomY = clipView.frame.height / image.size.height
            
            let newZoom = min(newZoomX, newZoomY)
            
            self.lastZoomCoefficient = newZoom
            self.zoomCoefficient = newZoom
        }else
        {
            self.zoomCoefficient = 1
            self.lastZoomCoefficient = 1
        }
        
        
    }
    

    
    override func viewWillMove(toWindow newWindow: NSWindow?)
    {
        updateMouseLocationTraker()
    }
    
    override func updateTrackingAreas()
    {
        updateMouseLocationTraker()
    }
    
    ///Update the mouse location traker
    private func updateMouseLocationTraker()
    {
        if let traker = mouseTrakingArea
        {
            self.removeTrackingArea(traker)
        }
        
        mouseTrakingArea = NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways, .mouseMoved], owner: self, userInfo: nil)
        
        self.addTrackingArea(mouseTrakingArea!)
    }
    
    override func mouseMoved(with event: NSEvent)
    {
        super.mouseMoved(with: event)
        
        let point = convertToLocalPoint(fullWindowPoint: event.locationInWindow)
        //let point = NSPoint(x: self.bounds.size.width,y: self.bounds.size.height)
        setLocation(point)
    }
    
    /// Set the x and y location
    private func setLocation(_ point: NSPoint)
    {
        lbl_locationX.stringValue = "X: \(Int(point.x))"
        lbl_locationY.stringValue = "Y: \(Int(point.y))"
    }
  
    
}
