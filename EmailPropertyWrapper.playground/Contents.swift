import UIKit

@propertyWrapper
struct EmailValidated {
    private var value: String?
    
    var wrappedValue: String? {
        get {
            return value
        }
        set {
            value = {
                guard let trimmedString = newValue?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
                return validate(trimmedString)
            }()
        }
    }
    
    private func validate(_ emailString: String) -> String? {
        let dataDetector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        // Finding matches in string
        let range = NSRange(emailString.startIndex..<emailString.endIndex, in: emailString)
        guard let match = dataDetector.firstMatch(in: emailString, options: .anchored, range: range) else { return nil }
        guard let url = match.url else { return nil }
        
        // Extracting email from the matched url
        let absoluteString = url.absoluteString
        guard let index = absoluteString.range(of: "mailto:") else { return nil }
        return String(url.absoluteString.suffix(from: index.upperBound))
    }
}

struct Contact {
    var fullName: String
    @EmailValidated var email: String?
}

var contact = Contact(fullName: "Toomas")

contact.email = "invalidemail"
print(contact.email as Any) // nil

contact.email = "  test  toomas@email.zz"
print(contact.email as Any) // nil

contact.email = "toomas@email.zz"
print(contact.email as Any) // Optional("toomas@email.zz")
