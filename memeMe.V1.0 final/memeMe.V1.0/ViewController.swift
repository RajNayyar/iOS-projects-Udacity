//
//  ViewController.swift
//  memeMe.V1.0
//
//  Created by Rajpreet on 20/12/17.
//  Copyright © 2017 Rajpreet. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var imageViewer: UIImageView!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let memeTextAttributes:[String : Any] = [
        NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
        NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue : -4.0,
        ]
    
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        imageViewer.contentMode = .scaleAspectFit
        topTextField.defaultTextAttributes=memeTextAttributes
        bottomTextField.defaultTextAttributes=memeTextAttributes
        
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        actionButton.isEnabled = false
        subscribeToKeyboardNotifications()
        
        if imageViewer.image != nil
        {
            actionButton.isEnabled = true
        }
        else
        {
            actionButton.isEnabled = false
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self;
        bottomTextField.delegate = self;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc  func keyboardWillShow(_ notification:Notification) {
        
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y =  getKeyboardHeight(notification) * -1
        }
    }
    
    @objc  func keyboardWillHide(_ notification:Notification)
    {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
     {

     
     if textField == topTextField
     
     {textField.text = nil}
     
     else if textField == bottomTextField
     
     { textField.text = nil}
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.topTextField.resignFirstResponder()
        self.bottomTextField.resignFirstResponder()
    //textField.resignFirstResponder()          // can also be used
        return true
        
    }
    
    
    @IBAction func cancelFunc(_ sender: Any) {
       
        imageViewer.image=nil
        topTextField.text="TOP"
        bottomTextField.text="BOTTOM"
        actionButton.isEnabled = false
    }
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
 
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            imageViewer.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }
  
    @IBAction func shareAction(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let shareActivityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        shareActivityViewController.completionWithItemsHandler = { activity, completed, items, error in
            
            if completed {
                self.save(image: memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(shareActivityViewController, animated: true, completion: nil)
    }
    
    

    
    struct Meme
    {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    func generateMemedImage() -> UIImage {
        
        toolbar.isHidden = true
        navbar.isHidden = true
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolbar.isHidden = false
        navbar.isHidden = false
    
        return memedImage
    }
    
    func save(image: UIImage) {
       
       
        _ =  Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageViewer.image!, memedImage: generateMemedImage())
        
    }
}

