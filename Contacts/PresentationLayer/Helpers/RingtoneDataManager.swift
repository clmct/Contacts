import Foundation

final class RingtoneDataManager {
  static func getData() -> [String] {
    var data: [String] = []
    data.append(R.string.localizable.default())
    data.append(R.string.localizable.oldPhone())
    data.append(R.string.localizable.beacon())
    data.append(R.string.localizable.radar())
    data.append(R.string.localizable.signal())
    data.append(R.string.localizable.waves())
    return data
  }
}
