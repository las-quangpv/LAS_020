

import UIKit

class NoteAllVC: BaseVC, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tbvNote: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivPoster: PImageView!
    var noteModel: NoteModel!
    var indexNote = 0
    var listNote: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvNote.delegate = self
        tbvNote.dataSource = self
        tbvNote.register(UINib(nibName: "NoteAllCell", bundle: nil), forCellReuseIdentifier: "NoteAllCell")
        
        lblName.text = noteModel.name
        ivPoster.setImage(imageUrl: noteModel.image)
        listNote = noteModel.notes.components(separatedBy: SPACE_SAVE_NOTES)
        tbvNote.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func updateData(isDelete: Bool) {
        do {
            var listAllNote = NoteModel.readFromNoteJson()
            if(isDelete) {
                if(listNote.count == 0) {
                    listAllNote.remove(at: indexNote)
                }else {
                    noteModel.notes = listNote.joined(separator: SPACE_SAVE_NOTES)
                    listAllNote[indexNote] = noteModel
                }
            }else {
                noteModel.notes = listNote.joined(separator: SPACE_SAVE_NOTES)
                listAllNote[indexNote] = noteModel
            }
            let jsonData = try JSONSerialization.data(withJSONObject: listAllNote.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(aString: jsonString, fileName: NAME_NOTE_SAVE)
            }
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNote.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteAllCell", for: indexPath) as! NoteAllCell
        cell.pNoteView.lblNote.text = listNote[indexPath.row]
        cell.pNoteView.layoutIfNeeded()
        let noteViewHeight = cell.pNoteView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        cell.constrantHeight.constant = noteViewHeight
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
            // Xử lý việc xoá item khỏi dữ liệu ở đây
            self.listNote.remove(at: indexPath.row)
            self.updateData(isDelete: true)
            if(self.listNote.count == 0){
                self.navigationController?.popViewController(animated: true)
            }else {
                self.tbvNote.deleteRows(at: [indexPath], with: .fade)
            }
            
            //self.saveData()
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor(hex: 0x040404)
        let originalImage = UIImage(named: "ic_delete")
        let resizedImage = originalImage?.resized(to: CGSize(width: 46, height: 46)) // Tùy chỉnh kích thước ảnh
        deleteAction.image = resizedImage
        
        // edit action
        let editAction = UIContextualAction(style: .destructive, title: "") { [self] (_, _, completionHandler) in
                // show sheet
                let txtNote = self.listNote[indexPath.row]
                let vc = AddNoteSheetVC()
                vc.noteBlock = { [self] txtNote in
                    listNote[indexPath.row] = txtNote
                    tbvNote.reloadData()
                    self.updateData(isDelete: false)
                }
                let moveModel = DMoviesDetail()
                moveModel.poster_path = noteModel.image
                moveModel.title = noteModel.name
                vc.moveModel = moveModel
                vc.noteString = txtNote
                vc.modalPresentationStyle = .overCurrentContext
                vc.context = self
                self.addOverlay()
                self.navigationController?.present(vc, animated: true)
                completionHandler(true)
            }
            editAction.backgroundColor = UIColor(hex: 0x040404)
            let editImage = UIImage(named: "ic_edit_note")
            let editResizedImage = editImage?.resized(to: CGSize(width: 46, height: 46)) // Tùy chỉnh kích thước ảnh
            editAction.image = editResizedImage
            
            //add action
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionDeleteAll(_ sender: Any) {
        listNote.removeAll()
        updateData(isDelete: true)
        self.navigationController?.popViewController(animated: true)
    }
}
