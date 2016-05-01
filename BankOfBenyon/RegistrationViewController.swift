import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    lazy var nameField:UITextField = {
        let fieldColour = UIColor(red: 72/255.0, green: 187/255.0, blue: 236/255.0, alpha: 1.0)

        let textField = UITextField()
        textField.addTarget(self, action: #selector(nameUpdate), forControlEvents: UIControlEvents.EditingChanged)
        textField.delegate = self

        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = fieldColour.CGColor

        textField.placeholder = "Enter name"
        return textField
    }()

    lazy var button:UIButton = {

        let fieldColour = UIColor(red: 72/255.0, green: 187/255.0, blue: 236/255.0, alpha: 1.0)

        let button = UIButton()
        button.setTitle("Register", forState: UIControlState.Normal)
        button.setTitleColor(fieldColour, forState: UIControlState.Normal)
        button.layer.cornerRadius = 8.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = fieldColour.CGColor

        button.addTarget(self, action: #selector(register), forControlEvents: UIControlEvents.TouchUpInside)

        button.enabled = false

        return button

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(nameField)
        view.addSubview(button)

        nameField.snp_makeConstraints { make in
            make.centerY.equalTo(view)
            make.left.equalTo(view).offset(20.0)
            make.right.equalTo(view).offset(-20.0)
            make.height.equalTo(50.0)
        }

        button.snp_makeConstraints { make in
            make.bottom.equalTo(view).offset(-20.0)
            make.left.equalTo(view).offset(20.0)
            make.right.equalTo(view).offset(-20.0)
            make.height.equalTo(50.0)
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameField {
            textField.resignFirstResponder()
            return false
        }
        return true
    }

    func nameUpdate() {
        button.enabled = nameField.text?.characters.count > 0
    }

    func register() {
        let name = nameField.text!
        let sortCode = String(format: "%02d-%02d-%02d", arc4random_uniform(99), arc4random_uniform(99), arc4random_uniform(99))
        let accountNumber = String(format: "%06d", arc4random_uniform(999999))

        NSUserDefaults.standardUserDefaults().setObject("\(name)", forKey: "name")
        NSUserDefaults.standardUserDefaults().setObject("\(sortCode)", forKey: "sortCode")
        NSUserDefaults.standardUserDefaults().setObject("\(accountNumber)", forKey: "accountNumber")

        dismissViewControllerAnimated(true, completion: nil)
    }

}
