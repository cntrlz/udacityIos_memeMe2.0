//
//  MemeTableViewController.swift
//  MemeMe 1.0
//
//  Created by benchmark on 9/1/16.
//  Copyright © 2016 Viktor Lantos. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
	var memes: [Meme] {
		return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK: - TableView
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return memes.count
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100.0
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! MemeTableViewCell
		let meme = memes[indexPath.row]
		cell.title?.text = meme.topText + " / " + meme.bottomText
		cell.memeImage?.image = meme.memedImage
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let detail = storyboard!.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetailViewController
		detail.meme = memes[indexPath.row]
		navigationController!.pushViewController(detail, animated: true)

	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == UITableViewCellEditingStyle.Delete{
			(UIApplication.sharedApplication().delegate as! AppDelegate).removeMemeAtIndex(indexPath.row)
			tableView.reloadData()
		}
	}
}
