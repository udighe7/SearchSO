//
//  CustomTableViewCell.swift
//  SearchSO
//
//  Created by utkarsh on 13/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var questionScore: UILabel!
    @IBOutlet weak var greenTickImage: UIImageView!
    @IBOutlet weak var questionTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
