import UIKit

final class ContactCell: UITableViewCell {
    static let identifier = "cell"
    var images = ["Telegram", "Whatsapp", "Viber", "Signal", "Threema", "Phone", "Email"]
    
    lazy var contactImageView: UIImageView = {
        let imageView = UIImageView()
        let placeholder = UIImage(systemName: "theatermasks.fill")
        imageView.image = placeholder
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(named: "YP-Gray")
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var contactNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.text = "First name Last name"
        label.font = UIFont(descriptor: UIFontDescriptor(name: "SFProText-Medium", size: 0), size: 30)
        label.textColor = .white
        
        return label
    }()
    
    lazy var contactPhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "000-00-0"
        label.font = UIFont(descriptor: UIFontDescriptor(name: "SFProText-Regular", size: 0), size: 12)
        label.textColor = UIColor(named: "YP-Gray")
        
        return label
    }()
    
    lazy var contactIconsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = -4
        stackView.alignment = .leading

        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .black
        contentView.backgroundColor = UIColor(named: "YP-LightBlack")
        addSubViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for arrangedSubview in contactIconsStackView.arrangedSubviews {
            contactIconsStackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margins = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 24
    }
    
    func addMiniLogo(to stackView: UIStackView, imageView: UIImageView) {
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor(named: "YP-LightBlack")?.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        stackView.addArrangedSubview(imageView)
    }
    
    private func addConstraints() {
        contactImageView.translatesAutoresizingMaskIntoConstraints = false
        contactNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contactPhoneLabel.translatesAutoresizingMaskIntoConstraints = false
        contactIconsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            contactImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contactImageView.heightAnchor.constraint(equalToConstant: 96),
            contactImageView.widthAnchor.constraint(equalToConstant: 96),
            contactImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            contactImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            contactNameLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 48),
            contactNameLabel.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 12),
            contactNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            contactPhoneLabel.leadingAnchor.constraint(equalTo: contactNameLabel.leadingAnchor),
            contactPhoneLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 2),
            contactPhoneLabel.heightAnchor.constraint(equalToConstant: 14),
            
            contactIconsStackView.leadingAnchor.constraint(equalTo: contactNameLabel.leadingAnchor),
            contactIconsStackView.heightAnchor.constraint(equalToConstant: 28),
            contactIconsStackView.bottomAnchor.constraint(equalTo: contactImageView.bottomAnchor)
        ])
    }
    
    private func addSubViews() {
        contentView.addSubview(contactImageView)
        contentView.addSubview(contactNameLabel)
        contentView.addSubview(contactPhoneLabel)
        contentView.addSubview(contactIconsStackView)
    }
}
