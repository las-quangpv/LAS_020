
import UIKit

class SearchMainVC: BaseMainVC {
    
    @IBOutlet weak var btnTvShow: UIButton!
    @IBOutlet weak var btnMove: UIButton!
    @IBOutlet weak var vEmpty: UIView!
    @IBOutlet weak var clvSearch: UICollectionView!
    @IBOutlet weak var tfSearch: UITextField!
    var listSearch: [DMoviesDetail] = []
    var page = 1
    var totalPage = 1.0
    var isSearchMove = true
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedPlaceholder = NSAttributedString(string: "Search movie, TV show", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: 0xFFFFFF, alpha: 0.3)])
        tfSearch.attributedPlaceholder = attributedPlaceholder
        self.tfSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.clvSearch.delegate = self
        self.clvSearch.dataSource = self
        self.clvSearch.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: "SearchCell")
        searchWithMove(txtSearch: "")
    }
   
    func searchWithMove(txtSearch: String) {
        self.showLoading()
        DApiManage.getInstance.searchMove(txtSearch, page: page) { data in
            self.hideLoading()
            if let list = data.data as? [DMoviesDetail] {
                list.forEach { move in
                    self.listSearch.append(move)
                }
                if(self.listSearch.count == 0) {
                    self.vEmpty.isHidden = false
                }else {
                    self.vEmpty.isHidden = true
                }
                self.clvSearch.reloadData()
            }
            if let totalPage = data.totalPage as? Double {
                self.totalPage = totalPage
            }
        }
    }
    func searchWithTv(txtSearch: String) {
        self.showLoading()
        DApiManage.getInstance.searchTv(txtSearch, page: page) { data in
            self.hideLoading()
            if let list = data.data as? [DTvShowDetail] {
                list.forEach { tvDetail  in
                    let moveDetail = DTvShowDetail.convertTvShowToMove(tvShow: tvDetail)
                    self.listSearch.append(moveDetail)
                }
                if(self.listSearch.count == 0) {
                    self.vEmpty.isHidden = false
                }else {
                    self.vEmpty.isHidden = true
                }
                self.clvSearch.reloadData()
            }
            if let totalPage = data.totalPage as? Double {
                self.totalPage = totalPage
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let txtSeach = textField.text!
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.listSearch.removeAll()
            if(self.isSearchMove) {
                self.searchWithMove(txtSearch: txtSeach)
            }else {
                self.searchWithTv(txtSearch: txtSeach)
            }
            
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionTvShow(_ sender: Any) {
        isSearchMove = false
        btnTvShow.setTitleColor(UIColor.white, for: .normal)
        btnMove.setTitleColor(UIColor(hex: 0x9D9D9D), for: .normal)
        page = 1
        self.listSearch.removeAll()
        self.tfSearch.text?.removeAll()
        searchWithTv(txtSearch: "")
    }
    @IBAction func actionMove(_ sender: Any) {
        isSearchMove = true
        btnMove.setTitleColor(UIColor.white, for: .normal)
        btnTvShow.setTitleColor(UIColor(hex: 0x9D9D9D), for: .normal)
        page = 1
        self.listSearch.removeAll()
        self.tfSearch.text?.removeAll()
        searchWithMove(txtSearch: "")
    }
}
extension SearchMainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listSearch.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.setData(moveDetail: listSearch[indexPath.row], isMove: isSearchMove)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(ActivityEx.isPad()) {
            return CGSize(width: self.clvSearch.frame.size.width/5-8, height: 211)
        }
        return CGSize(width: self.clvSearch.frame.size.width/3-8, height: 211)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let moveDetail = listSearch[indexPath.row]
        let vc = DetailVC()
        vc.moveDetail = moveDetail
        vc.isMove = isSearchMove
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = listSearch.count - 1
        if indexPath.item == lastItem && self.page <= Int(totalPage){
            self.page += 1
            self.searchWithMove(txtSearch: tfSearch.text ?? "")
        }
    }
    
}
