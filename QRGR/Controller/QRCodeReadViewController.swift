//
//  QRCodeReadViewController.swift
//  QRGR
//
//  Created by ahmed abdalla on 04/09/2021.
//

import AVFoundation
import UIKit

class QRCodeReadViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanQRCode()
        
        // Do any additional setup after loading the view.
    }
    //MARK: - Variable
    var stringURl = ""
    
    //MARK: - Generate QR Button
    @IBAction func btnGenerateCode(_ sender: Any) {
        moveToGenerateQRCode()
    }
    
    //MARK: - Fetech QR Data
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        print("Capturing")
        if metadataObjects.count > 0 {
            print("no Capturing")
            let machineRadeable = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if machineRadeable.type == AVMetadataObject.ObjectType.qr {
                stringURl = machineRadeable.stringValue!
                redirectAlert()
            }
        }
    }
    
    //MARK: - Camera Scann for QR
    func scanQRCode()  {
        let avCaptureSession = AVCaptureSession()
        
        guard let avCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("no Camera")
            return
        }
        
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("faild to init camera")
            return
        }
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        avCaptureMetadataOutput.metadataObjectTypes = [.qr]
        
        let avCaptureVideoPreview = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreview.videoGravity = .resizeAspectFill
        
        avCaptureVideoPreview.frame = self.view.frame
        
        self.view.layer.addSublayer(avCaptureVideoPreview)
        
        avCaptureSession.startRunning()
        
    }
    
    //MARK: - Move to Generat QR Screen
    func moveToGenerateQRCode(){
        
        DispatchQueue.main.async  { [weak self] in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "kQRCodeGeneratorViewController") as! QRCodeGeneratorViewController
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    //MARK: - Alert To redirct QR Data
    private func redirectAlert(){
        let alert = UIAlertController(title: "Redirect", message: "Woudl you want to open \(stringURl)", preferredStyle: .alert)
        let go = UIAlertAction(title: "Go", style: .default) {  [weak self] _ in
            guard let Url = URL(string : self?.stringURl ?? "") else { return }
            UIApplication.shared.open(Url)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(go)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
}
