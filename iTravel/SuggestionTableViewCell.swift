//
//  SuggestionTableViewCell.swift
//  iTravel
//
//  Created by Aakash Bhalothia on 4/1/17.
//  Copyright © 2017 Aakash Bhalothia. All rights reserved.
//

import UIKit
import RAMPaperSwitch

class SuggestionTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var paperSwitch: RAMPaperSwitch!
    
    @IBAction func functionAtSwitchingSwitch(_ sender: AnyObject) {
        tapAction?(self)
    }
    
    var tapAction: ((UITableViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
}
