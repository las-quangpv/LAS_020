
import UIKit
import XLPagerTabStrip
class NoteVC: BaseVC, IndicatorInfoProvider {

    @IBOutlet weak var vEmpty: UIView!
    @IBOutlet weak var tbvNote: UITableView!
    var listNotes: [NoteModel] = []
    var itemInfo: IndicatorInfo = "View"
    init(itemInfo: IndicatorInfo) {
        super.init(nibName: nil, bundle: nil)
        self.itemInfo = itemInfo
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvNote.delegate = self
        tbvNote.dataSource = self
        tbvNote.register(UINib(nibName: "NoteCell", bundle: nil), forCellReuseIdentifier: "NoteCell")
        tbvNote.rowHeight = UITableView.automaticDimension
        tbvNote.estimatedRowHeight = 200  // Đặt giá trị ước lượng cho chiều cao

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listNotes = NoteModel.readFromNoteJson()
        if(listNotes.count == 0) {
            vEmpty.isHidden = false
        }else {
            vEmpty.isHidden = true
        }
        tbvNote.reloadData()

    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    @IBAction func actionSelect(_ sender: Any) {
        let vc = SearchVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension NoteVC: UITableViewDelegate, UITableViewDataSource ,NoteDelegate{
    func seeAllNote(note: NoteModel, row: Int) {
        let vc = NoteAllVC()
        vc.noteModel = note
        vc.indexNote = row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNotes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        let note = listNotes[indexPath.row]
        cell.setData(note: note)
        cell.row = indexPath.row
        cell.delegate = self
        return cell
    }
    
   
}
