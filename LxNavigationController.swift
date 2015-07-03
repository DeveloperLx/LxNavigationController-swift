//
//  LxNavigationController.swift
//  LxNavigationControllerDemo
//
//  Created by DeveloperLx on 15/7/3.
//  Copyright (c) 2015年 DeveloperLx. All rights reserved.
//

import UIKit

enum LxNavigationControllerInteractionStopReason {
    
    case Finished, Cancelled, Failed
}

let POP_ANIMATION_DURATION = 0.2
let MIN_VALID_PROPORTION = 0.6

class PopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        
        return POP_ANIMATION_DURATION
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        transitionContext.containerView().insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        toViewController.view.frame.origin.x = -toViewController.view.frame.size.width/2
        toViewController.view.alpha = fromViewController.view.alpha - 0.2
        
        UIView.animateWithDuration(POP_ANIMATION_DURATION, animations: { () -> Void in
            
            fromViewController.view.frame.origin.x = fromViewController.view.frame.size.width
            toViewController.view.frame.origin.x = 0
            toViewController.view.alpha = 1
            
        }) { (finished) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

class LxNavigationController: UINavigationController, UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    
    var popGestureRecognizerEnable: Bool {
    
        set {
            _popGestureRecognizer.enabled = newValue
        }
        get {
            return _popGestureRecognizer.enabled
        }
    }
    
    var recognizeOtherGestureSimultaneously = false
    var isTranslating = false
    var popGestureRecognizerBeginCallBack = { () -> () in }
    var popGestureRecognizerStopBlock = { (stopReason: LxNavigationControllerInteractionStopReason) -> () in }
    
    var rootViewController: UIViewController? {
    
        return viewControllers.first as? UIViewController
    }
    
    let _popGestureRecognizer = UIPanGestureRecognizer()
    var _interactivePopTransition: UIPercentDrivenInteractiveTransition?
    
    convenience init () {
        self.init()
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        setup()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setup()
    }
    
    func setup() {
    
        delegate = self
                
        interactivePopGestureRecognizer.enabled = false
        
        _popGestureRecognizer.addTarget(self, action: Selector("popGestureRecognizerTriggerd:"))
        _popGestureRecognizer.delegate = self
        _popGestureRecognizer.cancelsTouchesInView = false
        _popGestureRecognizer.maximumNumberOfTouches = 1
        interactivePopGestureRecognizer.view?.addGestureRecognizer(_popGestureRecognizer)
    }
    
//  MARK:- UINavigationControllerDelegate
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is PopTransition {
            
            return _interactivePopTransition
        }
        else {
            return nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .Pop {
            return PopTransition()
        }
        else {
            return nil
        }
    }
    
    func popGestureRecognizerTriggerd(popPan: UIPanGestureRecognizer) {
    
        var progress = popPan.translationInView(popPan.view!).x / popPan.view!.bounds.size.width
        
        progress = max(0, progress)
        progress = min(1, progress)
        
        switch popPan.state {
        
        case .Began:
            isTranslating = true
            _interactivePopTransition = UIPercentDrivenInteractiveTransition()
            popViewControllerAnimated(true)
            self.popGestureRecognizerBeginCallBack()
    
        case .Changed:
            _interactivePopTransition?.updateInteractiveTransition(progress)
            
        case .Failed:
            isTranslating = false
            self.popGestureRecognizerStopBlock(.Failed)
            
        default:
            if progress > CGFloat(MIN_VALID_PROPORTION) {
                _interactivePopTransition?.finishInteractiveTransition()
                self.popGestureRecognizerStopBlock(.Finished)
            }
            else {
                _interactivePopTransition?.cancelInteractiveTransition()
                self.popGestureRecognizerStopBlock(.Cancelled)
            }
            _interactivePopTransition = nil
            isTranslating = false
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == _popGestureRecognizer {
        
            let location = gestureRecognizer.locationInView(gestureRecognizer.view)
            let translationX = _popGestureRecognizer.translationInView(gestureRecognizer.view!).x
            if location.x > gestureRecognizer.view!.frame.size.width * CGFloat(MIN_VALID_PROPORTION) || translationX < 0 || viewControllers.count < 2 {
                return false
            }
            else {
                return true
            }
        }
        else {
            return true
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == _popGestureRecognizer || otherGestureRecognizer == _popGestureRecognizer {
            return recognizeOtherGestureSimultaneously
        }
        else {
            return false
        }
    }
}
