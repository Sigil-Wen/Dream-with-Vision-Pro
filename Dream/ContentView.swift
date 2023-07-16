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
// import SDWebImageSwiftUI

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
                        
                        modalShapE.size = nil
                        
                        modalShapE.generated3D = nil
                        
                        modalShapE.gifURL = nil
                        
                        
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
                        
                        modalShapE.generated3D = URL( string: "https://3dviewer.net/#model=" + urls[1].absoluteString)
                        
                        modalShapE.gifURL = urls[0]
                        //                            // Calling Scale AI Spellbook
                        let response = try await scaleAISpellbookCaller.callAPI(input: modalShapE.text3DPrompt)
                        
                        
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
            
            //                if let generatedObject = modalShapE.generated3D {
            //                    AnimatedImage(url: generatedObject)
            //                                    .resizable()
            //                                    .scaledToFit()
            //                                    .frame(width: 200, height: 200)
            //                }
            
            //                Toggle("Immersive", isOn: $showImmersiveSpace)
            //                    .toggleStyle(.button)
            
            if let generatedSize = modalShapE.size {
                Text("Generated Size for \(modalShapE.text3DPrompt) is \(generatedSize) meters")
            }
            
            if let generatedSize = modalShapE.generated3D {
                
                Button(action: {
                    // Open the link in Safari
                    UIApplication.shared.open(generatedSize)
                }) {
                    Text("View Link")
                }
            }
            
            if let generatedGif = modalShapE.gifURL {
                
                Button(action: {
                    // Open the link in Safari
                    UIApplication.shared.open(generatedGif)
                }) {
                    Text("View Link")
                }
            }
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
