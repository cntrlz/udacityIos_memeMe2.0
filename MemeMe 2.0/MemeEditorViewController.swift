//
//  MemeEditorViewController.swift
//  MemeMe 1.0
//
//  Created by benchmark on 8/31/16.
//  Copyright © 2016 Viktor Lantos. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

	@IBOutlet weak var previewImageView: UIImageView!
	@IBOutlet weak var snapshotView: UIView!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var textFieldTop: UITextField!
	@IBOutlet weak var textFieldBottom: UITextField!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	
	var meme : Meme!
	
	enum DefaultText : String {
		case Top = "TOP"
		case Bottom = "BOTTOM"
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Register our UIImageView for taps so we can dismiss the keyboard in a more intuitive fashion
		let imageTap = UITapGestureRecognizer(target: self, action: #selector(MemeEditorViewController.dismissKeyboard))
		previewImageView.addGestureRecognizer(imageTap)
		previewImageView.userInteractionEnabled = true
		
		setupTextField(textFieldTop)
		setupTextField(textFieldBottom)
		
		// If we have a meme loaded up, or sent from another controller, use that
		if meme != nil {
			previewImageView.image = meme.originalImage
			textFieldTop.text = meme.topText
			textFieldBottom.text = meme.bottomText
		}
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		// Check to see if our device has a camera. If it does not support one, disable our camera button
		if !UIImagePickerController.isSourceTypeAvailable(.Camera){
			cameraButton.enabled = false
		}
		
		subscribeToKeyboardNotifications()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		unsubscribeFromKeyboardNotifications()
	}
	
	func setupTextField(textfield : UITextField) {
		let style = NSMutableParagraphStyle()
		style.alignment = .Center
		
		let memeTextAttributes = [
			NSStrokeColorAttributeName : UIColor.blackColor(),
			NSForegroundColorAttributeName : UIColor.whiteColor(),
			NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
			NSStrokeWidthAttributeName : -4.0,
			NSParagraphStyleAttributeName : style
		]
		
		textfield.defaultTextAttributes = memeTextAttributes
		textfield.autocorrectionType = UITextAutocorrectionType.No
	}

    // MARK: - User Actions
	@IBAction func showCamera(sender: AnyObject) {
		pickImageFromSource(.Camera)
	}
	
	@IBAction func showAlbum(sender: AnyObject) {
		pickImageFromSource(.PhotoLibrary)
	}
	
	@IBAction func saveCurrentMeme(sender: AnyObject) {
		if previewImageView.image != nil{
			save(makeMeme())
		} else {
			showNoImageAlert()
		}
	}
	
	func pickImageFromSource(source: UIImagePickerControllerSourceType){
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = source
		imagePicker.allowsEditing = true
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	@IBAction func share(sender: AnyObject) {
		if (previewImageView.image != nil) {
			let meme = makeMeme()
			let activityController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
			activityController.completionWithItemsHandler = { activity, success, items, error in
				if success {
					self.save(meme)
				}
			}
			presentViewController(activityController, animated: true, completion:nil)

		} else {
			showNoImageAlert()
		}
	}
	
	@IBAction func cancel(sender: AnyObject) {
		view.endEditing(true)
		previewImageView.image = nil
		shareButton.enabled = false
		textFieldTop.text = DefaultText.Top.rawValue
		textFieldBottom.text = DefaultText.Bottom.rawValue
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: - Alerts
	func showNoImageAlert(){
		let controller = UIAlertController()
		controller.title = "No Image!"
		controller.message = "Please select an image first"
		let dismiss = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
		controller.addAction(dismiss)
		
		self .presentViewController(controller, animated: true, completion: nil)
	}
	
	// MARK: - Images and Saving
	func makeMeme() -> Meme {
		let memedImage : UIImage = generateMemedImage()
		let meme = Meme(topText: textFieldTop.text!, bottomText:textFieldBottom.text!, originalImage: previewImageView.image!, memedImage: memedImage)
		return meme
	}
	
	func save(meme: Meme) {
		(UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func generateMemedImage() -> UIImage {
		// Render just the snapshot view to an image
		UIGraphicsBeginImageContext(snapshotView.frame.size)
		snapshotView.drawViewHierarchyInRect(CGRectMake(0, 0, snapshotView.frame.size.width, snapshotView.frame.size.width), afterScreenUpdates: true)
		let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return memedImage
	}
	
	// MARK: - Text Field Delegate Methods
	func textFieldDidBeginEditing(textField: UITextField) {
		if textField.text == DefaultText.Top.rawValue || textField.text == DefaultText.Bottom.rawValue {
			textField.text = ""
		}
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		if textField.text == "" {
			textField.text = textField == textFieldTop ? DefaultText.Top.rawValue : DefaultText.Bottom.rawValue
		}
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	// MARK: - Image Picker Delegate Methods
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
			previewImageView.image = image
			shareButton.enabled = true
		}
		
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: - Keyboard Management
	func subscribeToKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	func unsubscribeFromKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name:
			UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name:
			UIKeyboardWillHideNotification, object: nil)
	}
	
	func keyboardWillShow(notification: NSNotification) {
		if textFieldBottom.isFirstResponder(){
			view.frame.origin.y = getKeyboardHeight(notification) * (-1)
		} else if textFieldTop.isFirstResponder(){
			view.frame.origin.y = 0;
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		view.frame.origin.y = 0
	}
	
	func getKeyboardHeight(notification: NSNotification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
		return keyboardSize.CGRectValue().height
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
}
