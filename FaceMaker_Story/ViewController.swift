//
//  ViewController.swift
//  FaceMaker_Story
//
//  Created by Jonggi Hong on 1/16/18.
//  Copyright © 2018 Jonggi Hong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setStoryImage(id: 1)
        setFaceButton(id: 1)
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
        sender.setBackgroundImage(UIImage(named: "face2"), for: UIControlState.normal)
        sender.setTitle("", for: UIControlState.normal)
    }
}

