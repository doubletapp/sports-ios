import Foundation
import UIKit
import AVFoundation
import Photos

protocol CloseScreenDelegate: class {
    func close()
}

protocol MatchSourceDelegate: class {
    func getMatch() -> MatchModel
}

extension CloseScreenDelegate where Self: UIViewController {

    func close() {
        if let _ = presentedViewController {
            DispatchQueue.main.async { [weak self] in
                self?.dismiss(animated: true)
            }
        }
    }
}

class CameraViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
//    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var cameraContainer: UIView!

    weak var closeDelegate: CloseScreenDelegate?
    weak var matchSourceDelegate: MatchSourceDelegate?

    private static let albumTitle = "ZeLights"
    var session: AVCaptureSession?
    var stillVideoOutput: AVCaptureMovieFileOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    var isBackCamera = true
    var isRecording = false
    var gotGalleryAccess = false
    var gotCameraAccess = false
    var gotMicrophoneAccess = false

    var startRecording: Date?
    var stopRecording: Date?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSession.Preset.iFrame1280x720

        activateInput(input: backCameraInput())
        session!.startRunning()
    }

    @IBAction func switchCamera() {
        if isBackCamera {
            activateInput(input: frontCameraInput())
        } else {
            activateInput(input: backCameraInput())
        }

        isBackCamera = !isBackCamera
    }

    @IBAction func closeAction() {
        closeDelegate?.close()
    }

    @IBAction func recordingAction() {
        if !isRecording {
            stillVideoOutput?.startRecording(to: getNewFileURL(), recordingDelegate: self)
            isRecording = true
            recordButton.isSelected = true
            switchCameraButton.isHidden = true
            startRecording = Date()
//            galleryButton.isHidden = true
        } else {
            stillVideoOutput?.stopRecording()
            isRecording = false
            recordButton.isSelected = false
            switchCameraButton.isHidden = false
            stopRecording = Date()
//            galleryButton.isHidden = false
        }
    }

    @IBAction func galleryAction() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = [ "public.movie" ]
        pickerController.sourceType = .photoLibrary

        present(pickerController, animated: true)
    }

    func backCameraInput() -> AVCaptureDeviceInput? {
        if let backCamera = AVCaptureDevice.default(for: .video) {
            var error: NSError?
            var input: AVCaptureDeviceInput!

            do {
                input = try AVCaptureDeviceInput(device: backCamera)
            } catch let error1 as NSError {
                error = error1
                input = nil
                print(error!.localizedDescription)
            }

            return input
        }

        return nil
    }

    func frontCameraInput() -> AVCaptureDeviceInput?  {
        if let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            var error: NSError?
            var input: AVCaptureDeviceInput!

            do {
                input = try AVCaptureDeviceInput(device: backCamera)
            } catch let error1 as NSError {
                error = error1
                input = nil
                print(error!.localizedDescription)
            }

            return input
        }

        return nil
    }

    func activateInput(input: AVCaptureDeviceInput?) {
        session?.inputs.forEach { input in
            session?.removeInput(input)
        }

        if let input = input, session!.canAddInput(input) {
            session!.addInput(input)

            stillVideoOutput = AVCaptureMovieFileOutput()
            
            if session!.canAddOutput(stillVideoOutput!) {
                session!.addOutput(stillVideoOutput!)
                stillVideoOutput!.setOutputSettings(
                    [AVVideoCodecKey: AVVideoCodecType.h264],
                    for: stillVideoOutput!.connection(with: .video)!
                )
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer!.videoGravity = .resizeAspectFill
                videoPreviewLayer!.connection?.videoOrientation = .portrait
                cameraContainer.layer.addSublayer(videoPreviewLayer!)
                videoPreviewLayer!.frame = cameraContainer.bounds
            }
        }
    }

    func getNewFileURL() -> URL {
        return FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
    }
    
    func sendVideo(from url: URL) {
        DispatchQueue.main.async { [weak self] in
            let vc = UIStoryboard(name: "SendVideo", bundle: nil).instantiateInitialViewController() as! SendVideoViewController
            vc.videoUrl = url
            vc.closeDelegate = self?.closeDelegate
            vc.startRecordingDate = self?.startRecording
            vc.stopRecordingDate = self?.stopRecording
            vc.matchSourceDelegate = self?.matchSourceDelegate
            self?.present(vc, animated: true)
        }
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {

    public func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection], error: Error?
    ) {
        sendVideo(from: outputFileURL)
    }

}

extension CameraViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) { [weak self] in
                if let asset = info[.phAsset] as? PHAsset {
                    print(asset)
                    // TODO
                } else if let url = info[.mediaURL] as? URL {
                    self?.saveVideoToGallery(url)
                }
        }
    }

    func saveVideoToAlbum(_ url: URL) {
        guard gotGalleryAccess == true else {
            requestGalleryAccess { [weak self] granted in
                if granted {
                    self?.saveVideoToAlbum(url)
                }
            }
            return
        }
        createAlbum { [weak self] album in
            self?.saveVideoToAlbum(album: album, fileUrl: url)
        }
    }

    func saveVideoToGallery(_ url: URL) {
        guard gotGalleryAccess == true else {
            requestGalleryAccess { [weak self] granted in
                if granted {
                    self?.saveVideoToGallery(url)
                }
            }
            return
        }
        saveVideoToAlbum(album: nil, fileUrl: url)
    }

    private func createAlbum(completion: @escaping((_ album: PHAssetCollection?) -> Void)) {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title = %@", CameraViewController.albumTitle)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                 subtype: .any,
                                                                 options: options)
        if let album = collection.firstObject {
            completion(album)
        } else {
            var placeholder: PHObjectPlaceholder?
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(
                    withTitle: CameraViewController.albumTitle)
                placeholder = request.placeholderForCreatedAssetCollection
            }, completionHandler: { (success, error) -> Void in
                if success, let id = placeholder?.localIdentifier {
                    let fetchResult = PHAssetCollection.fetchAssetCollections(
                        withLocalIdentifiers: [id],
                        options: nil
                    )
                    completion(fetchResult.firstObject)
                } else {
                    if let error = error {
                        print(error)
                    }
                    completion(nil)
                }
            })
        }
    }

    private func requestGalleryAccess(completion: @escaping((_ granted: Bool) -> Void)) {
        let authStatus = PHPhotoLibrary.authorizationStatus()

        switch authStatus {
        case .authorized:
            gotGalleryAccess = true

            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async { [weak self] in
                    let authorized = (status == .authorized)
                    self?.gotGalleryAccess = authorized
                    completion(authorized)
                }
            }
        case .denied:
            completion(false)
            showOpenSettingsForGallery()
        case .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }

    private func requestCameraAccess(completion: @escaping((_ granted: Bool) -> Void)) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch authStatus {
        case .authorized:
            gotCameraAccess = true
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async { [weak self] in
                    self?.gotCameraAccess = granted
                    completion(granted)
                }
            }
        case .denied:
            completion(false)
            showOpenSettingsForCamera()
        case .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }

    private func requestMicrophoneAccess(completion: @escaping((_ granted: Bool) -> Void)) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .audio)

        switch authStatus {
        case .authorized:
            gotMicrophoneAccess = true
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                DispatchQueue.main.async { [weak self] in
                    self?.gotMicrophoneAccess = granted
                    completion(granted)
                }
            }
        case .denied:
            completion(false)
            showOpenSettingsForMicrophone()
        case .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }

    private func saveVideoToAlbum(album: PHAssetCollection?, fileUrl url: URL) {
        var albumRequest: PHAssetCollectionChangeRequest?
        var placeholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            if let album = album {
                albumRequest = PHAssetCollectionChangeRequest(for: album)
            }
            placeholder = request?.placeholderForCreatedAsset
            if let placeholder = placeholder, let albumRequest = albumRequest {
                albumRequest.addAssets([placeholder] as NSFastEnumeration)
            }
        }, completionHandler: { [weak self] (success, error) in
            if success {
                if let id = placeholder?.localIdentifier {
                    let fetchResult =  PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
                    if let asset = fetchResult.firstObject {
                        DispatchQueue.main.async {
                            // TODO:
                        }
                    }
                }
            } else if let error = error {
                print(error)
            }
        })
    }

//    public func imagePickerController(
//        _ picker: UIImagePickerController,
//        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
//    ) {
//
//        DispatchQueue.main.async { [weak self] in
//            if let mediaUrl = info[.mediaURL] as? URL {
//                self?.sendVideo(from: mediaUrl)
//            }
//            picker.dismiss(animated: true)
//        }
//    }

    private func showOpenSettingsForGallery() {
        let message = NSLocalizedString("""
            We need access to you photo and video gallery to process your video. \
            Please provide access to the gallery in the settings.
            """, comment: "")
//        showOpenSettings(message: message)
    }

    private func showOpenSettingsForCamera() {
        let message = NSLocalizedString("""
            We need access to the camera so you can capture video to process. \
            Please provide access to the camera in the settings.
            """, comment: "")
//        showOpenSettings(message: message)
    }

    private func showOpenSettingsForMicrophone() {
        let message = NSLocalizedString("""
            We need access to the microphone for capturing shoot sounds on video. \
            Please provide access to the microphone in the settings.
            """, comment: "")
//        showOpenSettings(message: message)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DispatchQueue.main.async {
            picker.dismiss(animated: true)
        }
    }
}
