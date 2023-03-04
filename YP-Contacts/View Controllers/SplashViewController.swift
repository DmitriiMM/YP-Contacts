import UIKit

final class SplashViewController: UIViewController {
    private let service = ContactsServiceImpl()
    
    private lazy var logoImageView: UIImageView = {
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private lazy var requestAccessButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Xочу увидеть свои контакты", for: .normal)
        button.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "SFProText-Medium", size: 0), size: 16)
        button.backgroundColor = UIColor(named: "YP-Blue")
        button.titleLabel?.tintColor = .white
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        button.isHidden = true
        button.addTarget(self, action: #selector(showAccessSettings), for: .touchUpInside)
        
        return button
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        addSubViews()
        addLogoConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        service.requestAccess { [weak self] isGranted in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard isGranted else {
                    self.requestAccessButton.isHidden = false
                    return
                }
                self.switchToContactsController()
            }
        }
    }
    
    @objc func showAccessSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func switchToContactsController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = UINavigationController(rootViewController: ContactsViewController())
    }
}

extension SplashViewController {
    
    private func addSubViews() {
        view.addSubview(logoImageView)
        view.addSubview(requestAccessButton)
    }
    
    private func addLogoConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        requestAccessButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            requestAccessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            requestAccessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            requestAccessButton.heightAnchor.constraint(equalToConstant: 64),
            requestAccessButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -58)
        ])
    }
}
