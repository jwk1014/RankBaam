//
//  TopicCreateCustomCameraViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 2. 18..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import AVFoundation

class TopicCreateCustomCameraViewController: UIViewController {

    var topicCreateCustomCameraCaptureButton: UIButton = {
        let topicCreateCustomCameraCaptureButton = UIButton()
        return topicCreateCustomCameraCaptureButton
    }()
    
    var topicCreateCameracaptureSession = AVCaptureSession()
    var backwardCamera: AVCaptureDevice?
    var selfiCamera: AVCaptureDevice?
    var presentDevice: AVCaptureDevice?
    var topicCreatePhotoOutput: AVCapturePhotoOutput?
    var topicCreatecameraPreviewLayer:AVCaptureVideoPreviewLayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewInitConfigure()
        topicCreateCameraSetupDevice()
        topicCreateCameraSetupInputOutput()
        topicCreateSetupPreviewLayer()
        topicCreateCameracaptureSession.startRunning()
        
        
        
        
        topicCreateCustomCameraCaptureButtonConfigure()
    }
    
    fileprivate func viewInitConfigure() {
        self.view.addSubview(topicCreateCustomCameraCaptureButton)
        topicCreateCustomCameraCaptureButton.layer.borderColor = UIColor.white.cgColor
        topicCreateCustomCameraCaptureButton.layer.borderWidth = 3
        topicCreateCustomCameraCaptureButton.backgroundColor = UIColor.rankbaamOrange
        
        topicCreateCustomCameraCaptureButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view).offset(-(height667(50)))
            $0.height.width.equalTo(width375(70))
        }
    }

    func topicCreateCustomCameraCaptureButtonConfigure() {
        topicCreateCustomCameraCaptureButton.layer.borderColor = UIColor.white.cgColor
        topicCreateCustomCameraCaptureButton.layer.borderWidth = 5
        topicCreateCustomCameraCaptureButton.clipsToBounds = true
        topicCreateCustomCameraCaptureButton.layer.cornerRadius = width375(70) / 2
    }
    
    
    func topicCreateCameraSetupDevice() {
        topicCreateCameracaptureSession.sessionPreset = AVCaptureSession.Preset.photo
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backwardCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                selfiCamera = device
            }
        }
        presentDevice = backwardCamera
    }
    
    func topicCreateCameraSetupInputOutput() {
        
        guard let presentDevice = presentDevice else { return }
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: presentDevice)
            topicCreateCameracaptureSession.addInput(captureDeviceInput)
            topicCreatePhotoOutput = AVCapturePhotoOutput()
            if #available(iOS 11.0, *) {
                topicCreatePhotoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            } else {
                // TODO
            }
            topicCreateCameracaptureSession.addOutput(topicCreatePhotoOutput!)
            
            
        } catch {
            print(error)
        }
    }
    
    func topicCreateSetupPreviewLayer() {
        self.topicCreatecameraPreviewLayer = AVCaptureVideoPreviewLayer(session: topicCreateCameracaptureSession)
        self.topicCreatecameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.topicCreatecameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.topicCreatecameraPreviewLayer?.frame = view.frame
        
        self.view.layer.insertSublayer(self.topicCreatecameraPreviewLayer!, at: 0)
    }
    
    @objc func photoCaptureButtonTapped(_ sender: UIButton) {
        self.topicCreatePhotoOutput?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    @objc func switchCamera() {
        topicCreateCameracaptureSession.beginConfiguration()
        
        let newDevice = (presentDevice?.position == AVCaptureDevice.Position.back) ? selfiCamera : backwardCamera
    
        for input in topicCreateCameracaptureSession.inputs {
            topicCreateCameracaptureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        let cameraInput:AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch {
            print(error)
            return
        }
        
        if topicCreateCameracaptureSession.canAddInput(cameraInput) {
            topicCreateCameracaptureSession.addInput(cameraInput)
        }
        
        presentDevice = newDevice
        topicCreateCameracaptureSession.commitConfiguration()
    }
    
    
    
    
}

extension TopicCreateCustomCameraViewController: AVCapturePhotoCaptureDelegate {
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let photoData = photo.fileDataRepresentation() {
            let capturedPhotoImage = UIImage(data: photoData)
            let topicCreateCapturedPhotoController = TopicCreateCapturedPhotoViewController()
            topicCreateCapturedPhotoController.capturedPhoto = capturedPhotoImage
            present(topicCreateCapturedPhotoController, animated: true)
        } else {
            // TODO:
        }
    }
}



