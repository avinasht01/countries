//
//  LoadingTableViewCell.swift
//  Countries
//
//  Created by Avinash Thakur on 13/07/24.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var flagIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       setCellUI()
    }

    func setCellUI() {
        self.flagIcon.layer.cornerRadius = 8.0
        self.flagIcon.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
