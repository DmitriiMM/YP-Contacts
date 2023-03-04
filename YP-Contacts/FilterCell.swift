import UIKit

class FilterCell: UITableViewCell {
    static let identifierFilterCell = "filterCell"
    var isOn = false
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "000-00-0"
        label.font = UIFont(descriptor: UIFontDescriptor(name: "SFProText-Regular", size: 0), size: 16)
        label.textColor = .white
        
        return label
    }()
    
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "checkboxOff")
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
    
    func changeCheckmark() {
        checkmarkImageView.image = isOn ? UIImage(named: "checkboxOff") : UIImage(named: "checkboxOn")
        isOn = !isOn
    }
    
    func setCheckmark(for cell: FilterCell) {
        cell.checkmarkImageView.image = UIImage(named: "checkboxOn")
        cell.isOn = true
    }
    
    func resetCheckmark(for cell: FilterCell) {
        cell.checkmarkImageView.image = UIImage(named: "checkboxOff")
        cell.isOn = false
    }
    
    private func addConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 64),

            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            logoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 64),
            logoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18)
        ])
    }
    
    private func addSubViews() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(logoLabel)
        contentView.addSubview(checkmarkImageView)
    }
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
}
