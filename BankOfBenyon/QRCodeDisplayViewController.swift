import UIKit

class QRCodeDisplayViewController: UIViewController {

    lazy var qrCodeImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(qrCodeImageView)

        qrCodeImageView.snp_makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalTo(300.0)
            make.height.equalTo(300.0)
        }
    }

    override func viewDidAppear(animated: Bool) {
        let sortCode = NSUserDefaults.standardUserDefaults().stringForKey("sortCode")!
        let accountNumber = NSUserDefaults.standardUserDefaults().stringForKey("accountNumber")!

        let userInfo = UserInfoDTO(accountData: UserInfoDTO.AccountData(sortCode: sortCode, accountNumber: accountNumber))

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
