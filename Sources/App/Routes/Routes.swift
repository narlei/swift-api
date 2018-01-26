import Vapor
import Foundation


extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "SocialBase aqui é swift!!!!")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }
        
        get("ml") { req in
            
            
            let options = NSLinguisticTagger.Options.omitWhitespace.rawValue | NSLinguisticTagger.Options.joinNames.rawValue
            let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "pt-br"), options: Int(options))
            
            var inputString = "Mas que dia lindo para estar com você"
            
            if let text = req.parameters["name"] as? String {
                inputString = text
            }
            
            var output = "Análise: \(inputString)<br>"
            
            tagger.string = inputString
            
            let range = NSRange(location: 0, length: inputString.utf16.count)
            tagger.enumerateTags(in: range, scheme: NSLinguisticTagScheme(rawValue: "NameTypeOrLexicalClass"), options: NSLinguisticTagger.Options(rawValue: options)) { tag, tokenRange, sentenceRange, stop in
                guard let range = Range(tokenRange, in: inputString) else { return }
                let token = inputString[range]
                output = "\(output) <br> \(tag): \(token)"
                
            }
            return output
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        try resource("posts", PostController.self)
    }
}
