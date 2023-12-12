
import UIKit

class ListDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserScore: UILabel!
    @IBOutlet weak var ivPoster: PImageView!
    @IBOutlet weak var lblTitleUserCore: UILabel!
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

}
