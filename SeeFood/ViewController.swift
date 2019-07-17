//
//  ViewController.swift
//  SeeFood
//
//  Created by Nabil Arbouz on 7/15/19.
//  Copyright © 2019 Nabil Arbouz. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var pictureImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
  
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageUserPicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            pictureImageView.image = imageUserPicked
            
            guard let ciImage = CIImage(image: imageUserPicked) else {
                fatalError("could not convert the image into a core image image")
            }
            
            detect(image: ciImage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image : CIImage){
        guard let imageModel = try? VNCoreMLModel(for: Inceptionv3().model) else {
             fatalError("could not create a model using inception v3")
        }
        
        let request = VNCoreMLRequest(model: imageModel) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else { fatalError("Could not generate results from the ml model")
            }
            if let firstResult = results.first {
//                if firstResult.identifier.contains("hot dog") {
//                    self.navigationItem.title = "Hotdog!"
//                } else {
//                    self.navigationItem.title = "Not Hotdog!!!"
//                }
                self.navigationItem.title = firstResult.identifier
            }

        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print("could not perform the request \(error)")
        }
    
    }
    
}

