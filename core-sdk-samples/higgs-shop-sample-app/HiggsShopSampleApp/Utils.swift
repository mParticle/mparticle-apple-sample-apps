import Foundation
import UIKit

final class Utils {
    static func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    static func parse(jsonData: Data) -> Configuration {
        do {
            let decodedData = try JSONDecoder().decode(Configuration.self, from: jsonData)
            return decodedData
        } catch {
            print(error)
        }
        
        return Configuration(products: [Product]())
    }
    
    static func font(ofSize size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "Lato-Regular", size: UIFont.labelFontSize) else {
            print("""
                Failed to load the "Lato-Regular" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
            return .systemFont(ofSize: size)
        }
        
        return customFont.withSize(size)
    }
    
    static func boldFont(ofSize size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "Lato-Bold", size: UIFont.labelFontSize) else {
            print("""
                Failed to load the "Lato-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
            return .boldSystemFont(ofSize: size)
        }
        
        return customFont.withSize(size)
    }
}
