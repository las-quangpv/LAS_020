//
//  SeasonCell.swift
//  Las020
//
//  Created by apple on 18/11/2023.
//

import UIKit

class SeasonCell: UITableViewCell {
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserScore: UILabel!
    @IBOutlet weak var ivPoster: PImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
