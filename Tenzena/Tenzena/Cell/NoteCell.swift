
import UIKit
protocol NoteDelegate {
    func seeAllNote(note: NoteModel, row: Int)
}
class NoteCell: UITableViewCell {
    
    @IBOutlet weak var constrantHeight: NSLayoutConstraint!
    @IBOutlet weak var stackNote: UIStackView!
    @IBOutlet weak var clvNoteDetail: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivPoster: PImageView!
    var note: NoteModel!
    var delegate: NoteDelegate?
    var row: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    func setData(note: NoteModel) {
        self.note = note
        ivPoster.setImage(imageUrl: note.image)
        lblName.text = note.name
        for subview in stackNote.subviews {
            subview.removeFromSuperview()
        }
        let listNote = note.notes.components(separatedBy: SPACE_SAVE_NOTES)
        var maxHeight: CGFloat = 0.0
        for i in 0...listNote.count-1 {
            let uiView = NoteView()
            uiView.translatesAutoresizingMaskIntoConstraints = false
            uiView.widthAnchor.constraint(equalToConstant: 260).isActive = true
            let item = listNote[i]
            uiView.lblNote.text = item
            
            let uiParentView = UIView()
            uiParentView.translatesAutoresizingMaskIntoConstraints = false
            uiParentView.widthAnchor.constraint(equalToConstant: 260).isActive = true
            uiParentView.backgroundColor = UIColor.clear
            uiParentView.addSubview(uiView)
            stackNote.addArrangedSubview(uiParentView)
            // Tính toán chiều cao của NoteView
            uiView.layoutIfNeeded()
            let noteViewHeight = uiView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            maxHeight = max(maxHeight, noteViewHeight)
        }
        constrantHeight.constant = maxHeight
    }

    @IBAction func actionSeeAll(_ sender: Any) {
        if(self.delegate != nil) {
            self.delegate?.seeAllNote(note: note, row: row)
        }
    }
}
