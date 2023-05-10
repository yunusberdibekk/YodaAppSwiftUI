//
//  ContentView.swift
//  YodaApp
//
//  Created by Yunus Emre Berdibek on 11.05.2023.
//

import SwiftUI

struct ContentView: View {
    let baseURL = "https://api.funtranslations.com/translate/yoda.json?text="
    
    @State private var text: String = ""
    @State private var translatedText: String? = nil

    var body: some View {
        VStack {
            
            if let translatedText {
                Text(translatedText)
            }
            
            Image("yoda")
                .resizable()
                .scaledToFit()
            
            TextField("Input Text", text: $text, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(4, reservesSpace: true)
                .onSubmit {
                    Task {
                        // 0.Create full URL
                        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "Hello%20There"
                        
                        let fullURL = baseURL + encodedText
                        
                        guard let url = URL(string: fullURL) else {return}
                        
                        // 1.Send URL Request
                        
                        let (data, _) = try await URLSession.shared.data(from: url)
                        
                        let response = try JSONDecoder().decode(YodaResponse.self, from: data)
                        
                        // 2.show results
                        
                        translatedText = response.contents.translated
                    }
                }
        }
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct YodaResponse: Decodable {
    let success: Success
    
    struct Success: Decodable {
        let total: Int
    }
    
    let contents: Contents
    
    struct Contents: Decodable {
        let translated: String
        let text: String
    }
}
