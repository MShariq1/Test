//
//  BSLoader.swift
//  Brainstorage
//
//  Created by Kirill Kunst on 07.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics

let loaderSpinnerMarginSide : CGFloat = 35.0
let loaderSpinnerMarginTop : CGFloat = 20.0
let loaderTitleMargin : CGFloat = 5.0

public class SwiftLoader: UIView {
    
    var coverView : UIView?
    var titleLabel : UILabel?
    var loadingView : SwiftLoadingView?
    var animated : Bool = true
    var canUpdated = false
    var title: String?
    var isHidable = true
    
    var config : Config = Config() {
        didSet {
            self.loadingView?.config = config
        }
    }
    
    var loaderArray: [SwiftLoader] = []
    
    override public var frame : CGRect {
        didSet {
            self.update()
        }
    }
    
    class var sharedInstance: SwiftLoader {
        struct Singleton {
            static let instance = SwiftLoader(frame: CGRect(x:0, y:0, width:Config().size, height:Config().size))
        }
        return Singleton.instance
    }
    
    public class func show(animated: Bool) {
        self.show(title: nil, animated: animated)
    }
    
    public class func show(title: String?, animated : Bool) {
        
        let currentWindow : UIWindow = UIApplication.shared.keyWindow ?? UIWindow()
        
        let loader = SwiftLoader.sharedInstance
        loader.canUpdated = true
        loader.animated = animated
        loader.title = title
        loader.update()
        
        let height : CGFloat = UIScreen.main.bounds.size.height
        let width : CGFloat = UIScreen.main.bounds.size.width
        let center : CGPoint = CGPoint(x: width/2.0, y: height/2.0)
        
        loader.center = center
        
        if (loader.superview == nil) {
            let frame = CGRect(x: currentWindow.frame.minX, y: currentWindow.frame.minY, width: currentWindow.frame.width, height: currentWindow.frame.height-100)
            loader.coverView = UIView(frame: currentWindow.bounds)
            loader.coverView?.backgroundColor = loader.config.foregroundColor.withAlphaComponent(loader.config.foregroundAlpha)
            
            currentWindow.addSubview(loader.coverView!)
            currentWindow.addSubview(loader)
            loader.start()
            
         //   SwiftLoader.sharedInstance.loaderArray.append(loader)
        }
    }
    
    
    public class func hide() {
        let loader = SwiftLoader.sharedInstance
        
        loader.stop()
      //  loader.loaderArray.first?.stop()
      //  loader.loaderArray.removeFirst()
    }
    
    public class func setConfig(config : Config) {
        let loader = SwiftLoader.sharedInstance
        loader.config = config
        loader.frame = CGRect(x:0, y:0, width:loader.config.size, height:loader.config.size)
        
    }
    
    /**
     Private methods
     */
    
    private func setup() {
        self.alpha = 0
        self.update()
    }
    
    private func start() {
        self.loadingView?.start()
        
        if (self.animated) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 1
            }, completion: { (finished) -> Void in
                
            });
        } else {
            self.alpha = 1
        }
    }
    
    func stop() {
        
        if (self.animated) {
            UIView.animate(withDuration: 0.0, animations: { () -> Void in
                self.alpha = 0
            }, completion: { (finished) -> Void in
                self.removeFromSuperview()
                self.coverView?.removeFromSuperview()
                self.loadingView?.stop()
            });
        } else {
            self.alpha = 0
            self.removeFromSuperview()
            self.coverView?.removeFromSuperview()
            self.loadingView?.stop()
        }
    }
    
    private func update() {
        self.backgroundColor = self.config.backgroundColor
        self.layer.cornerRadius = self.config.cornerRadius
        let loadingViewSize = self.frame.size.width - (loaderSpinnerMarginSide * 2)
        
        if (self.loadingView == nil) {
            self.loadingView = SwiftLoadingView(frame: self.frameForSpinner())
            self.addSubview(self.loadingView!)
        } else {
            self.loadingView?.frame = self.frameForSpinner()
        }
        
        if (self.titleLabel == nil) {
            let frame = CGRect(x: loaderTitleMargin, y: loaderSpinnerMarginTop + loadingViewSize, width: self.frame.width - loaderTitleMargin*2, height: 42.0)
            
            self.titleLabel = UILabel(frame: frame)
            self.addSubview(self.titleLabel!)
            self.titleLabel?.numberOfLines = 1
            self.titleLabel?.textAlignment = NSTextAlignment.center
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        } else {
            self.titleLabel?.frame = CGRect(x:loaderTitleMargin, y:loaderSpinnerMarginTop + loadingViewSize, width:self.frame.width - loaderTitleMargin*2, height:42.0)
        }
        
        self.titleLabel?.font = self.config.titleTextFont
        self.titleLabel?.textColor = self.config.titleTextColor
        self.titleLabel?.text = self.title
        
        self.titleLabel?.isHidden = self.title == nil
    }
    
    func frameForSpinner() -> CGRect {
        let loadingViewSize = self.frame.size.width - (loaderSpinnerMarginSide * 2)
        
        if (self.title == nil) {
            let yOffset = (self.frame.size.height - loadingViewSize) / 2
            return CGRect(x:loaderSpinnerMarginSide, y:yOffset, width:loadingViewSize, height:loadingViewSize)
        }
        return CGRect(x:loaderSpinnerMarginSide, y:loaderSpinnerMarginTop, width:loadingViewSize, height:loadingViewSize)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     *  Loader View
     */
    class SwiftLoadingView : UIView {
        
        var lineWidth : Float?
        var lineTintColor : UIColor?
        var backgroundLayer : CAShapeLayer?
        var isSpinning : Bool?
        
        var config : Config = Config() {
            didSet {
                self.update()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        /**
         Setup loading view
         */
        
        private func setup() {
            self.backgroundColor = UIColor.clear
            self.lineWidth = fmaxf(Float(self.frame.size.width) * 0.025, 1)
            self.lineWidth = 3.0
            
            self.backgroundLayer = CAShapeLayer()
            self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
            self.backgroundLayer?.fillColor = self.backgroundColor?.cgColor
            self.backgroundLayer?.lineCap = CAShapeLayerLineCap.round
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            self.layer.addSublayer(self.backgroundLayer!)
        }
        
        private func update() {
            self.lineWidth = self.config.spinnerLineWidth
            
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
        }
        
        /**
         Draw Circle
         */
        
        override func draw(_ rect: CGRect) {
            self.backgroundLayer?.frame = self.bounds
        }
        
        private func drawBackgroundCircle(partial : Bool) {
            let startAngle : CGFloat = CGFloat(Double.pi) / CGFloat(2.0)
            var endAngle : CGFloat = (2.0 * CGFloat(Double.pi)) + startAngle
            
            let center : CGPoint = CGPoint(x:self.bounds.size.width / 2, y:self.bounds.size.height / 2)
            let radius : CGFloat = (CGFloat(self.bounds.size.width) - CGFloat(self.lineWidth!)) / CGFloat(2.0)
            
            let processBackgroundPath : UIBezierPath = UIBezierPath()
            processBackgroundPath.lineWidth = CGFloat(self.lineWidth!)
            
            if (partial) {
                endAngle = (1.8 * CGFloat(Double.pi)) + startAngle
            }
            
            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            self.backgroundLayer?.path = processBackgroundPath.cgPath;
        }
        
        /**
         Start and stop spinning
         */
        
        func start() {
            self.isSpinning? = true
            self.drawBackgroundCircle(partial: true)
            
            let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = NSNumber(value: .pi * 2.0)
            rotationAnimation.duration = 1;
            rotationAnimation.isCumulative = true;
            rotationAnimation.repeatCount = HUGE;
            self.backgroundLayer?.add(rotationAnimation, forKey: "rotationAnimation")
        }
        
        func stop() {
            self.drawBackgroundCircle(partial: false)
            
            self.backgroundLayer?.removeAllAnimations()
            self.isSpinning? = false
        }
    }
    
    
    /**
     * Loader config
     */
    public struct Config {
        
        /**
         *  Size of loader
         */
        public var size : CGFloat = 100
        
        /**
         *  Color of spinner view
         */
        public var spinnerColor = UIColor.blue //colorFromHex("D3D3D3")//AppLightGray
        
        /**
         *  S
         */
        public var spinnerLineWidth :Float = 5.0
        
        /**
         *  Color of title text
         */
        public var titleTextColor = UIColor.black
        
        /**
         *  Font for title text in loader
         */
        public var titleTextFont : UIFont = UIFont.boldSystemFont(ofSize: 16.0)
        
        /**
         *  Background color for loader
         */
        public var backgroundColor = UIColor.clear
        
        /**
         *  Foreground color
         */
        public var foregroundColor = UIColor.clear
        
        /**
         *  Foreground alpha CGFloat, between 0.0 and 1.0
         */
        public var foregroundAlpha:CGFloat = 0.0
        
        /**
         *  Corner radius for loader
         */
        public var cornerRadius : CGFloat = 50.0
        
        public init() {}
        
    }
}


class LoadingButton: UIButton {
private var originalButtonText: String?
var activityIndicator: UIActivityIndicatorView!

func showLoading() {
//    originalButtonText = self.titleLabel?.text
//    self.setTitle("", for: .normal)
    
    if (activityIndicator == nil) {
        activityIndicator = createActivityIndicator()
    }
    
    showSpinning()
}

func hideLoading() {
    self.setTitle(originalButtonText, for: .normal)
    activityIndicator.stopAnimating()
}

private func createActivityIndicator() -> UIActivityIndicatorView {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    activityIndicator.color = .white
    return activityIndicator
}

private func showSpinning() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(activityIndicator)
    centerActivityIndicatorInButton()
    activityIndicator.startAnimating()
}

private func centerActivityIndicatorInButton() {
    let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 0.7, constant: 0)
    self.addConstraint(xCenterConstraint)
    
    let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
    self.addConstraint(yCenterConstraint)
}
}


func showUniversalLoadingView(_ show: Bool, loadingText : String = "") {
    let existingView = UIApplication.shared.windows[0].viewWithTag(1200)
    if show {
        if existingView != nil {
            return
        }
        let loadingView = makeLoadingView(withFrame: UIScreen.main.bounds, loadingText: loadingText)
        loadingView?.tag = 1200
        UIApplication.shared.windows[0].addSubview(loadingView!)
    } else {
        existingView?.removeFromSuperview()
    }

}



func makeLoadingView(withFrame frame: CGRect, loadingText text: String?) -> UIView? {
    let loadingView = UIView(frame: frame)
    loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    //activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
    activityIndicator.layer.cornerRadius = 6
    activityIndicator.center = loadingView.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.style = .white
    activityIndicator.startAnimating()
    activityIndicator.tag = 100 // 100 for example

    loadingView.addSubview(activityIndicator)
    if !text!.isEmpty {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        let cpoint = CGPoint(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width / 2, y: activityIndicator.frame.origin.y + 80)
        lbl.center = cpoint
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.text = text
        lbl.tag = 1234
        loadingView.addSubview(lbl)
    }
    return loadingView
}
