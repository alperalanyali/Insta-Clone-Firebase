//
//  FeedCell.swift
//  Insta Clone Firebase
//
//  Created by Alper on 9.10.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commentText.delegate = self
        commentText.isEditable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
