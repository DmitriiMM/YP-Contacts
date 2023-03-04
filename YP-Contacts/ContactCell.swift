import UIKit

class ContactCell: UITableViewCell {
    static let identifier = "cell"
    
    let contactImageView: UIImageView = {
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
    
    let contactNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First name Last name"
        label.font = UIFont(descriptor: UIFontDescriptor(name: "SFProText-Medium", size: 0), size: 30)
        label.textColor = .white
        
        return label
    }()
    
    let contactPhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "000-00-0"
        label.font = UIFont(descriptor: UIFontDescriptor(name: "SFProText-Regular", size: 0), size: 12)
        label.textColor = UIColor(named: "YP-Gray")
        
        return label
    }()
    
    let contactIconsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = -4
        stackView.alignment = .leading
        let images = ["Telegram", "Whatsapp", "Viber", "Signal", "Threema", "Phone", "Email"]
        
        for imageName in images {
            let imageView = UIImageView(image: UIImage(named: imageName))
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margins = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 24
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
