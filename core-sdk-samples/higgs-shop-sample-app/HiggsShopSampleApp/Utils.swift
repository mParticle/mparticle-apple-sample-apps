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
        return .systemFont(ofSize: size)
    }
    
    static func boldFont(ofSize size: CGFloat) -> UIFont {
        return .boldSystemFont(ofSize: size)
    }
}
