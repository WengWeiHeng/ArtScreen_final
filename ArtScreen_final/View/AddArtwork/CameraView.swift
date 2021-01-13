//
//  CameraViewRenew.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/12/26.
//

import UIKit
import AVFoundation

protocol CameraViewDelegate: class {
    func presentPhotoCheck(_ image: UIImage)
}

class CameraView: UIView {
    
    //MARK: - Properties
    weak var delegate: CameraViewDelegate?
    
    var device: AVCaptureDevice!
    var session: AVCaptureSession!
    var output: AVCapturePhotoOutput!
    var tempImage: UIImage!
    
    private let shutterButton: UIButton = {
        let button = UIButton()
        button.setTitle("◯", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 74)
        button.contentMode = .center
        button.backgroundColor = .white
        button.setTitleColor(.black, for: UIControl.State())
        button.setDimensions(width: 80, height: 80)
        button.layer.cornerRadius = 80 / 2
        button.addTarget(self, action: #selector(photoshot), for: .touchUpInside)
//        button.layer.position = CGPoint(x: self.frame.width / 2, y: self.bounds.size.height - 80)
        
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setPicture()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func photoshot(_ sender: AnyObject) {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off
        settings.isAutoStillImageStabilizationEnabled = true
        output.capturePhoto(with: settings, delegate: self)
    }
    
    @objc func retryPhoto(sender: UIButton){
        let subViews = subviews
        for subView in subViews {
            subView.removeFromSuperview()
        }
        setPicture()
    }
    
    @objc func savePhoto(sender: UIButton){
        UIImageWriteToSavedPhotosAlbum(tempImage, self, nil, nil)
        let subViews = subviews
        for subView in subViews {
            subView.removeFromSuperview()
        }
        setPicture()
    }
    
    //MARK: - Helper
    func configureUI() {
        addSubview(shutterButton)
        shutterButton.centerX(inView: self)
        shutterButton.anchor(bottom: bottomAnchor, paddingBottom: 120)
    }
    
    func setPicture(){
        session = AVCaptureSession()
        device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            print("例外発生")
            return
        }
        session.addInput(input)
        output = AVCapturePhotoOutput()
        session.addOutput(output)
        session.sessionPreset = .photo
        
        let pvSize = self.frame.width
        let pvLayer = AVCaptureVideoPreviewLayer(session: session)
        pvLayer.frame = self.bounds
        pvLayer.frame = CGRect(x: 0, y: 100, width: pvSize, height: pvSize)
        pvLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.addSublayer(pvLayer)
        session.startRunning()
    }
}

extension CameraView: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error == nil {
            let outputImageView = UIImageView()
            let pvSize = self.frame.width
            outputImageView.frame = CGRect(x: 0, y: 90, width: pvSize, height: pvSize)
            outputImageView.image = UIImage(data: photo.fileDataRepresentation()!)?.croppingToCenterSquare()
            tempImage = UIImage(data: photo.fileDataRepresentation()!)?.croppingToCenterSquare()
            delegate?.presentPhotoCheck(tempImage)
//            self.addSubview(outputImageView)
//            session.stopRunning()
            
            
            
            //再撮影ボタン
//            let retryBtn = UIButton()
//            retryBtn.setTitle("再撮影", for:.normal)
//            retryBtn.frame = CGRect(x: self.frame.width / 2 - 150, y: self.frame.height - 115, width: 70, height: 70)
//            retryBtn.addTarget(self, action: #selector(retryPhoto), for: .touchUpInside)
//            addSubview(retryBtn)
//            
//            //保存ボタン
//            let saveBtn = UIButton()
//            saveBtn.setTitle("保存", for: .normal)
//            saveBtn.frame = CGRect(x: self.frame.width/2 + 80, y: self.frame.height - 115, width: 70, height: 70)
//            saveBtn.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
//            addSubview(saveBtn)
        }
    }
}
