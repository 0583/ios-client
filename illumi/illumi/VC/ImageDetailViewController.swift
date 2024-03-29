//
//  ImageDetailViewController.swift
//  illumi
//
//  Created by 0583 on 2019/6/28.
//  Copyright © 2019 0583. All rights reserved.
//

import UIKit
import TTGTagCollectionView

class ImageDetailViewController: UIViewController {

    @IBOutlet weak var tagView: TTGTextTagCollectionView!
    @IBOutlet weak var headingLabel: UINavigationItem!
    @IBOutlet weak var imageContentView: UIImageView!
    
    @IBAction func saveToAlbum(_ sender: UIButton) {
        if imageContentView.image == nil {
            promptError("Save Failure", "Cannot Save \(headingLabel.title ?? "unknown") to Album")
            return
        }
        UIImageWriteToSavedPhotosAlbum(imageContentView.image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if (error as NSError?) != nil {
            promptError("Save Failure", "Cannot Save \(headingLabel.title ?? "unknown") to Album")
        } else {
            promptError("Done", "Successfully Saved \(headingLabel.title ?? "unknown") to Album")
        }
    }

    
    var currentImage: illumiImage?
    
    var existedImage: UIImage?
    
    var existedTags: [String]?

    
    func promptError(_ title: String, _ message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.title = "Image Post #\(currentImage?.imageId ?? -1)"
        
        if existedImage == nil {
            currentImage?.getImageContent(imageHandler: { image in
                self.imageContentView.image = image
                self.imageContentView.contentMode = .scaleAspectFit
            }, errorHandler: { errStr in
                self.promptError("Failed to Load Image", "The server reported an “\(errStr)” error.")
            })
        } else {
            self.imageContentView.image = existedImage
            self.imageContentView.contentMode = .scaleAspectFit
        }
        
        if existedTags == nil {
            currentImage?.getImageTags(tagsHandler: { tags in
                for tag in tags {
                    self.tagView.addTag(tag.tagName)
                }
            }, errorHandler: { errStr in
                self.promptError("Failed to Load Tags", "The server reported an “\(errStr)” error.")
            })
        } else {
            tagView.addTags(existedTags!)
        }
        
        tagView.numberOfLines = 1
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
