import UIKit
import SnapKit
import AVFoundation

class AccountDetailsScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    lazy var cameraView:UIView = {
        let view = UIView()
        return view
    }()

    lazy var qrCodeFrameView:UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.greenColor().CGColor
        view.layer.borderWidth = 2
        return view
    }()

    lazy var scanButton:UIButton = {
        let fieldColour = UIColor(red: 72/255.0, green: 187/255.0, blue: 236/255.0, alpha: 1.0)

        let button = UIButton()
        button.setTitle("Scan", forState: UIControlState.Normal)
        button.setTitleColor(fieldColour, forState: UIControlState.Normal)
        button.layer.cornerRadius = 8.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = fieldColour.CGColor

        button.addTarget(self, action: #selector(startStopReading), forControlEvents: UIControlEvents.TouchUpInside)

        return button
    }()

    var isReading = false
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(cameraView)
        cameraView.addSubview(qrCodeFrameView)
        view.addSubview(scanButton)

        cameraView.snp_makeConstraints { make in
            let margin = 20.0
            make.top.equalTo(view).inset(margin)
            make.left.equalTo(view).inset(margin)
            make.right.equalTo(view).inset(margin)
        }

        scanButton.snp_makeConstraints { make in
            let margin = 20.0
            let bottomMargin = 100.0
            make.top.equalTo(cameraView.snp_bottom).offset(margin)
            make.bottom.equalTo(view).offset(-bottomMargin)
            make.left.equalTo(view).offset(margin)
            make.right.equalTo(view).offset(-margin)
            make.height.equalTo(50.0)
        }

        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)

        captureSession = AVCaptureSession()

        do {
            let input: AnyObject! = try AVCaptureDeviceInput.init(device: captureDevice)
            captureSession?.addInput(input as! AVCaptureInput)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        }
        catch let error as NSError {
            print("\(error.localizedDescription)")
        }
    }

    func startStopReading() {
        if !isReading {
            startReading()
        } else {
            stopReading()
        }
    }

    func startReading() {
        isReading = true
        captureSession?.startRunning()
        videoPreviewLayer?.frame = cameraView.layer.bounds
        cameraView.layer.addSublayer(videoPreviewLayer!)
        cameraView.bringSubviewToFront(qrCodeFrameView)
    }

    func stopReading() {
        isReading = false
        captureSession?.stopRunning()
    }

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView.frame = CGRectZero
            print("No QR code is detected")
            return
        }

        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if metadataObj.type == AVMetadataObjectTypeQRCode {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView.frame = barCodeObject.bounds;

            if let stringData = metadataObj.stringValue {

                if let accountDetails = accountDetailsFromJson(stringData),
                    sortCode = accountDetails.accountData?.sortCode,
                    accNo = accountDetails.accountData?.accountNumber {

                    stopReading()

                    let title = "Account Details"
                    let message = "Name: \(accountDetails.name)\nSort Code: \(sortCode)\nAccount Number: \(accNo)"

                    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)

                    let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alert.addAction(cancelAction)

                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }

}

func accountDetailsFromJson(jsonData:String) -> UserInfoDTO? {

    guard let jsonData = jsonData.dataUsingEncoding(NSUTF8StringEncoding) else {
        return nil
    }

    do {
        guard let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions()) as? [String:AnyObject] else {
            return nil
        }

        return UserInfoDTO(fromDictionary: jsonObject)
    }
    catch let error as NSError {
        print("\(error.localizedDescription)")
        return nil
    }
}
