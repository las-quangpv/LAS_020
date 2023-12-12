//
//  PersonDetailVC.swift
//  Las020
//
//  Created by apple on 18/11/2023.
//

import UIKit

class PersonDetailVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var clvKnownFor: UICollectionView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vStatusBar: UIView!
    var dPersonDetail: DPersonModel!
    var personDetail: DPersonDetailModel!
    var listKnowFor: [KnownForModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView.delegate = self
        clvKnownFor.delegate = self
        clvKnownFor.dataSource = self
        clvKnownFor.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: "SearchCell")
        listKnowFor = dPersonDetail.listKnownFor
        clvKnownFor.reloadData()
        callApi()
        
        // Do any additional setup after loading the view.
    }
    
    func callApi() {
        self.showLoading()
        DApiManage.getInstance.getPersonDetail("\(dPersonDetail.id)") { [self] data in
            self.hideLoading()
            if let personDetail = data.data as? DPersonDetailModel {
                self.personDetail = personDetail
                lblName.text = dPersonDetail.name
                ivPoster.setImage(imageUrl: dPersonDetail.profilePath)
                let deathday = personDetail.deathday
                if((deathday.isTextEmpty() && !personDetail.birthday.isTextEmpty()) ||
                (!personDetail.birthday.isTextEmpty() && !deathday.isTextEmpty())) {
                    if let age = calculateAge(birthDate: personDetail.birthday) {
                        lblDate.text = "\(personDetail.birthday) (\(age) years old)"
                    }
                }
                lblOverview.text = personDetail.biography
            }
        }
    }
    
    func calculateAge(birthDate: String, deathDate: String? = "") -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dateOfBirth = dateFormatter.date(from: birthDate) {
            let currentDate = deathDate != "" ? dateFormatter.date(from: deathDate!) ?? Date() : Date()
            
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: currentDate)
            
            return ageComponents.year
        } else {
            return nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listKnowFor.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let model = listKnowFor[indexPath.row]
        cell.lblName.text = model.title
        cell.ivPoster.setImage(imageUrl: model.posterPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.clvKnownFor.frame.size.width/3-8, height: 211)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let knownForModel = listKnowFor[indexPath.row]
        let moveDetail = DMoviesDetail()
        moveDetail.backdrop_path = knownForModel.backdrop_path
        moveDetail.genre_ids = knownForModel.genre_ids
        moveDetail.id = knownForModel.id
        moveDetail.overview = knownForModel.overview
        moveDetail.original_title = knownForModel.original_name
        moveDetail.title = knownForModel.title
        moveDetail.release_date = knownForModel.releaseDate
        moveDetail.poster_path = knownForModel.posterPath
        moveDetail.vote_average = knownForModel.vote_average
        moveDetail.vote_count = Int(knownForModel.vote_count)
        let vc = DetailVC()
        vc.moveDetail = moveDetail
        if(knownForModel.mediaType == "movie") {
            vc.isMove = true
        }else {
            vc.isMove = false
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let yOffset = scrollView.contentOffset.y
//        let statusBarOffset: CGFloat = 200.0
//        let offset = yOffset/statusBarOffset
//        let alpha = min(1.0, max(0.0, offset))
//        vStatusBar.backgroundColor = UIColor(hex: 0x040404, alpha: alpha)
//    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
