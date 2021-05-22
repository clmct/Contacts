import UIKit

final class ContactTableViewCell: UITableViewCell {
  // MARK: - Properties
  static let identifier = "ContactTableViewCell"
  private let nameLabel = UILabel()
  
  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupNameLabel()

  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private Methods
  private func setupNameLabel() {
    contentView.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.centerY.equalToSuperview()
    }
  }
  
  private func getAttributedText(firstName: String, lastName: String) -> NSMutableAttributedString {
    let regularAttributes = [NSAttributedString.Key.font: UIFont.basic1]
    let regularString = NSMutableAttributedString(string: firstName, attributes: regularAttributes)
    
    let boldAttributes = [NSAttributedString.Key.font: UIFont.basic2]
    let boldString = NSMutableAttributedString(string: lastName, attributes: boldAttributes)
    
    let spaceString = NSMutableAttributedString(string: " ")
    
    let attributedString = regularString
    attributedString.append(spaceString)
    attributedString.append(boldString)
    return attributedString
  }
}

// MARK: - ConfigurableCellProtocol
extension ContactTableViewCell: ConfigurableCellProtocol {
  typealias Model = Contact
  func configure(with model: Contact) {
    nameLabel.attributedText = getAttributedText(firstName: model.firstName, lastName: model.lastName)
  }
}
