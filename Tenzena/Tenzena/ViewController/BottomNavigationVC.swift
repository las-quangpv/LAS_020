
import UIKit
import XLPagerTabStrip

var listGenres: [Genres] = []
var listTvGenres: [Genres] = []
class BottomNavigationVC: BarPagerTabStripViewController {

    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var ivFav: UIImageView!
    @IBOutlet weak var ivNote: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DApiManage.getInstance.getGenres(isMove: true) { data in
            if let genres = data.data as? [Genres] {
                listGenres = genres
            }
        }
        DApiManage.getInstance.getGenres(isMove: false) { data in
            if let genres = data.data as? [Genres] {
                listTvGenres = genres
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var listController: [UIViewController] = []
        let indicatorInfo: IndicatorInfo = IndicatorInfo(title: "")
        let vcNote = NoteVC(itemInfo: indicatorInfo)
        let vcHome = HomeMainVC(itemInfo: indicatorInfo)
        let vcFav = BookMarkVC(itemInfo: indicatorInfo)
        listController.append(vcHome)
        listController.append(vcNote)
        
        listController.append(vcFav)
        return listController
    }
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if toIndex >= 2 {
            return
        } else if toIndex < 0{
            return
        }
    }

    @IBAction func actionSelectFav(_ sender: Any) {
        ivFav.image = UIImage(named: "ic_select_fav")
        ivNote.image = UIImage(named: "ic_note")
        btnHome.setImage(UIImage(named: "ic_note_home"), for: .normal)
        self.moveToViewController(at: 2)
    }
    @IBAction func actionSelectHome(_ sender: Any) {
        ivFav.image = UIImage(named: "ic_fav")
        ivNote.image = UIImage(named: "ic_note")
        btnHome.setImage(UIImage(named: "ic_home"), for: .normal)
        self.moveToViewController(at: 0)
    }
    @IBAction func actionSelectNote(_ sender: Any) {
        ivFav.image = UIImage(named: "ic_fav")
        ivNote.image = UIImage(named: "ic_select_note")
        btnHome.setImage(UIImage(named: "ic_note_home"), for: .normal)
        self.moveToViewController(at: 1)
    }
}
