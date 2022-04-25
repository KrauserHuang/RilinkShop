//
//  CalendarViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit
import EzPopup

class CalendarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "TimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "timeCollectionViewCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
//        setting collectionViewCell's frame
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: (self.view.frame.width - 48) / 2, height: 50)
                flowLayout?.estimatedItemSize = .zero
                flowLayout?.minimumInteritemSpacing = 1
    }

}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCollectionViewCell", for: indexPath) as! TimeCollectionViewCell
        
        cell.bottomView.layer.borderWidth = 1
        cell.bottomView.layer.borderColor = UIColor.lightGray.cgColor
//        UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        cell.bottomView.layer.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let popupVC = PopupViewController(contentController: SuccessAlert(), popupWidth: self.view.frame.width - 32, popupHeight: self.view.frame.height * 0.5)
        popupVC.cornerRadius = 20
        present(popupVC, animated: true)
    }
    
    
}
