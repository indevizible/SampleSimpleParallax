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
    
    func color() -> UIColor {
        return UIColor(rgba: rawValue)
    }
    
    init?(rawColor:UIColor) {
        if let color = ThemeColor(rawValue: rawColor.hexString(false)) {
            self = color
        }else{
            return nil
        }
    }
    
}

class Cell: UICollectionViewCell {
    
    private let parallaxRatio:CGFloat = -1.2
    private let parallaxRatioL2: CGFloat = -5.0
    
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]!
    
    @IBOutlet var horizontalConstraintsL2: [NSLayoutConstraint]!
    
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
        
        let offsetX = (collectionView.contentOffset.x - frame.minX)
        
        for horizontalConstraint in horizontalConstraints {
            horizontalConstraint.constant = offsetX * parallaxRatio
        }
        
        for horizontalConstraint in horizontalConstraintsL2 {
            horizontalConstraint.constant = offsetX * parallaxRatioL2
        }
    }
}

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        
        print(ThemeColor(rawColor: UIColor.blackColor()))
        print(ThemeColor(rawValue: "#ff0000"))
        
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
