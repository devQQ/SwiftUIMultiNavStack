//
//  NavigationStacks.swift
//
//
//  Created by Quang Trang on 7/22/20.
//

import SwiftUI
import SwiftUIToolbox

public let ROOT_STACK = "RootStack"

public class NavigationStacks: ObservableObject {
    @Published var stacks: [String: NavigationStack] = [:]
    var activeStack: NavigationStack?
    
    var cancelBag = CancelBag()
    
    public init(_ root: NavigationStack) {
        self.stacks = [ROOT_STACK: root]
    }
    
    public init(stacks: [String: NavigationStack] = [:]) {
        self.stacks = stacks
        
        Array(self.stacks.values).forEach({
            self.subscribeToChanges(stack: $0)
        })
    }
    
    private func subscribeToChanges(stack: NavigationStack) {
        stack.objectWillChange
            .sink(receiveValue: {
                self.objectWillChange.send()
            })
            .store(in: &cancelBag)
    }
    
    public func peek() -> NavigationStack? {
        Array(stacks.values).first
    }
    
    public func stack(withId id: String) -> NavigationStack? {
        stacks[id]
    }
    
    public func append(stack: NavigationStack, withId id: String) {
        stacks[id] = stack
        subscribeToChanges(stack: stack)
    }
    
    public func remove(stackWithId id: String) {
        stacks.removeValue(forKey: id)
    }
    
    public func makeRootStackActive() -> NavigationStack {
        activeStack = stack(withId: ROOT_STACK)
        return activeStack!
    }
    
    public func makeStackActive(_ id: String) -> NavigationStack? {
        activeStack = stack(withId: id)
        return activeStack
    }
    
    public func push<Destination: View>(view: Destination, id: String = UUID().uuidString) {
        activeStack?.push(view: view, id: id)
    }
    
    public func popToView(withId id: String? = nil) -> ViewElement? {
        activeStack?.popToView(withId: id)
    }
    
    public func pop() -> ViewElement? {
        activeStack?.pop()
    }
    
    public func popToRoot() {
        activeStack?.popToRoot()
    }
    
    deinit {
        cancelBag.cancel()
    }
}
