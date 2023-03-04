import UIKit

final class SortCell: UITableViewCell {
    static let identifierSortCell = "sortCell"
    
    let sortLabel: UILabel = {
        let label = UILabel()
        label.text = "000-00-0"
        label.font = UIFont(descriptor: UIFontDescriptor(name: "SFProText-Regular", size: 0), size: 16)
        label.textColor = .white
        
        return label
    }()
    
    let radioImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "radioOff")
        imageView.image = image
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        contentView.backgroundColor = UIColor(named: "YP-LightBlack")
        
        addSubViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margins = UIEdgeInsets(top: 2, left: 16, bottom: 2, right: 16)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 24
    }
    
    func chooseSort() {
        
    }
    
//    func setCheckmark(for cell: FilterCell) {
//        cell.checkmarkImageView.image = UIImage(named: "checkboxOn")
//        cell.isOn = true
//    }
//
//    func resetCheckmark(for cell: FilterCell) {
//        cell.checkmarkImageView.image = UIImage(named: "checkboxOff")
//        cell.isOn = false
//    }
    
    private func addConstraints() {
        sortLabel.translatesAutoresizingMaskIntoConstraints = false
        radioImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 64),
            
            sortLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sortLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            radioImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17)
        ])
    }
    
    private func addSubViews() {
        contentView.addSubview(sortLabel)
        contentView.addSubview(radioImageView)
    }
    
}
