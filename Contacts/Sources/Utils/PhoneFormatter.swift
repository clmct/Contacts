import Foundation

final class PhoneFormatter {
  static func format(with type: PhoneType, phone: String) -> String {
    let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    var result = ""
    var index = numbers.startIndex
    let mask = type.rawValue
    for character in mask where index < numbers.endIndex {
      if character == "X" {
        result.append(numbers[index])
        index = numbers.index(after: index)
      } else {
        result.append(character)
      }
    }
    return result
  }
  
  enum PhoneType: String {
    case rus = "+X (XXX) XXX-XXXX"
  }
}
