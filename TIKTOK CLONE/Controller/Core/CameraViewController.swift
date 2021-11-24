//
//  CameraViewController.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//
import AVFoundation
import UIKit

class CameraViewController: UIViewController {
    
    private let recordButton : RecordButton = RecordButton()
    private var previewLayer : AVPlayerLayer?
    //capture session
    var captureSession = AVCaptureSession()
    //capture device
    var videocaptureDevice: AVCaptureDevice?
    //capture output
    var captureOutput = AVCaptureMovieFileOutput()
    //capture preview
    var capturePreviewLayer : AVCaptureVideoPreviewLayer?
    
    var recordedVideoURL : URL?
    
    private let cameraView : UIView = {
       let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    
    
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraView)
        view.addSubview(recordButton)
        view.backgroundColor = .systemBackground
        setupCamera()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        // Do any additional setup after loading the view.
        recordButton.addTarget(self, action: #selector(didTapRecordButton), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        let size : CGFloat = 70
        recordButton.frame = CGRect(x: (view.width - size)/2, y: view.height - view.safeAreaInsets.bottom - size - 5, width: size, height: size)
        
    }
    
    @objc private func didTapClose() {
        recordButton.isHidden = false
        if  previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
            
        }else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }

    }
    
    
    
    func setupCamera(){
        //Add devices
        if let audioDevice = AVCaptureDevice.default(for: .audio){
            
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
            if let audioInput = audioInput {
                if captureSession.canAddInput(audioInput){
                    captureSession.addInput(audioInput)
                }
            }
 
        }
        
        if let videoDevice = AVCaptureDevice.default(for: .video){
            if let videoInput = try? AVCaptureDeviceInput(device: videoDevice){
                if captureSession.canAddInput(videoInput){
                    captureSession.addInput(videoInput)
                }
            }
        }
        
        //update session
        captureSession.sessionPreset = .hd1280x720
        
        if captureSession.canAddOutput(captureOutput){
            captureSession.addOutput(captureOutput)
        }
        //configure preview
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }
        //enable camera start
        captureSession.startRunning()
    }
    
    
   @objc private  func didTapRecordButton() {
       if captureOutput.isRecording {
           //stop recording
           captureOutput.stopRecording()
           recordButton.toggle(for: .notRecording)
       }
       else {
           guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
               return
           }
           url.appendPathComponent("video.mov")
           

           recordButton.toggle(for: .recording)
           try? FileManager.default.removeItem(at: url) //throws when deleting an empty path but we dont care as we just want to replace it with new video
           captureOutput.startRecording(to: url,
                                        recordingDelegate: self)
       }
    }
    
}

extension CameraViewController :AVCaptureFileOutputRecordingDelegate{
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            print(error)
            let alert = UIAlertController(title: "Whoops", message: "Unable to record video", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        recordedVideoURL = outputFileURL
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))
        print("Finished recording to url \(outputFileURL.absoluteString)")
        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        if let previewLayer = previewLayer{
            recordButton.isHidden = true
            cameraView.layer.addSublayer(previewLayer)
            previewLayer.player?.play()
        }
        
    }
    
    
    @objc func didTapNext() {
        //Push caption controller
        guard let url = recordedVideoURL else {
            return
        }
        let vc = CaptionViewController(videoURL: url)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
