//
//  ContentView.swift
//  Dream
//
//  Created by Sigil Wen on 2023-07-15.
//

import SwiftUI
import RealityKit
import RealityKitContent
import SceneKit

struct ContentView: View {

    @State var showImmersiveSpace = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
        
    var scaleAISpellbookCaller: ScaleAISpellbookCaller = ScaleAISpellbookCaller()
    
    @ObservedObject var modalShapE: ModalShapETextTo3D = ModalShapETextTo3D()


    var body: some View {
            VStack {
                
                Model3D(named: "dream_team")
                    .scaleEffect(x:10, y:10, z: 10)
                    .padding()
                    .colorMultiply(.blue)
                    .offset(x:0, y: -50)
        
                
//                SceneKitView()
//                            .frame(width: 300, height: 300, alignment: .center)
                
                TextField("Enter text here", text: $modalShapE.text3DPrompt)
                    .multilineTextAlignment(.center)
                    .padding(.top, 100)
                    .foregroundColor(.white)

                
                Button(action: {
                    Task {
                        do {
                            print("WE GO JIM")
                            
                            modalShapE.isGenerating = true
                            
                            if modalShapE.text3DPrompt == "" {
                                modalShapE.text3DPrompt = "cute kitty"
                            }
                            
                            let res = try await modalShapE.postRequest(prompt: modalShapE.text3DPrompt)
                            
                            let jsonData = Data(res.utf8)
                            let decoder = JSONDecoder()
                            let urls = try decoder.decode([URL].self, from: jsonData)
                            
                            // Use the list of URLs
                            for url in urls {
                                print("URL: \(url)")
                            }
                            
                            print(res)
                            
                              modalShapE.generated3D = urls[0]
//                            // Calling Scale AI Spellbook
                            let response = try await scaleAISpellbookCaller.callAPI(input: "A bicycle")
                            
                            
                            print(response.output)
                            
                            if let floatValue = Float(response.output) {
                                print(floatValue) // Prints 3.0
                                modalShapE.size = floatValue
                            } else {
                                print("Invalid float value")
                            }
                            
                            modalShapE.isGenerating = false

                            
                        } catch {
                            modalShapE.isGenerating = false
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
                
                if modalShapE.isGenerating {
                    LoadingView()
                }

//                Toggle("Immersive", isOn: $showImmersiveSpace)
//                    .toggleStyle(.button)
            }
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


//struct SceneKitView: UIViewRepresentable {
//    let scene = SCNScene(named: "baloon.obj")!
//    
//    func makeUIView(context: Context) -> SCNView {
//        let scnView = SCNView()
//        scnView.scene = scene
//        scnView.allowsCameraControl = true // For allowing camera control
//        scnView.autoenablesDefaultLighting = true
//        return scnView
//    }
//    
//    func updateUIView(_ uiView: SCNView, context: Context) {
//        // update your view
//        print("hello")
//    }
//}
