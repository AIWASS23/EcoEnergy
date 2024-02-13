//
//  SceneExtension.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//

import Foundation
import SwiftUI

#if os(macOS)
extension Scene {

    @available(macOS 12, *)
    func hiddenTitleBar() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowStyle(.hiddenTitleBar)
        } else {
            return self
        }
    }

    @available(macOS 12, *)
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }

    @available(macOS 12, *)
    func defaultPositionTopLeading() -> some Scene {
        if #available(macOS 13.0, *) {
            return defaultPosition(.topLeading)
        } else {
            return self
        }
    }

    @available(macOS 12, *)
    func defaultPositionCenter() -> some Scene {
        if #available(macOS 13.0, *) {
            return defaultPosition(.center)
        } else {
            return self
        }
    }
}
#endif
