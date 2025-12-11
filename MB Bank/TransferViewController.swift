import UIKit
import UserNotifications
import AudioToolbox

struct Transaction {
    let senderAccount: String
    let recipientName: String
    let recipientAccount: String
    let amount: String
    let message: String
    let timestamp: String
    let id: String
}

class TransferViewController: UIViewController, UITextFieldDelegate {

    var transactions: [Transaction] = []
    var currentTransaction: Transaction?

    let senderAccountTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1.1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Số tài khoản người gửi"
        return textField
    }()

    let recipientNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1.1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Tên người nhận"
        return textField
    }()

    let recipientAccountTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1.1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Số tài khoản người nhận"
        return textField
    }()

    let amountTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1.1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Số tiền chuyển"
        return textField
    }()

    let messageTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1.1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Nội dung chuyển tiền"
        return textField
    }()

    let timeTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1.1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Thời gian chuyển tiền"
        return textField
    }()

    let transferButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Chuyển tiền", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = .black
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()

    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.locale = Locale(identifier: "vi_VN")
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    let datePickerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let historyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Lịch sử giao dịch", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 1.0)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupLoadingView()
        showLoading()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hideLoading()
            self.setupUI()
            self.checkNotificationPermission()
            UNUserNotificationCenter.current().delegate = self
            self.animateViewsAfterLoading()
        }
    }

    func setupUI() {
        let labels = ["Số tài khoản người gửi", "Tên người nhận", "Số tài khoản người nhận", "Số tiền chuyển", "Nội dung chuyển tiền", "Thời gian chuyển tiền"]
        let textFields = [senderAccountTextField, recipientNameTextField, recipientAccountTextField, amountTextField, messageTextField, timeTextField]

        for (index, labelText) in labels.enumerated() {
            let label = UILabel()
            label.text = labelText
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(label)

            let textField = textFields[index]
            stackView.addArrangedSubview(textField)

            NSLayoutConstraint.activate([
                textField.heightAnchor.constraint(equalToConstant: 40)
            ])

            textField.delegate = self
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(doneButtonTapped))
            toolBar.setItems([flexibleSpace, doneButton], animated: false)
            textField.inputAccessoryView = toolBar

            textField.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        }

        stackView.addArrangedSubview(transferButton)
        transferButton.addTarget(self, action: #selector(performTransfer), for: .touchUpInside)

        stackView.addArrangedSubview(historyButton)
        historyButton.addTarget(self, action: #selector(showTransactionHistory), for: .touchUpInside)

        NSLayoutConstraint.activate([
            historyButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Setup date picker container
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePickerContainer.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainer.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: datePickerContainer.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainer.bottomAnchor)
        ])

        timeTextField.inputView = datePickerContainer

        let toolBarForDatePicker = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let flexibleSpaceForDatePicker = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonForDatePicker = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(donePressed))
        toolBarForDatePicker.setItems([flexibleSpaceForDatePicker, doneButtonForDatePicker], animated: false)
        timeTextField.inputAccessoryView = toolBarForDatePicker

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            datePickerContainer.heightAnchor.constraint(equalToConstant: view.frame.height / 2),

            transferButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        stackView.transform = CGAffineTransform(translationX: 0, y: -stackView.frame.height)

        // Button animations
        transferButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        transferButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        transferButton.addTarget(self, action: #selector(buttonTouchUpOutside), for: .touchUpOutside)

        // Keyboard type setup
        senderAccountTextField.delegate = self
        senderAccountTextField.keyboardType = .numberPad

        recipientAccountTextField.delegate = self
        recipientAccountTextField.keyboardType = .numberPad

        amountTextField.delegate = self
        amountTextField.keyboardType = .decimalPad
    }

    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                print("Quyền thông báo đã được cấp!")
            } else {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("Quyền thông báo đã được cấp!")
                    }
                }
            }
        }
    }

    @objc func performTransfer() {
        let senderAccount = senderAccountTextField.text ?? ""
        let recipientName = recipientNameTextField.text ?? ""
        let recipientAccount = recipientAccountTextField.text ?? ""
        let amount = amountTextField.text ?? ""
        let message = messageTextField.text ?? ""
        let time = timeTextField.text ?? ""

        if senderAccount.isEmpty || recipientName.isEmpty || recipientAccount.isEmpty || amount.isEmpty || message.isEmpty || time.isEmpty {
            showAlert(message: "Vui lòng nhập đầy đủ thông tin!")
            return
        }

        // Create transaction
        let transaction = Transaction(
            senderAccount: senderAccount,
            recipientName: recipientName,
            recipientAccount: recipientAccount,
            amount: amount,
            message: message,
            timestamp: time,
            id: UUID().uuidString
        )
        
        transactions.append(transaction)
        currentTransaction = transaction

        let maskedRecipientAccount = maskAccountNumber(account: recipientAccount)

        let notificationTitle = "Chuyển tiền thành công"
        let notificationMessage = "Chuyển \(amount) VND cho \(recipientName)\nTK: \(maskedRecipientAccount)\nNội dung: \(message)\nThời gian: \(time)"

        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationMessage
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(datePicker.date.timeIntervalSinceNow, 1), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Lỗi: \(error.localizedDescription)")
            } else {
                print("Thông báo chuyển tiền đã được lên lịch!")
                DispatchQueue.main.async {
                    self.showTransactionBill()
                    self.clearAllFields()
                }
            }
        }
    }

    @objc func showTransactionBill() {
        guard let transaction = currentTransaction else { return }
        
        let billVC = TransactionBillViewController(transaction: transaction)
        let navigationVC = UINavigationController(rootViewController: billVC)
        navigationVC.modalPresentationStyle = .fullScreen
        self.present(navigationVC, animated: true)
    }

    @objc func showTransactionHistory() {
        let historyVC = TransactionHistoryViewController(transactions: transactions)
        navigationController?.pushViewController(historyVC, animated: true)
    }

    func clearAllFields() {
        senderAccountTextField.text = ""
        recipientNameTextField.text = ""
        recipientAccountTextField.text = ""
        amountTextField.text = ""
        messageTextField.text = ""
        timeTextField.text = ""
    }

    func maskAccountNumber(account: String) -> String {
        if account.count >= 5 {
            let start = account.startIndex
            let end = account.index(start, offsetBy: 2)
            let endIndex = account.index(account.endIndex, offsetBy: -3)
            let maskedAccount = account[start..<end] + "xxx" + account[endIndex..<account.endIndex]
            return String(maskedAccount)
        }
        return account
    }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Lỗi", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy HH:mm"
        formatter.locale = Locale(identifier: "vi_VN")
        timeTextField.text = formatter.string(from: datePicker.date)
        timeTextField.resignFirstResponder()
    }

    @objc func doneButtonTapped() {
        view.endEditing(true)
    }

    func setupLoadingView() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)

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

    func showLoading() {
        loadingView.isHidden = false
        activityIndicator.startAnimating()
        loadingView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = 0.8
        }
    }

    func hideLoading() {
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingView.alpha = 0
        }) { _ in
            self.loadingView.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }

    func animateViewsAfterLoading() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.stackView.transform = .identity
        }

        let textFields = [senderAccountTextField, recipientNameTextField, recipientAccountTextField, amountTextField, messageTextField, timeTextField]
        for (index, textField) in textFields.enumerated() {
            UIView.animate(withDuration: 0.6, delay: 0.1 * Double(index), usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut) {
                textField.transform = .identity
            }
        }
    }

    @objc func buttonTouchDown(sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    @objc func buttonTouchUpInside(sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.allowUserInteraction, .curveEaseInOut]) {
            sender.transform = .identity
        }
    }

    @objc func buttonTouchUpOutside(sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.allowUserInteraction, .curveEaseInOut]) {
            sender.transform = .identity
        }
    }

    // MARK: - UITextFieldDelegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            textField.layer.borderColor = UIColor.blue.cgColor
            textField.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.transform = .identity
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == senderAccountTextField || textField == recipientAccountTextField {
            return string.isEmpty || CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        } else if textField == amountTextField {
            return string.isEmpty || CharacterSet(charactersIn: "0123456789.,").isSuperset(of: CharacterSet(charactersIn: string))
        }
        return true
    }
}

extension TransferViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge, .list])
    }
}

// MARK: - Transaction Bill View Controller

class TransactionBillViewController: UIViewController {
    
    let transaction: Transaction
    let billView = UIView()
    
    init(transaction: Transaction) {
        self.transaction = transaction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1.0)
        navigationItem.hidesBackButton = true
        
        setupSuccessUI()
    }
    
    func setupSuccessUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 30
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.alignment = .center
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40),
            contentStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
        
        // Check icon
        let checkIcon = UILabel()
        checkIcon.text = "✓"
        checkIcon.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        checkIcon.textColor = UIColor(red: 0.4, green: 0.75, blue: 1.0, alpha: 1.0)
        contentStack.addArrangedSubview(checkIcon)
        
        // Success message
        let successLabel = UILabel()
        successLabel.text = "Chuyển tiền thành công"
        successLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        successLabel.textColor = .black
        successLabel.textAlignment = .center
        contentStack.addArrangedSubview(successLabel)
        
        // Bill info box
        billView.backgroundColor = .white
        billView.layer.borderWidth = 1
        billView.layer.borderColor = UIColor(red: 0.8, green: 0.83, blue: 0.88, alpha: 1.0).cgColor
        billView.layer.cornerRadius = 15
        billView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(billView)
        
        NSLayoutConstraint.activate([
            billView.widthAnchor.constraint(equalTo: contentStack.widthAnchor)
        ])
        
        let billStack = UIStackView()
        billStack.axis = .vertical
        billStack.spacing = 16
        billStack.translatesAutoresizingMaskIntoConstraints = false
        billView.addSubview(billStack)
        
        NSLayoutConstraint.activate([
            billStack.topAnchor.constraint(equalTo: billView.topAnchor, constant: 20),
            billStack.leadingAnchor.constraint(equalTo: billView.leadingAnchor, constant: 20),
            billStack.trailingAnchor.constraint(equalTo: billView.trailingAnchor, constant: -20),
            billStack.bottomAnchor.constraint(equalTo: billView.bottomAnchor, constant: -20)
        ])
        
        // Recipient name
        addBillRow(to: billStack, label: "Người nhận", value: transaction.recipientName, isBold: true)
        
        // Recipient account
        addBillRow(to: billStack, label: "Số tài khoản", value: transaction.recipientAccount)
        
        // Amount
        let amountRow = UIStackView()
        amountRow.axis = .horizontal
        amountRow.spacing = 10
        let amountLabel = UILabel()
        amountLabel.text = "Số tiền"
        amountLabel.font = UIFont.systemFont(ofSize: 14)
        amountLabel.textColor = .gray
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        let amountValue = UILabel()
        amountValue.text = "\(transaction.amount) VND"
        amountValue.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        amountValue.textColor = UIColor.red
        amountRow.addArrangedSubview(amountLabel)
        amountRow.addArrangedSubview(amountValue)
        billStack.addArrangedSubview(amountRow)
        
        // Message
        addBillRow(to: billStack, label: "Nội dung", value: transaction.message)
        
        // Timestamp
        addBillRow(to: billStack, label: "Thời gian", value: transaction.timestamp)
        
        // Transaction ID
        addBillRow(to: billStack, label: "Mã GD", value: transaction.id.prefix(12).uppercased())
        
        // MB Logo
        let logoLabel = UILabel()
        logoLabel.text = "⭐ MB"
        logoLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        logoLabel.textColor = UIColor(red: 1.0, green: 0.2, blue: 0.4, alpha: 1.0)
        billStack.addArrangedSubview(logoLabel)
        
        // Action buttons
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.spacing = 30
        buttonStack.distribution = .equalCentering
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(buttonStack)
        
        // Share button
        let shareBtn = createActionButton(icon: "↗", label: "Chia sẻ", action: #selector(shareBill))
        buttonStack.addArrangedSubview(shareBtn)
        
        // Save image button
        let saveBtn = createActionButton(icon: "📷", label: "Lưu ảnh", action: #selector(saveBillAsImage))
        buttonStack.addArrangedSubview(saveBtn)
        
        // Save template button
        let templateBtn = createActionButton(icon: "📋", label: "Lưu mẫu", action: #selector(saveTemplate))
        buttonStack.addArrangedSubview(templateBtn)
        
        // Continue button
        let continueBtn = UIButton(type: .system)
        continueBtn.setTitle("Thực hiện giao dịch khác", for: .normal)
        continueBtn.setTitleColor(.white, for: .normal)
        continueBtn.backgroundColor = UIColor(red: 0.0, green: 0.2, blue: 0.8, alpha: 1.0)
        continueBtn.layer.cornerRadius = 12
        continueBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        continueBtn.translatesAutoresizingMaskIntoConstraints = false
        continueBtn.addTarget(self, action: #selector(dismissBill), for: .touchUpInside)
        contentStack.addArrangedSubview(continueBtn)
        
        NSLayoutConstraint.activate([
            continueBtn.heightAnchor.constraint(equalToConstant: 50),
            continueBtn.widthAnchor.constraint(equalTo: contentStack.widthAnchor)
        ])
    }
    
    func addBillRow(to stackView: UIStackView, label: String, value: String, isBold: Bool = false) {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 10
        
        let labelView = UILabel()
        labelView.text = label
        labelView.font = UIFont.systemFont(ofSize: 14)
        labelView.textColor = .gray
        labelView.setContentHuggingPriority(.required, for: .horizontal)
        
        let valueView = UILabel()
        valueView.text = value
        valueView.font = isBold ? UIFont.systemFont(ofSize: 15, weight: .semibold) : UIFont.systemFont(ofSize: 14)
        valueView.textColor = .black
        valueView.numberOfLines = 0
        
        rowStack.addArrangedSubview(labelView)
        rowStack.addArrangedSubview(valueView)
        
        stackView.addArrangedSubview(rowStack)
    }
    
    func createActionButton(icon: String, label: String, action: Selector) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 32)
        stack.addArrangedSubview(iconLabel)
        
        let labelText = UILabel()
        labelText.text = label
        labelText.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        labelText.textColor = .black
        stack.addArrangedSubview(labelText)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        container.addGestureRecognizer(tapGesture)
        
        return container
    }
    
    @objc func shareBill() {
        let billText = """
        ✓ Chuyển tiền thành công
        
        Người nhận: \(transaction.recipientName)
        Số tài khoản: \(transaction.recipientAccount)
        Số tiền: \(transaction.amount) VND
        Nội dung: \(transaction.message)
        Thời gian: \(transaction.timestamp)
        Mã GD: \(transaction.id.prefix(12))
        """
        
        let shareVC = UIActivityViewController(activityItems: [billText], applicationActivities: nil)
        present(shareVC, animated: true)
    }
    
    @objc func saveBillAsImage() {
        let renderer = UIGraphicsImageRenderer(size: billView.bounds.size)
        let image = renderer.image { _ in
            billView.drawHierarchy(in: billView.bounds, afterScreenUpdates: false)
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func saveTemplate() {
        let alertController = UIAlertController(title: "Lưu mẫu", message: "Mẫu chuyển tiền cho '\(transaction.recipientName)' đã được lưu", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    @objc func dismissBill() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
        if error == nil {
            let alert = UIAlertController(title: "Thành công", message: "Biên lai đã được lưu vào thư viện ảnh", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

// MARK: - Transaction History View Controller

class TransactionHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let transactions: [Transaction]
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Lịch sử giao dịch"
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        let transaction = transactions[transactions.count - 1 - indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(transaction.recipientName) - \(transaction.amount) VND"
        content.secondaryText = transaction.timestamp
        content.secondaryTextProperties.color = .gray
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let transaction = transactions[transactions.count - 1 - indexPath.row]
        let billVC = TransactionBillViewController(transaction: transaction)
        navigationController?.pushViewController(billVC, animated: true)
    }
}
