//
//  ActorsVC.swift
//  Las020
//
//  Created by apple on 14/11/2023.
//

import UIKit

class ActorsVC: BaseMainVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var clvActor: UICollectionView!
    var listPerson: [DPersonModel] = []
    var page = 1
    var totalPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        clvActor.delegate = self
        clvActor.dataSource = self
        clvActor.register(UINib(nibName: "ActorsCell", bundle: nil), forCellWithReuseIdentifier: "ActorsCell")
        callApi()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    func callApi() {
        self.showLoading()
        DApiManage.getInstance.getPersonPopular(page: page) { [self] data in
            self.hideLoading()
            if let list = data.data as? [DPersonModel] {
                list.forEach { personModel in
                    listPerson.append(personModel)
                }
            }
            if let totalPage = data.totalPage as? Double {
                self.totalPage = Int(totalPage)
            }
            clvActor.reloadData()
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPerson.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorsCell", for: indexPath) as! ActorsCell
        let personModel = listPerson[indexPath.row]
        cell.lblName.text = personModel.name
        cell.ivPoster.setImage(imageUrl: personModel.profilePath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(ActivityEx.isPad()) {
            return CGSize(width: clvActor.frame.size.width/4-16, height: 280)
        }
        return CGSize(width: clvActor.frame.size.width/3-16, height: 140)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = listPerson.count - 1
        if indexPath.item == lastItem && self.page <= Int(totalPage) {
            self.page += 1
            callApi()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PersonDetailVC()
        vc.dPersonDetail = listPerson[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
