//
//  MemeDetailViewController.swift
//  MemeMe 1.0
//
//  Created by benchmark on 9/1/16.
//  Copyright © 2016 Viktor Lantos. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	
	var meme : Meme!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imageView.image = meme.memedImage
	}
	
	@IBAction func share(sender: AnyObject) {
		let activityController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
		presentViewController(activityController, animated: true, completion:nil)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "editMeme") {
			let editorNav = segue.destinationViewController as! UINavigationController
			let editor = editorNav.viewControllers[0] as! MemeEditorViewController
			editor.meme = meme
		}
	}
}
