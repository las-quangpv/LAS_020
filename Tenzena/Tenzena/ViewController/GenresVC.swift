//
//  GenresVC.swift
//  Las020
//
//  Created by apple on 14/11/2023.
//

import UIKit

class GenresVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var vLineTvShow: UIView!
    @IBOutlet weak var vLineMove: UIView!
    @IBOutlet weak var clvGenres: UICollectionView!

    var list: [Genres] = []
    var isMove = true
    override func viewDidLoad() {
        super.viewDidLoad()
        clvGenres.delegate = self
        clvGenres.dataSource = self
        clvGenres.register(UINib(nibName: "GenresCell", bundle: nil), forCellWithReuseIdentifier: "GenresCell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        vLineMove.isHidden = false
        vLineTvShow.isHidden = true
        isMove = true
        list = listGenres
        clvGenres.reloadData()
    }

    @IBAction func actionMove(_ sender: Any) {
        vLineMove.isHidden = false
        vLineTvShow.isHidden = true
        list = listGenres
        isMove = true
        clvGenres.reloadData()
    }
    
    @IBAction func actionTvShow(_ sender: Any) {
        vLineMove.isHidden = true
        vLineTvShow.isHidden = false
        isMove = false
        list = listTvGenres
        clvGenres.reloadData()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCell", for: indexPath)  as! GenresCell
        cell.lblName.text = list[indexPath.row].name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(ActivityEx.isPad()) {
            return CGSize(width: clvGenres.frame.size.width/4, height: 100)
        }
        return CGSize(width: clvGenres.frame.size.width/2-12, height: 51)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genes = list[indexPath.row]
        let vc = ShowMoreDetailVC()
        vc.genres = genes
        vc.isMove = isMove
        vc.detailType = DetailType.GENRES.rawValue
        vc.titleTv = genes.name
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
