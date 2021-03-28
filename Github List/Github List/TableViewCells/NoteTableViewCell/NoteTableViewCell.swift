//
//  NoteTableViewCell.swift
//  Github List
//
//  Created by Ryan Enguero on 3/27/21.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var detailsTxtView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
