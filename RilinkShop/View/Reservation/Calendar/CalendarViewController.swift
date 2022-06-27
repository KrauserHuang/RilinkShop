//
//  CalendarViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit
import EzPopup
import FSCalendar

class CalendarViewController: UIViewController {

//    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarPicker: FSCalendar!
    @IBOutlet weak var emptyView: UIView!
    
    var location: String?
    var name: String?
    var mobile: String?
    var license: String?
    var carType: String?
    var repairType: String?
    var carDescription: String? = ""
    var appointment: String?
    var store = Store()
    let account = MyKeyChain.getAccount() ?? ""
    let password = MyKeyChain.getPassword() ?? ""
    lazy var selectedDate: String = {
        dateFormatter.string(from: Date())
    }() {
        didSet {
            updateBookingData()
        }
    }
//    var storeBookingDateString = ""
    var storeBookingData = [FixMotor]() {
        didSet {
            updateBookingData()
        }
    }
    
    var bookingDataForSelectedDate = [FixMotor]()
    
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
        configureCalendar()
        configureTableView()
        viewInit()
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func configureCalendar() {
        calendarPicker.delegate = self
        calendarPicker.dataSource = self
    }
    
    func configureTableView() {
        let nib = UINib(nibName: CalendarTableViewCell.cellIdentifier(), bundle: nil)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nib, forCellReuseIdentifier: CalendarTableViewCell.cellIdentifier())
    }
    
    func viewInit() {
        FixMotorService.shared.storeBookingTime(id: account, pwd: password, storeId: store.storeID) { success, response in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.sync {
                    
                    guard success else {
                        HUD.hideLoadingHUD(inView: self.view)
                        let errmsg = response as! String
                        Alert.showMessage(title: "", msg: errmsg, vc: self) {
                            
                        }
                        return
                    }
                    
                    HUD.hideLoadingHUD(inView: self.view)
                    self.storeBookingData = response as! [FixMotor]
                }
            }
        }
    }
    private func updateBookingData() {
        bookingDataForSelectedDate = storeBookingData.filter { $0.bookingdate == selectedDate }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.emptyView.isHidden = self.bookingDataForSelectedDate.count != 0
        }
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 從點擊的 date 轉會成字串存在 dateString 裡
        selectedDate = dateFormatter.string(from: date)
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingDataForSelectedDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.cellIdentifier(), for: indexPath) as? CalendarTableViewCell else {
            return UITableViewCell()
        }
        
        let bookingData = bookingDataForSelectedDate[indexPath.row]
        
        cell.configure(with: bookingData)
        cell.delegate = self
        
        return cell
    }
}

extension CalendarViewController: CalendarTableViewCellDelegate {
    func didMakeAppointment(_ cell: CalendarTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        print(indexPath)
        let duration = bookingDataForSelectedDate[indexPath.row].duration
        print(#function)
        print(duration)
        let vc = HostelCheckoutViewController()
        vc.location = location // storeName
        vc.name = name
        vc.mobile = mobile
        vc.license = license
        vc.carType = carType
        vc.repairType = repairType
        vc.carDescription = carDescription
        vc.appointment = selectedDate
        vc.duration = duration
        vc.store = store
        navigationController?.pushViewController(vc, animated: true)
    }
}

//var location: String?
//var name: String?
//var mobile: String?
//var license: String?
//var carType: String?
//var repairType: String?
//var carDescription: String? = ""
//var appointment: String?
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
