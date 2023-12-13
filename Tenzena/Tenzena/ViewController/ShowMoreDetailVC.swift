//
//  ShowMoreDetailVC.swift
//  Las020
//
//  Created by apple on 17/11/2023.
//

import UIKit
enum DetailType: Int {
    case POPULAR_MOVE = 1
    case NOW_PLAYING_MOVE = 2
    case TOP_RATED_MOVE = 3
    case TV_SHOW = 4
    case GENRES = 5
}
class ShowMoreDetailVC: BaseMainVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var clvList: UICollectionView!
    @IBOutlet weak var btnShape: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    var listDetail: [DMoviesDetail] = []
    var isMove: Bool = true
    var detailType = 0
    var isList = true
    var page = 1
    var totalPage = 1.0
    var itemSize: CGSize!
    var typeTv = ""
    var titleTv = ""
    var genres: Genres!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clvList.delegate = self
        clvList.dataSource = self
        clvList.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: "SearchCell")
        callApi()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(ActivityEx.isPad()) {
            itemSize = CGSize(width: clvList.frame.size.width/5-12, height: 211)
        }else {
            itemSize = CGSize(width: clvList.frame.size.width/3-8, height: 211)
        }
    }
    
    func callApi() {
        self.showLoading()
        if(detailType == DetailType.POPULAR_MOVE.rawValue) {
            lblTitle.text = "Popular Movies"
            DApiManage.getInstance.getMoviePopular(page: page) { data in
                self.hideLoading()
                if let list = data.data as? [DMoviesDetail] {
                    list.forEach { moveDetail in
                        self.listDetail.append(moveDetail)
                    }
                }
                if let totalPage = data.totalPage as? Double {
                    self.totalPage = totalPage
                }
                self.clvList.reloadData()
            }
        }else if(detailType == DetailType.NOW_PLAYING_MOVE.rawValue) {
            lblTitle.text = "Now Playing Movies"
            DApiManage.getInstance.getMovieNowPlaying(page: page) { data in
                self.hideLoading()
                if let list = data.data as? [DMoviesDetail] {
                    list.forEach { moveDetail in
                        self.listDetail.append(moveDetail)
                    }
                }
                if let totalPage = data.totalPage as? Double {
                    self.totalPage = totalPage
                }
                self.clvList.reloadData()
            }
        }else if(detailType == DetailType.TOP_RATED_MOVE.rawValue) {
            lblTitle.text = "Top Rated"
            DApiManage.getInstance.getMovieToprated(page: page) { data in
                self.hideLoading()
                if let list = data.data as? [DMoviesDetail] {
                    list.forEach { moveDetail in
                        self.listDetail.append(moveDetail)
                    }
                }
                if let totalPage = data.totalPage as? Double {
                    self.totalPage = totalPage
                }
                self.clvList.reloadData()
            }
        }else if(detailType == DetailType.TV_SHOW.rawValue) {
            lblTitle.text = titleTv
            DApiManage.getInstance.getTypeTv(page: page,type: typeTv) { data in
                self.hideLoading()
                if let list = data.data as? [DTvShowDetail] {
                    list.forEach { tvDetail in
                        let moveDetail = DTvShowDetail.convertTvShowToMove(tvShow: tvDetail)
                        self.listDetail.append(moveDetail)
                    }
                }
                if let totalPage = data.totalPage as? Double {
                    self.totalPage = totalPage
                }
                self.clvList.reloadData()
            }
        }else if(detailType == DetailType.GENRES.rawValue) {
            lblTitle.text = titleTv
            if(isMove) {
                DApiManage.getInstance.getGenreMovieDetailWithPage("\(genres.id)", page: page) { data in
                    self.hideLoading()
                    if let list = data.data as? [DMoviesDetail] {
                        list.forEach { moveDetail in
                            self.listDetail.append(moveDetail)
                        }
                    }
                    if let totalPage = data.totalPage as? Double {
                        self.totalPage = totalPage
                    }
                    self.clvList.reloadData()
                }
            }else {
                DApiManage.getInstance.getGenreTvDetailWithPage("\(genres.id)", page: page) { data in
                    self.hideLoading()
                    if let list = data.data as? [DTvShowDetail] {
                        list.forEach { tvDetail in
                            let moveDetail = DTvShowDetail.convertTvShowToMove(tvShow: tvDetail)
                            self.listDetail.append(moveDetail)
                        }
                    }
                    if let totalPage = data.totalPage as? Double {
                        self.totalPage = totalPage
                    }
                    self.clvList.reloadData()
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listDetail.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(isList) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
            cell.setData(moveDetail: listDetail[indexPath.row])
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListDetailCollectionViewCell", for: indexPath) as! ListDetailCollectionViewCell
            cell.setData(moveDetail: listDetail[indexPath.row])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(isList) {
            if(ActivityEx.isPad()) {
                return CGSize(width: clvList.frame.size.width/5-12, height: 211)
            }else {
                return CGSize(width: clvList.frame.size.width/3-8, height: 211)
            }
        }else {
            return CGSize(width: clvList.frame.size.width, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = listDetail.count - 1
        if indexPath.item == lastItem && self.page <= Int(totalPage) {
            self.page += 1
            callApi()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let moveDetailSelect = listDetail[indexPath.row]
        let vc = DetailVC()
        vc.moveDetail = moveDetailSelect
        vc.isMove = isMove
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionShape(_ sender: Any) {
        isList = !isList
        btnShape.setImage(UIImage(named: isList ? "ic_list" : "ic_rec"), for: .normal)
        if(isList) {
            clvList.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: "SearchCell")
            clvList.reloadData()
        }else {
            clvList.register(UINib(nibName: "ListDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListDetailCollectionViewCell")
            clvList.reloadData()
        }
    }

    
}
