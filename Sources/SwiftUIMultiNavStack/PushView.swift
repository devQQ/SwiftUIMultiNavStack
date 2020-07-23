//
//  PushView.swift
//
//
//  Created by Q Trang on 7/20/20.
//

import SwiftUI
import Combine

public struct PushView<Destination: View, Label: View>: View {
    @EnvironmentObject private var stacks: NavigationStacks
    @State private var isActive = false
    
    let destination: () -> Destination
    let id: String
    let label: () -> Label

    public init(destination: @escaping () -> Destination, id: String = UUID().uuidString, label: @escaping () -> Label) {
        self.destination = destination
        self.id = id
        self.label = label
    }
    
    public var body: some View {
        return Button(action: {
            self.stacks.push(view: self.destination(), id: self.id)
        }, label: { label() })
            .buttonStyle(PlainButtonStyle())
    }
}
