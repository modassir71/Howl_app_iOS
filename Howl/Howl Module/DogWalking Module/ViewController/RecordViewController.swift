//
//  RecordViewController.swift
//  Howl
//
//  Created by apple on 19/10/23.
//

import UIKit
import AVFoundation
import Photos

class RecordViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var navigationView: UIView!
    
    let captureSession = AVCaptureSession()
    var captureVideo: AVCaptureDevice!
    var captureAudio: AVCaptureDevice!
    var videoOutput: AVCaptureMovieFileOutput!
    var videoURL: URL!
    var incidentSaved: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermissions()
        configureCamera()
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
        stopRecordingBtn.layer.cornerRadius = 10.0
        stopRecordingBtn.backgroundColor = ColorConstant.pinkColor
        stopRecordingBtn.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if kDataManager.sirenID != 8 {
            
            kSoundManager.playSiren(index: kDataManager.sirenID,
                                    volume: 1,
                                    testing: false)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
        
        kSoundManager.stopSiren()
    }
    
    // MARK: CAMERA PERMISSIONS
    private func checkPermissions() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: .video) { [self] granted in
                
              if !granted {
                
                kAlertManager.triggerAlertTypeWarning(warningTitle: "PERMISSIONS",
                                                      warningMessage: "Please give permission for this app to use your camera and microphone via the iOS settings menu.",
                                                      initialiser: self)
              }
            }
        
        case .denied, .restricted:
            
              
              kAlertManager.triggerAlertTypeWarning(warningTitle: "PERMISSIONS",
                                                    warningMessage: "Please give permission for this app to use your camera and microphone via the iOS settings menu.",
                                                    initialiser: self)
        default: // IMPOSSIBLE
            ()
        }
        
            
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { [self] granted in
                
                if !granted {
                
                kAlertManager.triggerAlertTypeWarning(warningTitle: "PERMISSIONS",
                                                      warningMessage: "Please give permission for this app to use your camera and microphone via the iOS settings menu.",
                                                      initialiser: self)
              }
            }
        
        case .denied, .restricted:
            
            kAlertManager.triggerAlertTypeWarning(warningTitle: "PERMISSIONS",
                                                  warningMessage: "Please give permission for this app to use your camera and microphone via the iOS settings menu.",
                                                  initialiser: self)
        default: // IMPOSSIBLE
            ()
        }
    }
    
    // MARK: CONFIGURE CAMERA
    private func configureCamera() {
        
        // Begin session configuration
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high
        
        // Confirm device supports video
        let discoverySessionVideo = AVCaptureDevice.DiscoverySession(deviceTypes:
                                                                        [
                                                                            .builtInDualCamera,
                                                                            .builtInTripleCamera,
                                                                            .builtInTelephotoCamera,
                                                                            .builtInWideAngleCamera,
                                                                            .builtInTrueDepthCamera
                                                                        ],
                                                                    mediaType: .video,
                                                                    position: .back)
        
        for device in discoverySessionVideo.devices {
            
            // Set video
            if device.hasMediaType(.video) {
                
                if((device as AnyObject).position == AVCaptureDevice.Position.back) {
                    
                    captureVideo = device
                    captureVideo.unlockForConfiguration()
                    //captureVideo.focusMode = .continuousAutoFocus
                }
            }
        }
        
        // Add video output to save video to URL
        videoOutput = AVCaptureMovieFileOutput()
        
        if captureVideo.hasMediaType(.video) && captureSession.canAddOutput(videoOutput) {
            
            if captureVideo != nil {
                
                do {
                    try captureSession.addInput(AVCaptureDeviceInput(device: captureVideo))
                    
                } catch _ {
                    
                    kAlertManager.triggerAlertTypeWarning(warningTitle: "CAMERA FAILED",
                                                          warningMessage: "Camera failed to start",
                                                          initialiser: self)
                }
            }
            
            captureSession.addOutput(videoOutput)
        }
        
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            
            captureAudio = audioDevice
            do {
                try captureSession.addInput(AVCaptureDeviceInput(device: captureAudio))
            } catch _ {
                // Alert if an issue?
            }
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        let screenHeight = view.frame.height

        previewLayer.frame = CGRect(x: 20,
                                    y: 150,
                                    width: CGFloat(DeviceType.SCREEN_WIDTH) - 40,
                                    height: screenHeight / 2 - 8)

        previewLayer.bounds = CGRect(x: 20,
                                     y: 150,
                                     width: CGFloat(DeviceType.SCREEN_WIDTH) - 40,
                                     height: screenHeight / 2 - 8)
        
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.cornerRadius = 5
        
        self.view.layer.addSublayer(previewLayer)
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
        
        if captureSession.isRunning {
            recordVideo()
        }
    }
    
    // MARK: RECORDING
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        // Video started recording
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
           
           PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL)}) {saved,  error in
           }
           let alert = UIAlertController(title: DogConstantString.incidentTitle, message: DogConstantString.incidentMsg, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default) { _ in
               self.navigationController?.popViewController(animated: true)
           }
           alert.addAction(okAction)
           self.present(alert, animated: true, completion: nil)
           
       }
    
    func recordVideo() {
        
        if captureSession.isRunning && videoOutput != nil {
            
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            videoURL = paths[0].appendingPathComponent("howlincident.mp4")
            
            do {
                try FileManager.default.removeItem(at: videoURL)
            } catch _ {
                // Nothing to do, just removing a file if already in place
            }
            
            videoOutput.startRecording(to: videoURL, recordingDelegate: self)
        }
    }
    
    @IBAction func stopRecordingBtn(_ sender: UIButton) {
        if captureSession.isRunning && videoOutput.isRecording {
            
            // Stop monitoring and save the incident to file
            kMonitorMeLocationManager.stopMonitoringMeWithIncident()
            videoOutput.stopRecording()
        }
    }
    
    
}
