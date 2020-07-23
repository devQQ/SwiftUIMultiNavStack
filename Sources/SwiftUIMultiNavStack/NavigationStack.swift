//
//  NavigationStack.swift
//
//
//  Created by Q Trang on 7/20/20.
//

import SwiftUI

public class NavigationStack: ObservableObject {
    private struct ViewStack {
        private var views: [ViewElement] = []
        
        var count: Int { views.count }
        
        func root() -> ViewElement? {
            return views.first
        }
        
        func peek() -> ViewElement? {
            return views.last
        }
        
        func indexForView(with id: String) -> Int? {
            views.firstIndex { $0.id == id }
        }
        
        mutating func push(_ element: ViewElement) {
            let index = indexForView(with: element.id)
            
            if let index = index {
                views.remove(at: index)
            }
            
            views.append(element)
        }
        
        mutating func pop(to id: String? = nil) -> ViewElement? {
            guard let id = id else {
                return popToPrevious()
            }
            
            var element: ViewElement?
            
            while element == nil || element?.id != id {
                element = popToPrevious()
            }
            
            return element
        }
        
        mutating func popToPrevious() -> ViewElement? {
            guard views.count > 0 else {
                return nil
            }
            
            let element = views.removeLast()
            return element
        }
        
        mutating func popToRoot() -> ViewElement? {
            guard views.count > 0 else {
                return nil
            }
            
            let element = views.first
            views.removeAll()
            
            return element
        }
        
        mutating func removeAll() {
            views.removeAll()
        }
    }
    
    public init() {}
    
    private var viewStack = ViewStack()
    
    @Published public var cacheElement: ViewElement?
    
    public var currentElement: ViewElement? {
        viewStack.peek()
    }
    
    public var count: Int { return viewStack.count }
    
    public func push<Destination: View>(view: Destination, id: String = UUID().uuidString) {
        let element = ViewElement(id: id, element: UIHostingController(rootView: view))
        viewStack.push(element)
        
        cacheElement = element
    }
    
    public func popToView(withId id: String? = nil) -> ViewElement? {
        var element: ViewElement?
        
        while viewStack.peek() != nil &&
            viewStack.peek()?.id != id {
                element = pop()
        }
        
        return element
    }
    
    public func pop() -> ViewElement? {
        let element = viewStack.pop()
        cacheElement = element
        
        return element
    }
    
    public func popToRoot() {
        cacheElement = nil
        viewStack.removeAll()
    }
}

