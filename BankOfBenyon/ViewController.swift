import UIKit

class ViewController: UITabBarController {

    lazy var scanVc:UIViewController = {
        let vc = AccountDetailsScanViewController()
        vc.tabBarItem = UITabBarItem(title: "Scan", image: nil, selectedImage: nil)
        return vc
    }()

    lazy var qrVc:UIViewController = {
        let vc = QRCodeDisplayViewController()
        vc.tabBarItem = UITabBarItem(title: "QR", image: nil, selectedImage: nil)
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers([scanVc, qrVc], animated: false)
    }

}
