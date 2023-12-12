//
//  PopularMoveCell.swift
//  Las020
//
//  Created by Trung Nguyễn on 14/11/2023.
//

import UIKit

class PopularMoveCell: UICollectionViewCell {

    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivPoster: PImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(moveDetail: DMoviesDetail) {
        lblName.text = moveDetail.title
        lblContent.text = moveDetail.release_date.dateToString(dateFormat: "MMM dd, yyyy")
        ivPoster.setImage(imageUrl: moveDetail.poster_path)
    }
    func setData(tvDetail: DTvShowDetail) {
        lblName.text = tvDetail.name
        lblContent.text = tvDetail.first_air_date.dateToString(dateFormat: "MMM dd, yyyy")
        ivPoster.setImage(imageUrl: tvDetail.poster_path)
    }

}
