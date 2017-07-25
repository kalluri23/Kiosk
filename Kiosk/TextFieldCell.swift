//
//  TextFieldCell.swift
//  Kiosk
//
//  Created by Krishna teja Kalluri on 12/16/16.
//  Copyright © 2016 Cleveland Clinic. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
