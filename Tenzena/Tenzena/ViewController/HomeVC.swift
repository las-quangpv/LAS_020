

import UIKit
import XLPagerTabStrip
import CHIPageControl
import FSPagerView
import GoogleMobileAds

class HomeVC: BaseVC, IndicatorInfoProvider,UIScrollViewDelegate {
    @IBOutlet weak var pageControls: CHIPageControlJalapeno!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var clvPopularMovies: UICollectionView!
    @IBOutlet weak var clvPlayingNow: UICollectionView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tbvTopRated: UITableView!

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var vStatusBar: UIView!
    @IBOutlet weak var viewNativeAds: UIView!
    
    var adLoader: GADAdLoader!
    var nativeAdView: NativeSmallAdView!
    var nativeAd: GADNativeAd?
    
    var listUpcomming: [DMoviesDetail] = []
    var listPopular: [DMoviesDetail] = []
    var listNowPlaying: [DMoviesDetail] = []
    var listToprated: [DMoviesDetail] = []
    var itemInfo: IndicatorInfo = "View"
    var moveDetailSelect: DMoviesDetail = DMoviesDetail()
    init(itemInfo: IndicatorInfo) {
        super.init(nibName: nil, bundle: nil)
        self.itemInfo = itemInfo
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        configurationCollectionView()
        callApi()
        
        adLoader = GADAdLoader(adUnitID: admod_small_native, rootViewController: self,
                               adTypes: [ .native ], options: nil)
        adLoader!.delegate = self
        adLoader!.load(GADRequest())
        
    }
    
    func setAdView(_ view: NativeSmallAdView) {
        nativeAdView = view
        self.viewNativeAds.addSubview(nativeAdView)
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        let viewDictionary = ["_nativeAdView": nativeAdView!]
        self.viewNativeAds.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        self.viewNativeAds.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
    }
    
    func callApi() {
        self.showLoading()
        DApiManage.getInstance.getMovieUpcoming(page: 1, showLoading: true) { data in
            self.hideLoading()
            self.listUpcomming = data.data as! [DMoviesDetail]
            if(self.listUpcomming.count > 0) {
                self.getDataUpComming(item: self.listUpcomming[0])
            }
            self.pageControls.numberOfPages = self.listUpcomming.count
            self.pagerView.reloadData()
        }
        self.showLoading()
        DApiManage.getInstance.getMoviePopular(page: 1) { data in
            self.hideLoading()
            self.listPopular = data.data as! [DMoviesDetail]
            self.clvPopularMovies.reloadData()
        }
        self.showLoading()
        DApiManage.getInstance.getMovieNowPlaying(page: 1) { data in
            self.hideLoading()
            self.listNowPlaying = data.data as! [DMoviesDetail]
            self.clvPlayingNow.reloadData()
        }
        self.showLoading()
        DApiManage.getInstance.getMovieToprated(page: 1) { data in
            self.hideLoading()
            self.listToprated = data.data as! [DMoviesDetail]
            self.tbvTopRated.reloadData()
        }
    }
    func configurationCollectionView() {
        clvPopularMovies.delegate = self
        clvPopularMovies.dataSource = self
        clvPopularMovies.register(UINib(nibName: "PopularMoveCell", bundle: nil), forCellWithReuseIdentifier: "PopularMoveCell")
        
        clvPlayingNow.delegate = self
        clvPlayingNow.dataSource = self
        clvPlayingNow.register(UINib(nibName: "PopularMoveCell", bundle: nil), forCellWithReuseIdentifier: "PopularMoveCell")
        
        tbvTopRated.delegate = self
        tbvTopRated.dataSource = self
        tbvTopRated.register(UINib(nibName: "TopRatedCell", bundle: nil), forCellReuseIdentifier: "TopRatedCell")
        
        pagerView.delegate = self
        pagerView.dataSource = self
        self.pagerView.transformer = FSPagerViewTransformer(type:.zoomOut)
        self.pagerView.itemSize = FSPagerView.automaticSize
        self.pagerView.decelerationDistance = 1
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.contentInsetAdjustmentBehavior = .never
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    func getDataUpComming(item: DMoviesDetail) {
        moveDetailSelect = item
        lblDate.text = item.release_date.dateToString(dateFormat: "MMM dd")
        lblName.text = item.original_title
        
        var genresString: [String] = []
        listGenres.forEach { genres in
            item.genre_ids.forEach { _id in
                if(genres.id == _id) {
                    genresString.append(genres.name)
                }
            }
        }
        lblGenres.text = genresString.joined(separator: ",")
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let statusBarOffset: CGFloat = 300.0
        let offset = yOffset/statusBarOffset
        let alpha = min(1.0, max(0.0, offset))
        vStatusBar.backgroundColor = UIColor(hex: 0x040404, alpha: alpha)
    }
    
    @IBAction func actionDetail(_ sender: Any) {
        let vc = DetailVC()
        vc.moveDetail = moveDetailSelect
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionMenu(_ sender: Any) {
        let drawerController = DrawerMenuViewController()
        present(drawerController, animated: true)
    }
    @IBAction func actionGenres(_ sender: Any) {
        let vc = GenresVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionTvShow(_ sender: Any) {
        let vc = TvShowVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionActors(_ sender: Any) {
        let vc = ActorsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        let vc = SearchVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionAllTopRated(_ sender: Any) {
        let vc = ShowMoreDetailVC()
        vc.detailType = DetailType.TOP_RATED_MOVE.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionAllNowPlaying(_ sender: Any) {
        let vc = ShowMoreDetailVC()
        vc.detailType = DetailType.NOW_PLAYING_MOVE.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionPopularMove(_ sender: Any) {
        let vc = ShowMoreDetailVC()
        vc.detailType = DetailType.POPULAR_MOVE.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension HomeVC:FSPagerViewDataSource,FSPagerViewDelegate {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return listUpcomming.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let item = listUpcomming[index]
        cell.imageView?.setImage(imageUrl: item.poster_path)
        let vGradient = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: pagerView.bounds.size))
        vGradient.backgroundColor = UIColor.setUpGradient(v: vGradient, listColor: [UIColor.clear,UIColor.black])
        cell.addSubview(vGradient)
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
  
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        let item = listUpcomming[targetIndex]
        getDataUpComming(item: item)
        pageControls.set(progress: targetIndex, animated: true)
    }
    
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {
        
    }
}
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == clvPopularMovies) {
            return listPopular.count
        }else if(collectionView == clvPlayingNow) {
            return listNowPlaying.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == clvPopularMovies) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoveCell", for: indexPath) as! PopularMoveCell
            cell.setData(moveDetail: listPopular[indexPath.row])
            return cell
        }
        if(collectionView == clvPlayingNow) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoveCell", for: indexPath) as! PopularMoveCell
            cell.setData(moveDetail: listNowPlaying[indexPath.row])
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCell", for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == clvPopularMovies || collectionView == clvPlayingNow) {
            return CGSize(width: 150, height: 266)
        }
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var moveDetail : DMoviesDetail = moveDetailSelect
        if(collectionView == clvPopularMovies) {
            moveDetail = listPopular[indexPath.row]
        }
        if(collectionView == clvPlayingNow) {
            moveDetail = listNowPlaying[indexPath.row]
        }
        
        let vc = DetailVC()
        vc.moveDetail = moveDetail
        vc.isMove = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(listToprated.count > 4) {
            return 5
        }
        return listToprated.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatedCell", for: indexPath) as! TopRatedCell
        cell.setData(moveDetail: listToprated[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moveDetailSelect = listToprated[indexPath.row]
        tbvTopRated.deselectRow(at: indexPath, animated: true)
        let vc = DetailVC()
        vc.moveDetail = moveDetailSelect
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // Để loại bỏ màu nền khi chọn hàng
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
}

extension HomeVC : GADNativeAdLoaderDelegate, GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        guard let nibObjects = Bundle.main.loadNibNamed("NativeSmallAdView", owner: nil, options: nil),
            let adView = nibObjects.first as? NativeSmallAdView else {
                assert(false, "Could not load nib file for adView")
                return
        }
        
        setAdView(adView)
        
        self.nativeAd = nativeAd
        nativeAdView.setViewForAds(nativeAd: self.nativeAd!)
    }
}
