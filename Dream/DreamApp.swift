//
//  DreamApp.swift
//  Dream
//
//  Created by Sigil Wen on 2023-07-15.
//

import SwiftUI

@main
struct DreamApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
