//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by CURTIS MCMILLIN on 6/19/16.
//  Copyright © 2016 CURTIS MCMILLIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textFieldTop.delegate = self
        textFieldTop.text = "TOP"
        textFieldTop.textAlignment = .Center
        
        textFieldBottom.delegate = self
        textFieldBottom.text = "BOTTOM"
        textFieldBottom.textAlignment = .Center
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

