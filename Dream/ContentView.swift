//
//  ContentView.swift
//  Dream
//
//  Created by Sigil Wen on 2023-07-15.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State var showImmersiveSpace = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @State private var inputText = ""
    
    @State var render = false
    
    @ObservedObject var textTo3DModel: TextTo3DModel = TextTo3DModel()

    var body: some View {
        
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Dream with VisionOS")
            
            TextField("Enter text here", text: $textTo3DModel.text3DPrompt)
                        .padding(10)
            
            Toggle("Render", isOn: $render)
                .toggleStyle(.button)
                .padding(.top, 50)

            Toggle("Immersive", isOn: $showImmersiveSpace)
                .toggleStyle(.button)
                .padding(.top, 50)
            
        }
        .navigationTitle("Content")
        .padding()
        .frame(width: 500)
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    await openImmersiveSpace(id: "ImmersiveSpace")
                } else {
                    await dismissImmersiveSpace()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
