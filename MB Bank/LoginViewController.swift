import UIKit

class LoginViewController: UIViewController {
    
    // ⚠️ CẬP NHẬT TÀI KHOẢN/MẬT KHẨU TẠI ĐÂY
    let correctUsername = "user123"
    let correctPassword = "pass123"
    
    let logoLabel = UILabel()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton(type: .system)
    let errorLabel = UILabel()
    let loadingView = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1.0)
        navigationController?.isNavigationBarHidden = true
        
        // Kiểm tra nếu đã login, skip
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            goToMainApp()
        }
        
        setupUI()
    }
    
    func setupUI() {
        // Logo
        logoLabel.text = "⭐ MB BANK"
        logoLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        logoLabel.textColor = UIColor(red: 1.0, green: 0.2, blue: 0.4, alpha: 1.0)
        logoLabel.textAlignment = .center
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoLabel)
        
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Username TextField
        setupTextField(usernameTextField, placeholder: "Tên đăng nhập", icon: "👤")
        view.addSubview(usernameTextField)
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 80),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Password TextField
        setupTextField(passwordTextField, placeholder: "Mật khẩu", icon: "🔒")
        passwordTextField.isSecureTextEntry = true
        view.addSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Error Label
        errorLabel.textColor = .red
        errorLabel.font = UIFont.systemFont(ofSize: 13)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 2
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        // Login Button
        loginButton.setTitle("Đăng nhập", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(red: 0.0, green: 0.2, blue: 0.8, alpha: 1.0)
        loginButton.layer.cornerRadius = 12
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Test account info
        let infoLabel = UILabel()
        infoLabel.text = "Tài khoản test:\n👤 user123\n🔒 pass123"
        infoLabel.numberOfLines = 3
        infoLabel.font = UIFont.systemFont(ofSize: 12)
        infoLabel.textColor = .gray
        infoLabel.textAlignment = .center
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            infoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Loading View
        setupLoadingView()
    }
    
    func setupTextField(_ textField: UITextField, placeholder: String, icon: String) {
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Add left padding with icon
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let iconLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 30, height: 50))
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 20)
        paddingView.addSubview(iconLabel)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        // Right padding
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        textField.rightViewMode = .always
    }
    
    func setupLoadingView() {
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        loadingView.alpha = 0
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }
    
    @objc func loginTapped() {
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let password = passwordTextField.text ?? ""
        
        errorLabel.text = ""
        
        if username.isEmpty {
            errorLabel.text = "Vui lòng nhập tên đăng nhập"
            return
        }
        
        if password.isEmpty {
            errorLabel.text = "Vui lòng nhập mật khẩu"
            return
        }
        
        // Kiểm tra đăng nhập
        if username == correctUsername && password == correctPassword {
            showLoading()
            
            // Lưu thông tin user
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(1000000.0, forKey: "balance") // Số dư mặc định
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.goToMainApp()
            }
        } else {
            errorLabel.text = "Tên đăng nhập hoặc mật khẩu không đúng"
            
            // Animation shake
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            animation.duration = 0.5
            animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
            loginButton.layer.add(animation, forKey: "shake")
        }
    }
    
    func showLoading() {
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = 1
        }
        activityIndicator.startAnimating()
    }
    
    func goToMainApp() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        window.rootViewController = sceneDelegate?.createTabBarController()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {})
    }
}
