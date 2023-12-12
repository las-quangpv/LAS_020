//
//  BookMarkVC.swift
//  Las020
//
//  Created by Trung Nguyễn on 16/11/2023.
//

import UIKit
import XLPagerTabStrip

class BookMarkVC: UIViewController, IndicatorInfoProvider {
    @IBOutlet weak var lblMove: UILabel!
    @IBOutlet weak var vLineTvShow: UIView!
    @IBOutlet weak var lblTvShow: UILabel!
    @IBOutlet weak var vLineMove: UIView!
    @IBOutlet weak var vEmpty: UIView!
    var itemInfo: IndicatorInfo = "View"
    var favList: [DMoviesDetail] = []
    var listFilter : [DMoviesDetail] = []
    var isMove = true
    @IBOutlet weak var tbvFav: UITableView!
    init(itemInfo: IndicatorInfo) {
        super.init(nibName: nil, bundle: nil)
        self.itemInfo = itemInfo
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvFav.delegate = self
        tbvFav.dataSource = self
        tbvFav.register(UINib(nibName: "TopRatedCell", bundle: nil), forCellReuseIdentifier: "TopRatedCell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favList = DMoviesDetail.readFromNoteJson()
        vLineMove.isHidden = false
        vLineTvShow.isHidden = true
        isMove = true
        getListWithType()
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    func getListWithType(isMove: Bool = true){
        listFilter = favList.filter({ moveDetail in
            return moveDetail.isMove == isMove
        })
        if(listFilter.count == 0) {
            vEmpty.isHidden = false
        }else {
            vEmpty.isHidden = true
        }
        tbvFav.reloadData()
    }
    
    @IBAction func actionMove(_ sender: Any) {
        vLineMove.isHidden = false
        vLineTvShow.isHidden = true
        isMove = true
        getListWithType()
    }
    
    @IBAction func actionTvShow(_ sender: Any) {
        vLineMove.isHidden = true
        vLineTvShow.isHidden = false
        isMove = false
        getListWithType(isMove: false)
    }
    
    
}
extension BookMarkVC: UITableViewDelegate, UITableViewDataSource, FavouriteCellDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFilter.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatedCell", for: indexPath) as! TopRatedCell
        cell.setDataFavourite(moveDetail: listFilter[indexPath.row])
        cell.row = indexPath.row
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moveDetailSelect = listFilter[indexPath.row]
        tbvFav.deselectRow(at: indexPath, animated: true)
        let vc = DetailVC()
        vc.moveDetail = moveDetailSelect
        vc.isMove = isMove
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func removeBookmark(row: Int, moveDetail: DMoviesDetail) {
        let index = favList.firstIndex { move in
            return moveDetail.id == move.id
        } ?? -1
        if(index != -1) {
            do {
                favList.remove(at: index)
                let jsonData = try JSONSerialization.data(withJSONObject: favList.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
                if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    writeString(aString: jsonString, fileName: FAV_SAVE)
                }
            }catch {
                
            }
        }
        listFilter.remove(at: row)
        if(listFilter.count == 0) {
            vEmpty.isHidden = false
        }else {
            vEmpty.isHidden = true
        }
        tbvFav.reloadData()
    }
    
}
