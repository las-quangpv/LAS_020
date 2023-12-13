//
//  TvShowVC.swift
//  Las020
//
//  Created by apple on 14/11/2023.
//

import UIKit

class TvShowVC: BaseMainVC {
    @IBOutlet weak var tbvTopRated: UITableView!
    @IBOutlet weak var clvOnTv: UICollectionView!
    @IBOutlet weak var clvTvShow: UICollectionView!
    @IBOutlet weak var clvAir: UICollectionView!
    @IBOutlet weak var vGradient: UIView!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    var airTodayList: [DTvShowDetail] = []
    var popularTvList: [DTvShowDetail] = []
    var onTvList: [DTvShowDetail] = []
    var topratedList: [DTvShowDetail] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationCollectionView()
        let day = getDay(format: "dd")
        let month = getDay(format: "MM")
        lblDay.text = day
        lblMonth.text = month
        callApi()

    }
    func callApi() {
        self.showLoading()
        DApiManage.getInstance.getTypeTv(type: "airing_today") { data in
            self.hideLoading()
            if let list = data.data as? [DTvShowDetail] {
                self.airTodayList = list
                self.clvAir.reloadData()
            }
        }

        self.showLoading()
        DApiManage.getInstance.getTypeTv(type: "popular") { data in
            self.hideLoading()
            if let list = data.data as? [DTvShowDetail] {
                self.popularTvList = list
                self.clvTvShow.reloadData()
            }
        }
        
        self.showLoading()
        DApiManage.getInstance.getTypeTv(type: "on_the_air") { data in
            self.hideLoading()
            if let list = data.data as? [DTvShowDetail] {
                self.onTvList = list
                self.clvOnTv.reloadData()
            }
        }
        
        self.showLoading()
        DApiManage.getInstance.getTypeTv(type: "top_rated") { data in
            self.hideLoading()
            if let list = data.data as? [DTvShowDetail] {
                self.topratedList = list
                self.tbvTopRated.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    func configurationCollectionView() {
        clvOnTv.delegate = self
        clvOnTv.dataSource = self
        clvOnTv.register(UINib(nibName: "PopularMoveCell", bundle: nil), forCellWithReuseIdentifier: "PopularMoveCell")
        
        clvTvShow.delegate = self
        clvTvShow.dataSource = self
        clvTvShow.register(UINib(nibName: "PopularMoveCell", bundle: nil), forCellWithReuseIdentifier: "PopularMoveCell")
        
        clvAir.delegate = self
        clvAir.dataSource = self
        clvAir.register(UINib(nibName: "PopularMoveCell", bundle: nil), forCellWithReuseIdentifier: "PopularMoveCell")
        
        tbvTopRated.delegate = self
        tbvTopRated.dataSource = self
        tbvTopRated.register(UINib(nibName: "TopRatedCell", bundle: nil), forCellReuseIdentifier: "TopRatedCell")
    }
    func getDay(format: String)-> String {//dd MMM
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        if(format == "MM") {
            var formattedMonth = ""

            if formattedDate == "1" {
                formattedMonth = "Jan"
            } else if formattedDate == "2" {
                formattedMonth = "Feb"
            } else if formattedDate == "3" {
                formattedMonth = "Mar"
            } else if formattedDate == "4" {
                formattedMonth = "Apr"
            } else if formattedDate == "5" {
                formattedMonth = "May"
            } else if formattedDate == "6" {
                formattedMonth = "Jun"
            } else if formattedDate == "7" {
                formattedMonth = "Jul"
            } else if formattedDate == "8" {
                formattedMonth = "Aug"
            } else if formattedDate == "9" {
                formattedMonth = "Sep"
            } else if formattedDate == "10" {
                formattedMonth = "Oct"
            } else if formattedDate == "11" {
                formattedMonth = "Nov"
            } else if formattedDate == "12" {
                formattedMonth = "Dec"
            }
            return formattedMonth
        }
        
        return formattedDate
    }

    @IBAction func actionAllPopularTv(_ sender: Any) {
        let vc = ShowMoreDetailVC()
        vc.typeTv = "popular"
        vc.titleTv = "Popular TV Shows"
        vc.isMove = false
        vc.detailType = DetailType.TV_SHOW.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionAllToprated(_ sender: Any) {
        let vc = ShowMoreDetailVC()
        vc.typeTv = "top_rated"
        vc.titleTv = "Top Rated"
        vc.isMove = false
        vc.detailType = DetailType.TV_SHOW.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionAllOnTv(_ sender: Any) {
        let vc = ShowMoreDetailVC()
        vc.typeTv = "on_the_air"
        vc.titleTv = "On TV"
        vc.isMove = false
        vc.detailType = DetailType.TV_SHOW.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension TvShowVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == clvAir) {
            return airTodayList.count
        }else if(collectionView == clvTvShow) {
            return popularTvList.count
        }else if(collectionView == clvOnTv) {
            return onTvList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoveCell", for: indexPath) as! PopularMoveCell
        if(collectionView == clvAir) {
            let item = airTodayList[indexPath.row]
            cell.setData(tvDetail: item)
            return cell
        }
        if(collectionView == clvTvShow) {
            let item = popularTvList[indexPath.row]
            cell.setData(tvDetail: item)
            return cell
        }
        let item = onTvList[indexPath.row]
        cell.setData(tvDetail: item)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 266)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var tvDetail: DTvShowDetail = DTvShowDetail()
        if(collectionView == clvAir) {
            tvDetail = airTodayList[indexPath.row]
        }
        if(collectionView == clvTvShow) {
            tvDetail = popularTvList[indexPath.row]
        }
        if(collectionView == clvOnTv) {
            tvDetail = onTvList[indexPath.row]
        }
        
        let moveDetailSelect = DTvShowDetail.convertTvShowToMove(tvShow: tvDetail)
        let vc = DetailVC()
        vc.moveDetail = moveDetailSelect
        vc.isMove = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension TvShowVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(topratedList.count > 5) {
            return 5
        }
        return topratedList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatedCell", for: indexPath) as! TopRatedCell
        cell.setData(tvDetail: topratedList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tvDetail = topratedList[indexPath.row]
        tbvTopRated.deselectRow(at: indexPath, animated: true)
        let moveDetailSelect = DTvShowDetail.convertTvShowToMove(tvShow: tvDetail)
        let vc = DetailVC()
        vc.moveDetail = moveDetailSelect
        vc.isMove = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
