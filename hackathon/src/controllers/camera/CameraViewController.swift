import Foundation
import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var cameraContainer: UIView!

    var session: AVCaptureSession?
    var stillVideoOutput: AVCaptureMovieFileOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    var isBackCamera = true
    var isRecording = false

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

    @IBAction func recordingAction() {
        if !isRecording {
            stillVideoOutput?.startRecording(to: getNewFileURL(), recordingDelegate: self)
            isRecording = true
            recordButton.isSelected = true
            switchCameraButton.isHidden = true
        } else {
            stillVideoOutput?.stopRecording()
            isRecording = false
            recordButton.isSelected = false
            switchCameraButton.isHidden = false
        }
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
            .appendingPathComponent(UUID().uuidString)
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {

    public func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection], error: Error?
    ) {
        // save recorded video
        print("Video recorded to", outputFileURL.absoluteString)
    }

}
