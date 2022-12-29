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
    var account = MyKeyChain.getAccount() ?? ""
    var password = MyKeyChain.getPassword() ?? ""
    lazy var selectedDate: String = { dateFormatter.string(from: Date() + 1) }() {
        didSet {
            updateBookingData()
        }
    }
    var storeBookingData = [FixMotor]() {
        didSet {
            updateBookingData()
        }
    }

    var bookingDataForSelectedDate = [FixMotor]()
//    var account: String!
//    var password: String!
//    init(account: String, password: String) {
//        super.init(nibName: nil, bundle: nil)
//        self.account = account
//        self.password = password
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
//        calendarPicker.minimumDate.addingTimeInterval(84600)
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CalendarTableViewCell.nib, forCellReuseIdentifier: CalendarTableViewCell.reuseIdentifier)
    }

    func viewInit() {
        FixMotorService.shared.storeBookingTime(id: account, pwd: password, storeId: store.storeID) { success, response in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.sync {

                    guard success else {
                        HUD.hideLoadingHUD(inView: self.view)
                        let errmsg = response as! String
                        Alert.showMessage(title: "", msg: errmsg, vc: self)
                        return
                    }

                    HUD.hideLoadingHUD(inView: self.view)
                    self.storeBookingData = response as! [FixMotor]
                }
            }
        }
    }
    private func updateBookingData() {
        bookingDataForSelectedDate = storeBookingData.filter { $0.bookingDate == selectedDate }
        bookingDataForSelectedDate = bookingDataForSelectedDate.sorted(by: { motor1, motor2 in
            motor1.duration < motor2.duration
        })
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
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date(timeIntervalSinceNow: 86400)
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingDataForSelectedDate.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.reuseIdentifier, for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }

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
        let vc = HostelCheckoutViewController(account: account, password: password)
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
