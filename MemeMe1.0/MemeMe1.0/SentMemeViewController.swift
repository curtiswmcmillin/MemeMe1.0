//
//  SentMemeViewController.swift
//  MemeMe1.0
//
//  Created by CURTIS MCMILLIN on 8/6/16.
//  Copyright © 2016 CURTIS MCMILLIN. All rights reserved.
//

import UIKit

class SentMemeViewController: UIViewController {
    var meme:Meme!
    @IBOutlet weak var imageView: UIImageView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView!.image = meme.memeImage
    }
}
