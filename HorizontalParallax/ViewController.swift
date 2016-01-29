//
//  ViewController.swift
//  HorizontalParallax
//
//  Created by Nattawut Singhchai on 1/29/16.
//  Copyright © 2016 Nattawut Singhchai. All rights reserved.
//

import UIKit

enum ThemeColor: String {
    case Black = "#000000"
    case Blue = "#0000ff"
    case White = "#ffffff"
    case Red = "#ff0000"
    case Green = "#00ff00"
    case IrisBlue = "#1e90ff"
    
    func color() -> UIColor {
        return UIColor(rgba: rawValue)
    }
    
    init?(rawColor:UIColor) {
        if let color = ThemeColor(rawValue: rawColor.hexString(false).lowercaseString) {
            self = color
        }else{
            return nil
        }
    }
}

class ParallaxConstraint: NSLayoutConstraint {
    @IBInspectable
    var defaultConstant: CGFloat = 0.0
    @IBInspectable
    var parallaxRatio:CGFloat = 1.0
}

class Cell: UICollectionViewCell {
    
    @IBOutlet weak var txtView: UITextView?
    
    @IBOutlet var horizontalConstraints: [ParallaxConstraint]?
    
    @IBOutlet var verticalConstraints: [ParallaxConstraint]?
    
    override func drawRect(rect: CGRect) {

        
        var tmpView:UIView? = self
        while let view = tmpView {
            if view.clipsToBounds {
                view.clipsToBounds = false
            }
            tmpView = view.superview
            if let _ = tmpView as? UICollectionView  {
                return
            }
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        if let horizontalConstraints = horizontalConstraints {
            for horizontalConstraint in horizontalConstraints {
                let constant = horizontalConstraint.defaultConstant
                horizontalConstraint.constant = constant
            }
        }
        
        if let verticalConstraints = verticalConstraints {
            for verticalConstraint in verticalConstraints {
                let constant = verticalConstraint.defaultConstant
                verticalConstraint.constant = constant
            }
        }
    }
    
    
    func didScroll(collectionView: UICollectionView) {
        
        let offsetX = collectionView.contentOffset.x - frame.minX
        let offsetY = collectionView.contentOffset.y - frame.minY
        
        
        if let horizontalConstraints = horizontalConstraints {
            for horizontalConstraint in horizontalConstraints {
                let constant = horizontalConstraint.defaultConstant + (-offsetX * horizontalConstraint.parallaxRatio)
                horizontalConstraint.constant = constant

            }
        }
        
        if let verticalConstraints = verticalConstraints {
            for verticalConstraint in verticalConstraints {
                let constant = verticalConstraint.defaultConstant + (-offsetY * verticalConstraint.parallaxRatio)
                verticalConstraint.constant = constant
            }
        }
        
    }
}

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        
         super.viewDidLoad()
        
        print(ThemeColor(rawColor: UIColor.blackColor()))
        print(ThemeColor(rawValue: "#ff0000"))
        
        let irisBlue = ThemeColor(rawColor: UIColor(rgba: "#1e90ff"))
        
        print(irisBlue)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait || UIDevice.currentDevice().orientation == UIDeviceOrientation.PortraitUpsideDown) {
            layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        }
        else{
            layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        }
        collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = (UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait || UIDevice.currentDevice().orientation == UIDeviceOrientation.PortraitUpsideDown) ? "reusableIdentifierV" : "reusableIdentifierH"

        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! Cell
        if let textView = cell.txtView {
            textView.backgroundColor = indexPath.row % 3 == 0 ? UIColor.redColor() : (indexPath.row % 3 == 1 ? UIColor.greenColor() : UIColor.yellowColor())
        }
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.frame.size
    }


    override func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let indexPaths  = collectionView?.indexPathsForVisibleItems() else{
            return
        }
        for indexPath in indexPaths {
            guard let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? Cell else {
                return
            }
            cell.didScroll(collectionView!)
        }
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        if ((toInterfaceOrientation == UIInterfaceOrientation.LandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientation.LandscapeRight)){
            layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        }
        else{
            layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        }
        
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView?.reloadData()
    }
    
    
}
