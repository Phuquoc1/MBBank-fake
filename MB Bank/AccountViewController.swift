import UIKit

class AccountViewController: UIViewController {
    
    let usernameLabel = UILabel()
    let accountNumberTextField = UITextField()
    let accountNumberLabel = UILabel()
    let logoutButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        loadAccountInfo()
    }
    
    func setupUI() {
        // Profile card
        let profileCard = UIView()
        profileCard.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1.0)
        profileCard.layer.cornerRadius = 15
        profileCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileCard)
        
        NSLayoutConstraint.activate([
            profileCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            profileCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileCard.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // Avatar icon
        let avatarLabel = UILabel()
        avatarLabel.text = "👤"
        avatarLabel.font = UIFont.systemFont(ofSize: 50)
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        profileCard.addSubview(avatarLabel)
        
        NSLayoutConstraint.activate([
            avatarLabel.leadingAnchor.constraint(equalTo: profileCard.leadingAnchor, constant: 20),
            avatarLabel.centerYAnchor.constraint(equalTo: profileCard.centerYAnchor)
        ])
        
        // Username
        usernameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        usernameLabel.textColor = .black
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileCard.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: avatarLabel.trailingAnchor, constant: 15),
            usernameLabel.topAnchor.constraint(equalTo: profileCard.topAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: profileCard.trailingAnchor, constant: -20)
        ])
        
        // Account type
        let accountTypeLabel = UILabel()
        accountTypeLabel.text = "Tài khoản thanh toán"
        accountTypeLabel.font = UIFont.systemFont(ofSize: 13)
        accountTypeLabel.textColor = .gray
        accountTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        profileCard.addSubview(accountTypeLabel)
        
        NSLayoutConstraint.activate([
            accountTypeLabel.leadingAnchor.constraint(equalTo: avatarLabel.trailingAnchor, constant: 15),
            accountTypeLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8)
        ])
        
        // Settings section
        let settingsLabel = UILabel()
        settingsLabel.text = "Cài đặt"
        settingsLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsLabel)
        
        NSLayoutConstraint.activate([
            settingsLabel.topAnchor.constraint(equalTo: profileCard.bottomAnchor, constant: 40),
            settingsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Account number field
        let accountNumberLabelTitle = UILabel()
        accountNumberLabelTitle.text = "Số tài khoản"
        accountNumberLabelTitle.font = UIFont.systemFont(ofSize: 14)
        accountNumberLabelTitle.textColor = .black
        accountNumberLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(accountNumberLabelTitle)
        
        NSLayoutConstraint.activate([
            accountNumberLabelTitle.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 20),
            accountNumberLabelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        accountNumberTextField.placeholder = "Nhập số tài khoản"
        accountNumberTextField.font = UIFont.systemFont(ofSize: 16)
        accountNumberTextField.keyboardType = .numberPad
        accountNumberTextField.layer.borderWidth = 1.5
        accountNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
        accountNumberTextField.layer.cornerRadius = 12
        accountNumberTextField.backgroundColor = .white
        accountNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        accountNumberTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        accountNumberTextField.leftViewMode = .always
        view.addSubview(accountNumberTextField)
        
        NSLayoutConstraint.activate([
            accountNumberTextField.topAnchor.constraint(equalTo: accountNumberLabelTitle.bottomAnchor, constant: 10),
            accountNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            accountNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            accountNumberTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Save button
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Lưu số tài khoản", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        saveButton.layer.cornerRadius = 12
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveAccountNumber), for: .touchUpInside)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: accountNumberTextField.bottomAnchor, constant: 15),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        // Logout button
        logoutButton.setTitle("Đăng xuất", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        logoutButton.layer.cornerRadius = 12
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 15),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func loadAccountInfo() {
        let username = UserDefaults.standard.string(forKey: "username") ?? "User"
        usernameLabel.text = username
        
        let accountNumber = UserDefaults.standard.string(forKey: "accountNumber") ?? ""
        accountNumberTextField.text = accountNumber
    }
    
    @objc func saveAccountNumber() {
        guard let accountNumber = accountNumberTextField.text, !accountNumber.isEmpty else {
            showAlert("Vui lòng nhập số tài khoản")
            return
        }
        
        UserDefaults.standard.set(accountNumber, forKey: "accountNumber")
        showAlert("Số tài khoản đã được lưu")
    }
    
    @objc func logout() {
        let alertController = UIAlertController(title: "Đăng xuất", message: "Bạn chắc chắn muốn đăng xuất?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Hủy", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Đăng xuất", style: .destructive) { _ in
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }
            
            let loginVC = LoginViewController()
            let loginNav = UINavigationController(rootViewController: loginVC)
            window.rootViewController = loginNav
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {})
        })
        
        present(alertController, animated: true)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
