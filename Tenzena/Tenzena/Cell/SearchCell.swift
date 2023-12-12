//
//  SearchCell.swift
//  Las020
//
//  Created by Trung Nguyễn on 17/11/2023.
//

import UIKit

class SearchCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivPoster: PImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(moveDetail: DMoviesDetail, isMove: Bool = true) {
        lblName.text = moveDetail.title
        ivPoster.setImage(imageUrl: moveDetail.poster_path)
    }
}
