//
//  ViewElement.swift
//
//
//  Created by Q Trang on 7/20/20.
//

import SwiftUI

public struct ViewElement: Identifiable {
    public let id: String
    public let element: UIViewController
    
    public init(id: String = UUID().uuidString, element: UIViewController) {
        self.id = id
        self.element = element
    }
}

extension ViewElement: Equatable {
    public static func ==(lhs: ViewElement, rhs: ViewElement) -> Bool {
        lhs.id == rhs.id
    }
}

