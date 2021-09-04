//
//  QRCodeGeneratorViewController.swift
//  QRGR
//
//  Created by ahmed abdalla on 04/09/2021.
//


import UIKit

class QRCodeGeneratorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - OUTLET
    var QRImage : UIImage?
    
    //MARK: - OUTLET
    @IBOutlet var txtURL : UITextField!
    @IBOutlet var imgQR : UIImageView!
    @IBOutlet var btnSave : UIButton!
    
    //MARK: - Generat QR button
    @IBAction func btnGenerateCode(_ sender: UIButton) {
        generateQRCode()
    }
    
    //MARK: - Saving Image here
    @IBAction func btnSaveImage(_ sender: UIButton) {
        guard let selectedImage = QRImage else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    
    //MARK: - Generat QR here
    func generateQRCode(){
        
        guard let stringURl = txtURL.text else {
            return
        }
        
        let data = stringURl.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "InputMessage")
        
        let ciImage = filter?.outputImage
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        let transforImage = ciImage?.transformed(by: transform)
        
        let image = UIImage(ciImage: transforImage!)
        
        imgQR.image = image
        
        btnSave.isEnabled = stringURl != ""
        
        txtURL.resignFirstResponder()
        
        if let output = ciImage?.transformed(by: transform) {
            let context = CIContext()
            guard let cgImage = context.createCGImage(output, from: output.extent) else { return  }
            QRImage =  UIImage(cgImage: cgImage)
        }
        
        
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
}
