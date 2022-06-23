//
//  CalendarViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit
import EzPopup

class CalendarViewController: UIViewController {

//    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        collectionView.register(UINib(nibName: "TimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "timeCollectionViewCell")
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
//        
////        setting collectionViewCell's frame
//        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
//        flowLayout?.itemSize = CGSize(width: (self.view.frame.width - 48) / 2, height: 50)
//                flowLayout?.estimatedItemSize = .zero
//                flowLayout?.minimumInteritemSpacing = 1
        
        title = "時段預約"
        configureTableView()
    }
    
    func configureTableView() {
        let nib = UINib(nibName: CalendarTableViewCell.cellIdentifier(), bundle: nil)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nib, forCellReuseIdentifier: CalendarTableViewCell.cellIdentifier())
    }

}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.cellIdentifier(), for: indexPath) as? CalendarTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure()
        cell.delegate = self
        
        return cell
    }
}

extension CalendarViewController: CalendarTableViewCellDelegate {
    func didMakeAppointment(_ cell: CalendarTableViewCell) {
        //
    }
    
    
}

//extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 18
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCollectionViewCell", for: indexPath) as! TimeCollectionViewCell
//
//        cell.bottomView.layer.borderWidth = 1
//        cell.bottomView.layer.borderColor = UIColor.lightGray.cgColor
////        UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
//        cell.bottomView.layer.cornerRadius = 5
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let popupVC = PopupViewController(contentController: SuccessAlert(), popupWidth: self.view.frame.width - 32, popupHeight: self.view.frame.height * 0.5)
//        popupVC.cornerRadius = 20
//        present(popupVC, animated: true)
//    }
//}
