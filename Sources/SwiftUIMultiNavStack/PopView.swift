//
//  PopView.swift
//
//
//  Created by Q Trang on 7/20/20.
//

import SwiftUI

public enum PopDestination {
    case previous
    case root
    case view(id: String)
}

public struct PopView<Label: View>: View {
    @EnvironmentObject private var stacks: NavigationStacks
    
    let destination: PopDestination
    let preAction: (() -> Void)?
    let label: () -> Label
    
    public init(destination: PopDestination, preAction: (() -> Void)? = nil, label: @escaping () -> Label) {
        self.destination = destination
        self.preAction = preAction
        self.label = label
    }
    
    public var body: some View {
        label()
            .onTapGesture(perform: {
                self.preAction?()
                
                switch self.destination {
                case .root:
                    self.stacks.popToRoot()
                case .view(let id):
                    _ = self.stacks.popToView(withId: id)
                default:
                    _ = self.stacks.pop()
                }
            })
    }
}

