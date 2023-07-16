//
//  ModalShapETextTo3D.swift
//  Dream
//
//  Created by Sigil Wen on 2023-07-15.
//

import Foundation

class ModalShapETextTo3D: ObservableObject {
    
    // Modal Endpoint for Shap-e Text to 3D
    
    @Published var text3DPrompt: String = ""
    
    @Published var generated3D: URL?
    
    @Published var size: Float?
    
    @Published var isGenerating: Bool = false
    
    @Published var gifURL: URL?
    
    func postRequest(prompt: String) async throws -> String {
        let url = URL(string: "https://mcantillon21--dream-fastapi-app.modal.run/predictions/" + prompt)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let stringResponse = String(data: data, encoding: .utf8) {
            
            
            return stringResponse
        } else {
            throw NSError(domain: "Response decoding error", code: 0, userInfo: nil)
        }
    }
    
}
