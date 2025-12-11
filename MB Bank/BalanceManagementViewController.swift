import UIKit

class BalanceManagementViewController: UIViewController {
    
    let balanceLabel = UILabel()
    let balanceTextField = UITextField()
    let addButton = UIButton(type: .system)
    let subtractButton = UIButton(type: .system)
    let historyTableView = UITableView()
    var balanceHistory: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        updateBalanceDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBalanceDisplay()
    }
    
    func setupUI() {
        // Current balance box
        let balanceBox = UIView()
        balanceBox.backgroundColor = UIColor(red: 0.0, green: 0.2, blue: 0.8, alpha: 1.0)
        balanceBox.layer.cornerRadius = 15
        balanceBox.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(balanceBox)
        
        NSLayoutConstraint.activate([
            balanceBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            balanceBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            balanceBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            balanceBox.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        // Balance label
        balanceLabel.text = "Số dư: 1,000,000 VND"
        balanceLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        balanceLabel.textColor = .white
        balanceLabel.textAlignment = .center
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceBox.addSubview(balanceLabel)
        
        NSLayoutConstraint.activate([
            balanceLabel.centerXAnchor.constraint(equalTo: balanceBox.centerXAnchor),
            balanceLabel.centerYAnchor.constraint(equalTo: balanceBox.centerYAnchor)
        ])
        
        // Input field
        balanceTextField.placeholder = "Nhập số tiền"
        balanceTextField.keyboardType = .decimalPad
        balanceTextField.font = UIFont.systemFont(ofSize: 16)
        balanceTextField.layer.borderWidth = 1.5
        balanceTextField.layer.borderColor = UIColor.lightGray.cgColor
        balanceTextField.layer.cornerRadius = 12
        balanceTextField.backgroundColor = .white
        balanceTextField.translatesAutoresizingMaskIntoConstraints = false
        balanceTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        balanceTextField.leftViewMode = .always
        view.addSubview(balanceTextField)
        
        NSLayoutConstraint.activate([
            balanceTextField.topAnchor.constraint(equalTo: balanceBox.bottomAnchor, constant: 30),
            balanceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            balanceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            balanceTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Button stack
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.spacing = 15
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: balanceTextField.bottomAnchor, constant: 20),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add button
        setupButton(addButton, title: "+ Cộng", backgroundColor: UIColor(red: 0.0, green: 0.7, blue: 0.3, alpha: 1.0), action: #selector(addBalance))
        buttonStack.addArrangedSubview(addButton)
        
        // Subtract button
        setupButton(subtractButton, title: "- Trừ", backgroundColor: UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0), action: #selector(subtractBalance))
        buttonStack.addArrangedSubview(subtractButton)
        
        // History label
        let historyLabel = UILabel()
        historyLabel.text = "Lịch sử thay đổi"
        historyLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        historyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(historyLabel)
        
        NSLayoutConstraint.activate([
            historyLabel.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 25),
            historyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // History table view
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        historyTableView.separatorStyle = .singleLine
        view.addSubview(historyTableView)
        
        NSLayoutConstraint.activate([
            historyTableView.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 10),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupButton(_ button: UIButton, title: String, backgroundColor: UIColor, action: Selector) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    @objc func addBalance() {
        guard let amountText = balanceTextField.text, !amountText.isEmpty else {
            showAlert("Vui lòng nhập số tiền")
            return
        }
        
        guard let amount = Double(amountText) else {
            showAlert("Vui lòng nhập số tiền hợp lệ")
            return
        }
        
        let currentBalance = UserDefaults.standard.double(forKey: "balance")
        let newBalance = currentBalance + amount
        
        UserDefaults.standard.set(newBalance, forKey: "balance")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        
        balanceHistory.insert("+ \(formatCurrency(amount)) lúc \(timestamp)", at: 0)
        
        balanceTextField.text = ""
        updateBalanceDisplay()
        historyTableView.reloadData()
    }
    
    @objc func subtractBalance() {
        guard let amountText = balanceTextField.text, !amountText.isEmpty else {
            showAlert("Vui lòng nhập số tiền")
            return
        }
        
        guard let amount = Double(amountText) else {
            showAlert("Vui lòng nhập số tiền hợp lệ")
            return
        }
        
        let currentBalance = UserDefaults.standard.double(forKey: "balance")
        
        if currentBalance < amount {
            showAlert("Số dư không đủ")
            return
        }
        
        let newBalance = currentBalance - amount
        UserDefaults.standard.set(newBalance, forKey: "balance")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        
        balanceHistory.insert("- \(formatCurrency(amount)) lúc \(timestamp)", at: 0)
        
        balanceTextField.text = ""
        updateBalanceDisplay()
        historyTableView.reloadData()
    }
    
    func updateBalanceDisplay() {
        let balance = UserDefaults.standard.double(forKey: "balance")
        balanceLabel.text = "Số dư: \(formatCurrency(balance))"
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        let result = formatter.string(from: NSNumber(value: value)) ?? "0"
        return "\(result) VND"
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension BalanceManagementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return balanceHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = balanceHistory[indexPath.row]
        content.textProperties.font = UIFont.systemFont(ofSize: 14)
        cell.contentConfiguration = content
        return cell
    }
}
