
import UIKit

class DetailVC: BaseMainVC {

    @IBOutlet weak var btnAllNote: UIButton!
    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var clvNote: UICollectionView!
    @IBOutlet weak var vSeasions: UIView!
    @IBOutlet weak var vCasts: UIView!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var vBackdrops: UIView!
    @IBOutlet weak var vLine: UIView!
    @IBOutlet weak var vRecommendations: UIView!
    @IBOutlet weak var vGradient: UIView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivAvatar: PImageView!
    @IBOutlet weak var lblUserCore: UILabel!
    @IBOutlet weak var vContentNote: UIView!
    @IBOutlet weak var vNote: UIView!
    @IBOutlet weak var constrantNoteTrailing: NSLayoutConstraint!
    @IBOutlet weak var clvCast: UICollectionView!
    @IBOutlet weak var clvRecommend: UICollectionView!
    @IBOutlet weak var clvBackDrops: UICollectionView!
    
    @IBOutlet weak var constrantHeightSeason: NSLayoutConstraint!
    @IBOutlet weak var tbvDetailSeasons: UITableView!
    var moveDetail:DMoviesDetail!
    var listCast: [CastModel] = []
    var listRecommendations: [DMoviesDetail] = []
    var listBackdrops: [BackDropsModel] = []
    var notes: [String] = []
    var isMove = true
    var listSeasons: [SeasonDetailModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        moveDetail.isMove = isMove
        setUpData()
        configurationCollectionView()
        if(isMove) {
            callApi()
        }else {
            callApiTvShow()
        }
    }
    func callApi() {
        self.showLoading()
        DApiManage.getInstance.getMoviesShowCast("\(moveDetail.id)") { data in
            self.hideLoading()
            if let listCast = data.data as? [CastModel], listCast.count > 0{
                self.listCast = listCast
                self.clvCast.reloadData()
            }else {
                self.vCasts.isHidden = true
            }
        }
        self.showLoading()
        DApiManage.getInstance.getMoviesRecommendations("\(moveDetail.id)") { data in
            self.hideLoading()
            if let listRecommendations = data.data as? [DMoviesDetail], listRecommendations.count > 0 {
                self.listRecommendations = listRecommendations
                self.clvRecommend.reloadData()
            }else {
                self.vLine.isHidden = true
                self.vRecommendations.isHidden = true
            }
        }
        self.showLoading()
        DApiManage.getInstance.getMoviesBackDrops("\(moveDetail.id)") { data in
            self.hideLoading()
            if let listBackdrops = data.data as? [BackDropsModel], listBackdrops.count > 0 {
                self.listBackdrops = listBackdrops
                self.clvBackDrops.reloadData()
            }else {
                self.vBackdrops.isHidden = true
            }
        }
    }
    
    func callApiTvShow() {
        self.showLoading()
        DApiManage.getInstance.getTvShowCast("\(moveDetail.id)") { data in
            self.hideLoading()
            if let listCast = data.data as? [CastModel], listCast.count > 0{
                self.listCast = listCast
                self.clvCast.reloadData()
            }else {
                self.vCasts.isHidden = true
            }
        }
        self.showLoading()
        DApiManage.getInstance.getTvShowRecommendations("\(moveDetail.id)") { data in
            self.hideLoading()
            if let listRecommendations = data.data as? [DTvShowDetail], listRecommendations.count > 0 {
                listRecommendations.forEach { tvDetail in
                    let moveDetail = DTvShowDetail.convertTvShowToMove(tvShow: tvDetail)
                    self.listRecommendations.append(moveDetail)
                }
                self.clvRecommend.reloadData()
            }else {
                self.vLine.isHidden = true
                self.vRecommendations.isHidden = true
            }
        }
        self.showLoading()
        DApiManage.getInstance.getTvShowBackDrops("\(moveDetail.id)") { data in
            self.hideLoading()
            if let listBackdrops = data.data as? [BackDropsModel], listBackdrops.count > 0 {
                self.listBackdrops = listBackdrops
                self.clvBackDrops.reloadData()
            }else {
                self.vBackdrops.isHidden = true
            }
        }
        self.showLoading()
        DApiManage.getInstance.getTvSeasonGroup("\(moveDetail.id)") { data in
            self.hideLoading()
            if let listSeasons = data.data as? [SeasionsGroupModel] {
                listSeasons.forEach { seasionsGroupModel in
                    DApiManage.getInstance.getDetailSeasons(seasionsGroupModel.id) { data in
                        if let detaiSeason = data.data as? SeasonDetailModel {
                            let detailNew = detaiSeason
                            detailNew.group_count = seasionsGroupModel.group_count
                            detailNew.episode_count = seasionsGroupModel.episode_count
                            if(detailNew.poster_path.isTextEmpty()) {
                                detailNew.poster_path = self.moveDetail.poster_path
                            }
                            self.listSeasons.append(detailNew)
                            if(self.listSeasons.count == 0) {
                                self.vSeasions.isHidden = true
                            }else {
                                self.vSeasions.isHidden = false
                            }
                            self.constrantHeightSeason.constant = CGFloat(self.listSeasons.count*146 - 12)
                            self.tbvDetailSeasons.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    
    func setUpData() {
        let color =  UIColor.setUpGradient(v: vGradient, listColor: [UIColor(hex: 0x000000, alpha: 0.31),UIColor(hex: 0x040404, alpha: 0.31)])
        vGradient.backgroundColor = color
        ivPoster.setImage(imageUrl: moveDetail.backdrop_path)
        lblName.text = moveDetail.title
        lblDate.text = moveDetail.release_date.dateToString(dateFormat: "MMM dd, yyyy")
        var genresString: [String] = []
        let listGen = isMove ? listGenres : listTvGenres
        listGen.forEach { genres in
        moveDetail.genre_ids.forEach { _id in
                if(genres.id == _id) {
                    genresString.append(genres.name)
                }
            }
        }
        lblGenres.text = genresString.joined(separator: ",")
        ivAvatar.setImage(imageUrl: moveDetail.poster_path)
        lblOverview.text = moveDetail.overview
        let score = (moveDetail.vote_average/10)*100
        lblUserCore.text = "\(Int(score))%"
        lblVoteCount.text = "\(moveDetail.vote_count)"
        
        if(indexCheckFavourite() == -1) {
            btnFav.setImage(UIImage(named: "ic_white_fav"), for: .normal)
        }else {
            btnFav.setImage(UIImage(named: "ic_select_fav"), for: .normal)
        }
    }
    func indexCheckFavourite() -> Int {
        let listFav = DMoviesDetail.readFromNoteJson()
        let indexFav = listFav.firstIndex { moveDetail in
            return moveDetail.id == self.moveDetail.id
        } ?? -1
        return indexFav
    }
    
    func configurationCollectionView() {
        clvCast.delegate = self
        clvCast.dataSource = self
        clvCast.register(UINib(nibName: "ActorsCell", bundle: nil), forCellWithReuseIdentifier: "ActorsCell")
        
        clvRecommend.delegate = self
        clvRecommend.dataSource = self
        clvRecommend.register(UINib(nibName: "PopularMoveCell", bundle: nil), forCellWithReuseIdentifier: "PopularMoveCell")
        
        clvBackDrops.delegate = self
        clvBackDrops.dataSource = self
        clvBackDrops.register(UINib(nibName: "BackdropsCell", bundle: nil), forCellWithReuseIdentifier: "BackdropsCell")
        
        clvNote.delegate = self
        clvNote.dataSource = self
        if let flowLayout = clvNote.collectionViewLayout as? UICollectionViewFlowLayout {
               flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
           }
        clvNote.register(UINib(nibName: "NoteDetailCell", bundle: nil), forCellWithReuseIdentifier: "NoteDetailCell")
        
        tbvDetailSeasons.delegate = self
        tbvDetailSeasons.dataSource = self
        tbvDetailSeasons.register(UINib(nibName: "SeasonCell", bundle: nil), forCellReuseIdentifier: "SeasonCell")
    }
    @IBAction func vAddNote(_ sender: Any) {
        let vc = AddNoteSheetVC()
        vc.noteBlock = { [self] txtNote in
            vContentNote.isHidden = false
            btnAllNote.isHidden = false
            constrantNoteTrailing.constant = 0
            notes.append(txtNote)
            clvNote.reloadData()
            do {
                var listNote = NoteModel.readFromNoteJson()
                let indexNote = listNote.firstIndex { note in
                    return note.name == self.moveDetail.title
                } ?? -1
                if(indexNote != -1) {
                    listNote[indexNote].notes = notes.joined(separator: SPACE_SAVE_NOTES)
                }else {
                    let noteModel = NoteModel(image: moveDetail.poster_path, name: moveDetail.title, notes: notes)
                    listNote.append(noteModel)
                }
               
                let jsonData = try JSONSerialization.data(withJSONObject: listNote.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
                if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    writeString(aString: jsonString, fileName: NAME_NOTE_SAVE)
                }
                
            } catch {
                
            }
        }
        vc.moveModel = moveDetail
        vc.modalPresentationStyle = .overCurrentContext
        vc.context = self
        self.addOverlay()
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func actionFav(_ sender: Any) {
        do {
            var listFav = DMoviesDetail.readFromNoteJson()
            let index = indexCheckFavourite()
            if(index == -1) {
                listFav.append(moveDetail)
                btnFav.setImage(UIImage(named: "ic_select_fav"), for: .normal)
            }else {
                listFav.remove(at: index)
                btnFav.setImage(UIImage(named: "ic_white_fav"), for: .normal)
            }
            let jsonData = try JSONSerialization.data(withJSONObject: listFav.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(aString: jsonString, fileName: FAV_SAVE)
            }
            
        } catch {
            
        }
    }
    
    @IBAction func actionAllNote(_ sender: Any) {
        let listNote = NoteModel.readFromNoteJson()
        let indexNote = listNote.firstIndex { note in
            return note.name == self.moveDetail.title
        } ?? -1
        if(indexNote != -1) {
            let vc = NoteAllVC()
            vc.noteModel = listNote[indexNote]
            vc.indexNote = indexNote
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionPlayVideo(_ sender: Any) {
        
        if(isMove) {
            self.showLoading()
            DApiManage.getInstance.getVideoKey("\(moveDetail.id)") { [self] data in
                self.hideLoading()
                if let key = data.data as? String {
                    let link = "https://www.youtube.com/watch?v=\(key)"
                    let play = PlayVC();
                    play.linkUrl = link;
                    play.titleString = moveDetail.title
                    self.navigationController?.pushViewController(play, animated: true)
                }else {
                    DAppMessagesManage.shared.showMessage(messageType: .error, message: "trailer does not exist")
                }
            }
        }else {
            self.showLoading()
            DApiManage.getInstance.getTvVideoKey("\(moveDetail.id)") { [self] data in
                self.hideLoading()
                if let key = data.data as? String {
                    let link = "https://www.youtube.com/watch?v=\(key)"
                    let play = PlayVC();
                    play.linkUrl = link;
                    play.titleString = moveDetail.title
                    self.navigationController?.pushViewController(play, animated: true)
                }else {
                    DAppMessagesManage.shared.showMessage(messageType: .error, message: "trailer does not exist")
                }
            }
        }
       
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == clvCast) {
            return listCast.count
        }else if(collectionView == clvBackDrops) {
            return listBackdrops.count
        }else if(collectionView == clvNote) {
            return notes.count
        }
        return listRecommendations.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == clvCast) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorsCell", for: indexPath) as! ActorsCell
            let item = listCast[indexPath.row]
            cell.ivPoster.setImage(imageUrl: item.profile_path)
            cell.lblName.text = item.name
            return cell
        }
        if(collectionView == clvBackDrops) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackdropsCell", for: indexPath) as! BackdropsCell
            let item = listBackdrops[indexPath.row]
            cell.ivBackdrops.setImage(imageUrl: item.filePath)
            return cell
        }else if(collectionView == clvNote) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteDetailCell", for: indexPath) as! NoteDetailCell
            let item = notes[indexPath.row]
            cell.lblNote.text = item
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoveCell", for: indexPath) as! PopularMoveCell
        cell.setData(moveDetail: listRecommendations[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == clvCast) {
            return CGSize(width: 104, height: 136)
        }else if(collectionView == clvBackDrops) {
            return CGSize(width: 272, height: 153)
        }else if(collectionView == clvNote) {
            return CGSize(width: 272, height: 82)
        }
        return CGSize(width: 150, height: 266)
    }

}
extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSeasons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "SeasonCell", for: indexPath) as! SeasonCell
        
        let seasonModel = listSeasons[indexPath.row]
        cell.lblName.text = seasonModel.name
        cell.lblUserScore.text = seasonModel.air_date.dateToString(dateFormat: "yyyy")
        cell.lblContent.text = "\(seasonModel.episode_count) Episodes"
        cell.ivPoster.setImage(imageUrl: moveDetail.poster_path)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }
}
