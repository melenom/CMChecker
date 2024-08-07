//
//  CMChecker.swift
//  CameraAndMicrophoneCheck
//
//  Created by ZZZ on 2024/7/9.
//

import Foundation
import AVFoundation

public class CMChecker {
    private init() {}
    public static let shared = CMChecker()
    typealias PermissionCompletionHandler = (Bool) -> Void
    
    private func requestMicrophonePermission(completion: @escaping PermissionCompletionHandler) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    private func requestCameraPermission(completion: @escaping PermissionCompletionHandler) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    private func checkMicrophonePermissionStatus() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .audio)
    }
    
    private func checkCameraPermissionStatus() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    private func showPermissionAlert(for permission: String) {
        let alertController = UIAlertController(title: "Permission Denied", message: "You need to allow access to \(permission) in order to use this feature.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Go Setting", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        if let vc = getRootVC()?.presentedViewController {
            vc.present(alertController, animated: true, completion: nil)
        }
        else {
            getRootVC()?.present(alertController, animated: true, completion: nil)
        }
       
    }
    private func getRootVC()->UIViewController? {
        var rootVC:UIViewController?
        if #available(iOS 15.0, *) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            let vc = window?.rootViewController
            rootVC = vc
        } else {
            rootVC = UIApplication.shared.windows.first?.rootViewController
        }
        return rootVC
    }
    public func check() -> Bool {
        let m_state = checkMicrophonePermissionStatus()
        let c_state = checkCameraPermissionStatus()
        
        if m_state == .authorized, c_state == .authorized {
            return true
        }
        
        if m_state == .denied {
            self.showPermissionAlert(for: "Microphone")
            return false
        }
        
        if m_state == .notDetermined {
            requestMicrophonePermission { [weak self] authorized in
                _ = self?.check()
            }
        }
        
        if c_state == .denied {
            self.showPermissionAlert(for: "Camera")
            return false
        }
        if c_state == .notDetermined {
            requestCameraPermission { [weak self] authorized in
                _ = self?.check()
            }
        }
        return false
    }
}
