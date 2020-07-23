//  NavigationController.swift
//
//
//  Created by Q Trang on 7/15/20.
//

import SwiftUI

public struct NavigationController<Content: View>: UIViewControllerRepresentable {
    public class Coordinator: NSObject, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
        let parent: NavigationController
        let stack: NavigationStack?
        
        public init (_ parent: NavigationController, stack: NavigationStack?) {
            self.parent = parent
            self.stack = stack
        }
        
        public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            if toVC != stack?.currentElement?.element {
                _ = stack?.pop()
            }
            
            return nil
        }
        
        @objc func handlePopGesture(_ gesture: UIGestureRecognizer) {
            guard gesture.state == .ended else {
                return
            }
            
            _ = stack?.pop()
        }
    }
    
    @EnvironmentObject private var stacks: NavigationStacks
    
    private let stackId: String?
    private var animated: Bool
    private var isTranslucent: Bool
    private var removeNavBarBottomLine: Bool
    private let content: Content
    
    private var stack: NavigationStack? {
        stacks.activeStack
    }
    
    public init(stackId: String? = nil, animated: Bool = true, isTranslucent: Bool = false, removeNavBarBottomLine: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.stackId = stackId
        self.animated = animated
        self.isTranslucent = isTranslucent
        self.removeNavBarBottomLine = removeNavBarBottomLine
        self.content = content()
    }
    
    public func makeUIViewController(context: Context) -> UINavigationController {
        let root = UIHostingController(rootView: self.content)
        
        let navController = UINavigationController(rootViewController: root)
        navController.navigationBar.isTranslucent = isTranslucent
        
        navController.interactivePopGestureRecognizer?.addTarget(context.coordinator, action: #selector(context.coordinator.handlePopGesture(_:)))
        navController.interactivePopGestureRecognizer?.delegate = nil
        navController.interactivePopGestureRecognizer?.isEnabled = true
        navController.delegate = context.coordinator
        
        if removeNavBarBottomLine {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowImage = UIImage()
            appearance.shadowColor = UIColor.clear
            appearance.backgroundImage = UIImage()
            
            navController.navigationBar.standardAppearance = appearance
            navController.navigationBar.scrollEdgeAppearance = appearance
        }
        
        return navController
    }
    
    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
        guard uiViewController.viewControllers.count > 1 ||
            (stack?.count ?? 0 > 0) else {
            return
        }
        
        guard let cacheElement = stack?.cacheElement,
            let currentElement = stack?.currentElement else {
                uiViewController.popToRootViewController(animated: animated)
                return
        }
        
        if cacheElement == currentElement {
            guard cacheElement.element != uiViewController.topViewController else {
                return
            }
            
            //This will hide the back button so it does not show up during push animation
            currentElement.element.navigationItem.hidesBackButton = true
            
            uiViewController.pushViewController(currentElement.element, animated: animated)
        } else {
            uiViewController.popToViewController(currentElement.element, animated: animated)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self, stack: stack)
    }
}

