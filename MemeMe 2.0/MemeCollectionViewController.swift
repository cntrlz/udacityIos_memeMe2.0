//
//  MemeCollectionViewController.swift
//  MemeMe 1.0
//
//  Created by benchmark on 9/1/16.
//  Copyright © 2016 Viktor Lantos. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {

	@IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
	
	var memes: [Meme] {
		return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let space : CGFloat = 3.0
		let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
		
		flowLayout.minimumLineSpacing = space
		flowLayout.minimumInteritemSpacing = space
		flowLayout.itemSize = CGSizeMake(dimension, dimension)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		collectionView?.reloadData()
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return memes.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
		let meme = memes[indexPath.item]
		cell.imageView.image = meme.memedImage
		return cell
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetail")
		let detail = object as! MemeDetailViewController
		detail.meme = self.memes[indexPath.row]
		
		navigationController!.pushViewController(detail, animated: true)
	}
}
