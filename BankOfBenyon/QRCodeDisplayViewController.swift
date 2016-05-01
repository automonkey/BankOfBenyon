import UIKit

class QRCodeDisplayViewController: UIViewController {

    lazy var qrCodeImageView = UIImageView()

    lazy var accountDetailsLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(qrCodeImageView)
        view.addSubview(accountDetailsLabel)

        qrCodeImageView.snp_makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(50.0)
            make.width.equalTo(view).offset(-20.0)
            make.height.equalTo(qrCodeImageView.snp_width)
        }

        accountDetailsLabel.snp_makeConstraints { make in
            make.top.equalTo(qrCodeImageView.snp_bottom).offset(20.0)
            make.left.equalTo(view).offset(20.0)
            make.right.equalTo(view).offset(20.0)
        }
    }

    override func viewDidAppear(animated: Bool) {
        let name = NSUserDefaults.standardUserDefaults().stringForKey("name")!
        let sortCode = NSUserDefaults.standardUserDefaults().stringForKey("sortCode")!
        let accountNumber = NSUserDefaults.standardUserDefaults().stringForKey("accountNumber")!

        accountDetailsLabel.text = "Name: \(name)\nSort code: \(sortCode)\nAccount Number: \(accountNumber)"

        let userInfo = UserInfoDTO(name: name, accountData: UserInfoDTO.AccountData(sortCode: sortCode, accountNumber: accountNumber))

        let data = try! NSJSONSerialization.dataWithJSONObject(userInfo.toDictionary()!, options: NSJSONWritingOptions())

        let filter = CIFilter(name: "CIQRCodeGenerator")

        filter!.setValue(data, forKey: "inputMessage")
        filter!.setValue("Q", forKey: "inputCorrectionLevel")

        let qrCodeImage = filter!.outputImage

        let scaleX = qrCodeImageView.frame.size.width / qrCodeImage!.extent.size.width
        let scaleY = qrCodeImageView.frame.size.height / qrCodeImage!.extent.size.height
        
        let transformedImage = qrCodeImage!.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))

        qrCodeImageView.image = UIImage(CIImage: transformedImage)
    }

}
