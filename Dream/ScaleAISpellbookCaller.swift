//
//  ScaleAISpellbookCaller.swift
//  Dream
//
//  Created by Sigil Wen on 2023-07-15.
//
//  Spellbook Prompt:
//
//  As an AI system, you are extremely skilled at extracting objects and estimating their realistic height in meters from a given text prompt. Your task is to identify the object(s) mentioned in the prompt and their estimated height in meters. Once identified, the information must be formatted according to the provided format for a text-to-3D model application.
//
//    Extract the object and realistic object height in meters from the following text prompts?
//
//    Begin:
//
//    Input: a red apple
//    Output: 0.075
//
//    Input: a large elephant
//    Output: 3.000
//
//
//    Input: {{ input }}
//    Output:


import Foundation


class ScaleAISpellbookCaller {
    
    struct InputData: Codable {
        let input: InputInput
    }
    
    struct InputInput: Codable {
        let input: String
    }
    
    struct ResponseData: Codable {
        let output: String
        
        let requestId: String
    }
    
    // Calls Spellbook API
    func callAPI(input: String) async throws -> ResponseData {
        // Call Spellbook LLM API Endpoint
            let url = URL(string: "https://dashboard.scale.com/spellbook/api/v2/deploy/9f33d7g")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
            var apiKey = ""
        
            print("Let's get this bread 🪄 Magic Spellbook Time")
        
        // Loading in ScaleAI API key from Config.plist
            
            if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
               let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                if let scaleAIKey = dict["ScaleAIKey"] as? String {
                    print(scaleAIKey)
                    apiKey = scaleAIKey
                }
            }
        
        
        // Calling Scale AI Spellbook caster
        
            request.setValue("Basic " + apiKey, forHTTPHeaderField: "Authorization")
            
            let encoder = JSONEncoder()
            let inputInput = InputInput(input: input)

            let inputData = InputData(input: inputInput)
            do {
                let jsonData = try encoder.encode(inputData)
                request.httpBody = jsonData
            } catch {
                throw error
            }
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            do {
                print(data)
                print(data[0])
                let response = try decoder.decode(ResponseData.self, from: data)
                print(response)
                return response
            } catch {
                throw error
            }
        }
}

