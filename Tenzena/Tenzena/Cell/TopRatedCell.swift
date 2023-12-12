//
//  TopRatedCell.swift
//  Las020
//
//  Created by Trung Nguyễn on 14/11/2023.
//

import UIKit

protocol FavouriteCellDelegate {
    func removeBookmark(row: Int, moveDetail: DMoviesDetail)
}
class TopRatedCell: UITableViewCell {
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserScore: UILabel!
    @IBOutlet weak var ivPoster: PImageView!
    @IBOutlet weak var lblTitleUserCore: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    
    var moveDetail:DMoviesDetail!
    var delegate: FavouriteCellDelegate!
    var row: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(moveDetail: DMoviesDetail) {
        lblName.text = moveDetail.title
        lblContent.text = moveDetail.release_date.dateToString(dateFormat: "MMM dd, yyyy")
        let score = (moveDetail.vote_average/10)*100
        lblUserScore.text = "\(Int(score))%"
        ivPoster.setImage(imageUrl: moveDetail.poster_path)
    }
    
    func setData(tvDetail: DTvShowDetail) {
        lblName.text = tvDetail.name
        lblContent.text = tvDetail.first_air_date.dateToString(dateFormat: "MMM dd, yyyy")
        let score = (tvDetail.vote_average/10)*100
        lblUserScore.text = "\(Int(score))%"
        ivPoster.setImage(imageUrl: tvDetail.poster_path)
    }
    func setDataFavourite(moveDetail: DMoviesDetail) {
        self.moveDetail = moveDetail
        lblName.text = moveDetail.title
        lblContent.text = moveDetail.release_date.dateToString(dateFormat: "MMM dd, yyyy")
        let score = (moveDetail.vote_average/10)*100
        lblUserScore.text = "\(Int(score))%"
        ivPoster.setImage(imageUrl: moveDetail.poster_path)
        btnFav.isHidden = false
        lblUserScore.isHidden = true
        lblTitleUserCore.isHidden = true
    }
    
    @IBAction func actionFav(_ sender: Any) {
        if(delegate != nil) {
            self.delegate.removeBookmark(row: row, moveDetail: self.moveDetail)
        }
    }
    
}
