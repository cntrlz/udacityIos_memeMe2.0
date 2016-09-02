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
		
		flowLayout.minimumLineSpacing = 0.0
		flowLayout.minimumInteritemSpacing = 0.0
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let optimumSquare = sqrt((view.frame.size.width * view.frame.size.height) / 15.0)
		flowLayout.itemSize = CGSizeMake(optimumSquare, optimumSquare)
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
		let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("MemeDetail")
		let detail = object as! MemeDetailViewController
		detail.meme = memes[indexPath.row]
		
		navigationController!.pushViewController(detail, animated: true)
	}
}
