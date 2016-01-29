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
    
    @IBOutlet var horizontalConstraints: [ParallaxConstraint]?
    
    @IBOutlet var verticalConstraints: [ParallaxConstraint]?
    
    override func drawRect(rect: CGRect) {
        clipsToBounds = false
        contentView.clipsToBounds = false
        
        var tmpView:UIView? = self
        while let view = tmpView {
            if view.clipsToBounds {
                view.clipsToBounds = false
            }
            tmpView = view.superview
        }
    }
    
    func didScroll(collectionView: UICollectionView) {
        
        let offsetX = collectionView.contentOffset.x - frame.minX
        let offsetY = collectionView.contentOffset.y - frame.minY
        
        if let horizontalConstraints = horizontalConstraints {
            for horizontalConstraint in horizontalConstraints {
                horizontalConstraint.constant = horizontalConstraint.defaultConstant + (-offsetX * horizontalConstraint.parallaxRatio)
            }
        }
        
        if let verticalConstraints = verticalConstraints {
            for verticalConstraint in verticalConstraints {
                verticalConstraint.constant = verticalConstraint.defaultConstant + (-offsetY * verticalConstraint.parallaxRatio)
            }
        }
        
    }
}

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        
        print(ThemeColor(rawColor: UIColor.blackColor()))
        print(ThemeColor(rawValue: "#ff0000"))
        
        let irisBlue = ThemeColor(rawColor: UIColor(rgba: "#1e90ff"))
        
        print(irisBlue)
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("reusableIdentifier", forIndexPath: indexPath)
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
}
