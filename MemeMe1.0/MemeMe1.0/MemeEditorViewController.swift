//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by CURTIS MCMILLIN on 6/19/16.
//  Copyright © 2016 CURTIS MCMILLIN. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var meme = Meme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        setDefaults(textFieldTop)
        setDefaults(textFieldBottom)
        setDefaultText()
    }
    
    func setDefaults(textField:UITextField){
        print("setDefaults")
        
        let memeTextAttribues = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 28)!,
            NSStrokeWidthAttributeName: -3.3
        ]
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttribues
        textField.textAlignment = .Center
    }
    
    @IBAction func shareThis(sender: AnyObject) {
        print("shareThis")
        
        let image: UIImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            //do some action
            self.saveMeme()
        }
        
        presentViewController(activityViewController, animated: true) {
            print("sharedit")
        }
    }
    
    func saveMeme() {
        print("saveMeme")
        
        meme.bottomText = textFieldBottom.text
        meme.topText = textFieldTop.text
        meme.originalImage = self.imagePickerView.image
        meme.memeImage = generateMemedImage()
        
        addMemeToCollection(meme)
        
        displaySentMemes()
    }
    
    func displaySentMemes() {
        print("displaySentMemes")
        
        let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        let tabViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeTabBarViewController") as! MemeTabBarViewController
        appDelegate.window?.rootViewController = tabViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func addMemeToCollection(theMeme:Meme){
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(theMeme)
    }
    
    func generateMemedImage() -> UIImage {
        print ("generatedImage")
        
        toolBar.hidden = true
        navBar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolBar.hidden = false
        navBar.hidden = false
        
        return memedImage
    }
    
    @IBAction func cancelThis(sender: AnyObject) {
        print("cancelThis")
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    func setDefaultText(){
        print("setDefaultText")
        
        textFieldTop.text = "TOP"
        textFieldBottom.text = "BOTTOM"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
        setToolbarButtons()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
        
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func setToolbarButtons() {
        print("setToolbarButtons")
        
        shareButton.enabled = imagePickerView.image != nil
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        print("pickAnImage")
        
        pickImage(.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        print("pickAnImageFromCamera")
        
        pickImage(.Camera)
    }
    
    func pickImage(type:UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = type
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("imagePickerController")
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        print("subscribeToKeyboardNotifications")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        print("unsubscribeFromKeyboardNotifications")
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("textFieldDidBeginEditing")
        
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
        
        if textFieldBottom.isFirstResponder() {
            // slide the view up
            //self.view.frame.origin.y -= getKeyboardHeight(notification)
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("keyboardWillHide")
        
        if textFieldBottom.isFirstResponder() {
            // slide the view back down
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        print("getKeyboardHeight")
        
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.CGRectValue().height
    }
}