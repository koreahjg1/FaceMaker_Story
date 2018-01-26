//
//  ViewController.swift
//  FaceMaker_Story
//
//  Created by Jonggi Hong on 1/16/18.
//  Modified by Kyungjun Lee on 1/26/18.
//  Copyright © 2018 Jonggi Hong. All rights reserved.
//

import UIKit
import MobileCoreServices   // camera
import Vision   // face detection

class ViewController: UIViewController,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {
    
    var image: UIImage! = nil // store a photo taken by a user
    var btn: FaceAreaButton = FaceAreaButton() // button on face

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setStoryImage(id: 1)
        btn = setFaceButton(id: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStoryImage(id: Int) {
        let background = UIImage(named: "story\(id)")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        //imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.contentMode =  UIViewContentMode.scaleToFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    func setFaceButton(id: Int) -> FaceAreaButton{
        let button = FaceAreaButton(type: UIButtonType.system) as FaceAreaButton
        
        let xPostion:CGFloat = 110
        let yPostion:CGFloat = 60
        let buttonWidth:CGFloat = 90
        let buttonHeight:CGFloat = 90
        
        button.frame = CGRect(x:xPostion, y:yPostion, width:buttonWidth, height:buttonHeight)
        
        button.setTitle("Tap me", for: UIControlState.normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(ViewController.faceButtonAction(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.layer.borderColor = UIColor.white.cgColor //UIColor(red:0.0/255.0, green:122.0/255.0, blue:255.0/255.0, alpha:1).cgColor as CGColor
        button.layer.borderWidth = 7.0
        button.clipsToBounds = true
        
        //button.blink()
        
        self.view.addSubview(button)
        return button
    }
    
    
    @objc func faceButtonAction(_ sender:UIButton!)
    {
        print("Button tapped")
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        /*
        sender.setBackgroundImage(UIImage(named: "face2"), for: UIControlState.normal)
        sender.setTitle("", for: UIControlState.normal)
        */
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
            print("photo is taken")
            detectFace(inputImg: image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func detectFace(inputImg: UIImage) {
        print("start detecting face")
        
        guard let ciImg = CIImage(image: inputImg) else { return }
        
        var orientation: CGImagePropertyOrientation = .up
        switch inputImg.imageOrientation {
        case .up:
            orientation = .up
        case .upMirrored:
            orientation = .upMirrored
        case .down:
            orientation = .down
        case .downMirrored:
            orientation = .downMirrored
        case .left:
            orientation = .left
        case .leftMirrored:
            orientation = .leftMirrored
        case .right:
            orientation = .right
        case .rightMirrored:
            orientation = .rightMirrored
        }
        
        let faceReq = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaceFeatures)
        let reqHandler = VNImageRequestHandler(ciImage: ciImg, orientation: orientation, options: [:])
        do {
            try reqHandler.perform([faceReq])
        } catch {
            print(error)
        }
    }
    
    func handleFaceFeatures(request: VNRequest, error: Error?) {
        print("handleFaceFeatures")
        
        guard let observations = request.results as? [VNFaceObservation] else {
            fatalError("unexpected result type!")
        }
        
        for face in observations {
            cropFaceFromImage(face)
        }
    }
    
    func cropFaceFromImage(_ face: VNFaceObservation) {
        print("addFaceLandmarksToImage")
        
        let w = face.boundingBox.size.width * CGFloat(image.size.width)
        let h = face.boundingBox.size.height * CGFloat(image.size.height)
        let x = face.boundingBox.origin.x * CGFloat(image.size.width) + 140 // for now, added offset to adjust CGRect
//        let y = image.size.height - (face.boundingBox.origin.y * image.size.height) - h
        let y = (1 - face.boundingBox.origin.y) * CGFloat(image.size.height) - h - 150 // for now, added offset
        
        let faceRect = CGRect(x: x, y: y, width: w, height: h)
        guard let faceRef = image.cgImage?.cropping(to: faceRect) else { return }
        let croppedImage = UIImage(cgImage: faceRef, scale: image.scale, orientation: image.imageOrientation)
        
        btn.setBackgroundImage(croppedImage, for: UIControlState.normal)
        btn.setTitle("", for: UIControlState.normal)
        
    }
}

