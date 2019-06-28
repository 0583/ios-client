//
//  UploadViewController.swift
//  illumi
//
//  Created by 0583 on 2019/6/27.
//  Copyright © 2019 0583. All rights reserved.
//

import UIKit
import ImagePicker
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

class UploadViewController: UIViewController, ImagePickerDelegate {
    
    func promptError(_ title: String, _ message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        // Do nothing
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        NSLog("done pressed")
        imagePicker.dismiss(animated: true, completion: nil)
        if images.count >= 1 {
            
            let loadingAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating();
            
            loadingAlert.view.addSubview(loadingIndicator)
            
            self.present(loadingAlert, animated: true, completion: nil)
            
            let contentImage = images.first!
            guard let jpegData = contentImage.jpegData(compressionQuality: 0.5) else {
                return
            }
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(jpegData, withName: "file.jpeg", fileName: "NewImage.jpg", mimeType: "image/jpeg")

            },to: illumiUrl.imagePostUrl, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        guard let result = response.result.value else { return }
                        loadingAlert.dismiss(animated: true, completion: {
                            self.promptError("Done", "Image Upload Complete")
                        })
                        
                        print("json: \(result)")
                    }

                    upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                        print("image upload progress \(progress.fractionCompleted)")
                    }
                case .failure(let encodingError):
                    loadingAlert.dismiss(animated: true, completion: {
                        self.promptError("Upload Failure", "Server reported an “\(encodingError.localizedDescription)” error")
                    })
                }
            })
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        NSLog("cancel pressed")
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pickAnImage(_ sender: UIButton) {
        let configuration = Configuration()
        configuration.doneButtonTitle = "Upload"
        configuration.noImagesTitle = "There's no image here!"
        configuration.recordLocation = false
        
        let imagePickerController = ImagePickerController(configuration: configuration)
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}
