//
//  PushView.swift
//
//
//  Created by Q Trang on 7/20/20.
//

import SwiftUI
import Combine
import SwiftUIToolbox

public struct PushView<Destination: View, Label: View>: View {
    @EnvironmentObject private var stacks: NavigationStacks
    @State private var isActive = false
    
    let destination: () -> Destination
    let preAction: (() -> Void)?
    let id: String
    let label: () -> Label
    let plainStyle: Bool

    public init(destination: @escaping () -> Destination,
                preAction: (() -> Void)? = nil,
                id: String = UUID().uuidString,
                label: @escaping () -> Label,
                plainStyle: Bool = true) {
        self.destination = destination
        self.preAction = preAction
        self.id = id
        self.label = label
        self.plainStyle = plainStyle
    }
    
    public var body: some View {
        return Button(action: {
            self.preAction?()
            self.stacks.push(view: self.destination(), id: self.id)
        }, label: { label() })
        .if(plainStyle, content: { content in
            content
            .buttonStyle(PlainButtonStyle())
        })
    }
}
