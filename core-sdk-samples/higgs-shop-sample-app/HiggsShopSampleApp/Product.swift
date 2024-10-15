import UIKit

struct Product: Codable {
    let id: String
    let label: String
    let imageUrl: String
    let altText: String
    let price: Double
    let variants: Variants

    var image: UIImage? {
        UIImage(named: imageName)
    }

    var imageName: String {
        imageUrl.replacingOccurrences(of: "/products/", with: "").replacingOccurrences(of: ".png", with: "")
    }
}
