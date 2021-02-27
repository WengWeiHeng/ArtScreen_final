////
////  CameraView.swift
////  ArtScreen_final
////
////  Created by Heng on 2020/10/23.
////
//
//import UIKit
//import AVFoundation
//
//protocol CameraViewDelegate: class {
//    func presentPhotoCheck(_ image: UIImage)
//}
//
//class CameraView: UIView, AVCapturePhotoCaptureDelegate {
//    
//    //MARK: - Properties
//    weak var delegate: CameraViewDelegate?
//    
//    var captureSession = AVCaptureSession()
//    var mainCamera: AVCaptureDevice?
//    var innerCamera: AVCaptureDevice?
//    var currentDevice: AVCaptureDevice?
//    var photoOutput : AVCapturePhotoOutput?
//    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
//    var checkFont_BackCamera : Bool = false
//    var checkFlash : Bool = false
//    
//    var previewLayer : UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    let viewCameraFeature : UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        
//        let buttonFlash : UIButton = {
//            let button = UIButton()
//            button.setTitleColor(.black, for: .normal)
//            button.setImage(#imageLiteral(resourceName: "Flash"), for: .normal)
//            button.layer.masksToBounds = true
//            button.layer.cornerRadius = 19
//            button.translatesAutoresizingMaskIntoConstraints = false
//            button.addTarget(self, action: #selector(handleTappedFlash), for: .touchUpInside)
//
//            return button
//        }()
//        
//        let buttonTakePhoto : UIButton = {
//            let button = UIButton()
//            button.setTitleColor(.black, for: .normal)
//            button.setImage(#imageLiteral(resourceName: "TakePhoto"), for: .normal)
//            button.backgroundColor = .red
//            button.layer.masksToBounds = true
//            button.layer.cornerRadius = 32
//            button.translatesAutoresizingMaskIntoConstraints = false
//            button.addTarget(self, action: #selector(handleTapTakePhoto), for: .touchUpInside)
//            return button
//        }()
//        
//        let buttonBackCamera : UIButton = {
//            let button = UIButton()
//            button.setTitleColor(.black, for: .normal)
//            button.setImage(#imageLiteral(resourceName: "switch"), for: .normal)
//            button.layer.masksToBounds = true
//            button.layer.cornerRadius = 19
//            button.translatesAutoresizingMaskIntoConstraints = false
//            button.tag = 1
//            button.addTarget(self, action: #selector(handleTappedSwitchCamera(_ :)), for: .touchUpInside)
//            return button
//        }()
//        
//        view.addSubview(buttonFlash)
//        view.addSubview(buttonTakePhoto)
//        view.addSubview(buttonBackCamera)
//        buttonFlash.backgroundColor = .gray
//        buttonTakePhoto.backgroundColor = .gray
//        buttonBackCamera.backgroundColor = .gray
//        buttonFlash.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 13, paddingLeft: 22, width: 38, height: 38)
//        buttonTakePhoto.anchor(top: view.topAnchor, left: view.leftAnchor, paddingLeft: screenWidth / 2 - 32, width: 64, height: 64)
//        buttonBackCamera.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 15, paddingRight: 22, width: 38, height: 38)
//        
//        return view
//    }()
//    
//    //MARK: - Init
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//        setupCaptureSession()
//        setupDevice()
//        setupInputOutput()
//        setupPreviewLayer()
//        captureSession.startRunning()
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK: - Selectors
//    @objc func handleTappedFlash() {
//        checkFlash = !checkFlash
//        print(checkFlash)
//    }
//        
//    @objc func handleTapTakePhoto() {
//        print("Take Photo ...")
//        let settings = AVCapturePhotoSettings()
//        // フラッシュの設定
//        settings.flashMode = .auto
//        // カメラの手ぶれ補正
////        settings.isAutoStillImageStabilizationEnabled = true
//        settings.isAutoVirtualDeviceFusionEnabled = true
//        // 撮影された画像をdelegateメソッドで処理
//        self.photoOutput?.capturePhoto(with: settings, delegate: self as AVCapturePhotoCaptureDelegate)
//       
//        if (checkFlash == false ){
//            self.flashOff(device: currentDevice!)
//        } else {
//            self.flashOn(device: currentDevice!)
//        }
//        captureSession.commitConfiguration()
//
//    }
//    
//    @objc func handleTappedSwitchCamera(_ sender : UIButton) {
//        reload()
//    }
//    
//    //MARK: - Helpers
//    func reload() {
//        if let session : AVCaptureSession = captureSession {
//            //Remove existing input
//            guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
//                return
//            }
//
//            //Indicate that some changes will be made to the session
//            session.beginConfiguration()
//            session.removeInput(currentCameraInput)
//
//            //Get new input
//            var newCamera: AVCaptureDevice! = nil
//            if let input = currentCameraInput as? AVCaptureDeviceInput {
//                if (input.device.position == .back) {
//                    newCamera = cameraWithPosition(position: .front)
//                } else {
//                    newCamera = cameraWithPosition(position: .back)
//                }
//            }
//
//            //Add input to session
//            var err: NSError?
//            var newVideoInput: AVCaptureDeviceInput!
//            do {
//                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
//            } catch let err1 as NSError {
//                err = err1
//                newVideoInput = nil
//            }
//
//            if newVideoInput == nil || err != nil {
//                print("Error creating capture device input: \(err?.localizedDescription)")
//            } else {
//                session.addInput(newVideoInput)
//            }
//            session.commitConfiguration()
//        }
//    }
//
//    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
//    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
//        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
//        for device in discoverySession.devices {
//            if device.position == position {
//                return device
//            }
//        }
//
//        return nil
//    }
//    
//    private func flashOn(device:AVCaptureDevice){
//        do {
//            if (device.hasTorch) {
//                try device.lockForConfiguration()
//                device.torchMode = .on
//                device.flashMode = .on
//                device.unlockForConfiguration()
//            }
//        } catch {
//            print("Device tourch Flash Error ");
//        }
//    }
//    
//    private func flashOff(device:AVCaptureDevice) {
//       do {
//           if (device.hasTorch) {
//               try device.lockForConfiguration()
//               device.torchMode = .off
//               device.flashMode = .off
//               device.unlockForConfiguration()
//           }
//       } catch {
//           //DISABEL FLASH BUTTON HERE IF ERROR
//           print("Device tourch Flash Error ");
//       }
//   }
//    
//    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
//                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
//                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
//                     resolvedSettings: AVCaptureResolvedPhotoSettings,
//                     bracketSettings: AVCaptureBracketedStillImageSettings?,
//                     error: Error?) {
//        // get captured image
//        // Make sure we get some photo sample buffer
//        guard error == nil,
//        let photoSampleBuffer = photoSampleBuffer else {
//            print("Error capturing photo: \(String(describing: error))")
//            return
//        }
//        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
//        guard let imageData =
//        AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
//            return
//        }
//        // Initialise a UIImage with our image data
//        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
//        
//        if let image = capturedImage {
//            // Save our captured image to photos album
//            let y = (image.size.height - image.size.width) / 2
//            let origin = CGPoint(x: 0.0, y: y)
//            let size = CGSize(width: image.size.width, height: image.size.width)
//            let rect = CGRect(origin: origin, size: size)
//            let croppingRect = image.imageOrientation.isLandscape ? rect.switched : rect
//            delegate?.presentPhotoCheck(trimImage(image: image, area: croppingRect)!)
//        }
//    }
//    
//    func trimImage(image: UIImage, area: CGRect) -> UIImage? {
//        guard let cgImage = image.cgImage else { return nil }
//        guard let imageCropping = cgImage.cropping(to: area) else { return nil }
//        let trimImage = UIImage(cgImage: imageCropping, scale: image.scale, orientation: image.imageOrientation)
//
//        return trimImage
//    }
//
//    func setupView() {
//        // Do any additional setup after loading the view.
//        self.addSubview(previewLayer)
//        self.addSubview(viewCameraFeature)
//        self.backgroundColor = .black
//        viewCameraFeature.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 120, height: 64)
//    }
//}
//
////MARK: - Extension
//extension CameraView{
//    // カメラの画質の設定
//    func setupCaptureSession() {
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//    }
//
//    // デバイスの設定
//    func setupDevice() {
//        // カメラデバイスのプロパティ設定
//        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
//        // プロパティの条件を満たしたカメラデバイスの取得
//        let devices = deviceDiscoverySession.devices
//
//        for device in devices {
//            if device.position == AVCaptureDevice.Position.back {
//                mainCamera = device
//            } else if device.position == AVCaptureDevice.Position.front {
//                innerCamera = device
//            }
//        }
//        // 起動時のカメラを設定
//        if checkFont_BackCamera == false {
//            currentDevice = mainCamera
//        } else {
//            currentDevice = innerCamera
//        }
//        
//    }
//
//    // 入出力データの設定
//    func setupInputOutput() {
//        do {
//            // 指定したデバイスを使用するために入力を初期化
//            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
//            // 指定した入力をセッションに追加
//            captureSession.addInput(captureDeviceInput)
//            // 出力データを受け取るオブジェクトの作成
//            photoOutput = AVCapturePhotoOutput()
//            // 出力ファイルのフォーマットを指定
//            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
//            captureSession.addOutput(photoOutput!)
//        } catch {
//            print(error)
//        }
//    }
//
//    // カメラのプレビューを表示するレイヤの設定
//    func setupPreviewLayer() {
//        // 指定したAVCaptureSessionでプレビューレイヤを初期化
//        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        // プレビューレイヤが、カメラのキャプチャーを縦横比を維持した状態で、表示するように設定
//        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        // プレビューレイヤの表示の向きを設定
//        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
//
//        self.cameraPreviewLayer?.frame = CGRect(x: 0, y: 94, width: screenWidth, height: screenWidth)
//        self.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
//    }
//
//    // ボタンのスタイルを設定
//    func styleCaptureButton() {
////        cameraButton.layer.borderColor = UIColor.white.cgColor
////        cameraButton.layer.borderWidth = 5
////        cameraButton.clipsToBounds = true
////        cameraButton.layer.cornerRadius = min(cameraButton.frame.width, cameraButton.frame.height) / 2
////        button.layer.borderColor = UIColor.white.cgColor
////        button.layer.borderWidth = 5
////        button.clipsToBounds = true
////        button.layer.cornerRadius = min(cameraButton.frame.width, cameraButton.frame.height) / 2
//    }
//}
