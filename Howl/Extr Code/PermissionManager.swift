//
//  PermissionManager.swift
//  Howl
//
//  Created by apple on 29/11/23.
//

import AVFoundation
import Photos

class PermissionManager {
    static let shared = PermissionManager()

    private init() {}

    func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch cameraAuthorizationStatus {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }

    func requestGalleryPermission(completion: @escaping (Bool) -> Void) {
        let photoLibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch photoLibraryAuthorizationStatus {
        case .authorized:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                completion(status == .authorized)
            }
        case .denied, .restricted:
            completion(false)
        case .limited:
            // Handle limited access - Prompt user to manage access
            // Present a UI that guides the user to manage their access level
            // e.g., show a button that opens the Settings app
            completion(false)
        @unknown default:
            completion(false)
        }
    }

}

