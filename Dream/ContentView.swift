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
        
    var scaleAISpellbookCaller: ScaleAISpellbookCaller = ScaleAISpellbookCaller()
    
    @ObservedObject var textTo3DModel: TextTo3DModel = TextTo3DModel()

    var body: some View {
        
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Dream with VisionOS")
            
            TextField("Enter text here", text: $textTo3DModel.text3DPrompt)
                        .padding(10)
            
            Button(action: {                
                Task {
                    do {
                        // Calling Scale AI Spellbook
                        let response = try await scaleAISpellbookCaller.callAPI(input: "A bicycle")
                        print(response.output)
                    } catch {
                        print("Failed to call API: \(error)")
                    }
                    print("Button tapped!")
                }
                    }) {
                        Text("Generate")
                            .foregroundColor(.white)
                            .padding()
                            .cornerRadius(10)
                    }

            Toggle("Immersive", isOn: $showImmersiveSpace)
                .toggleStyle(.button)
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
