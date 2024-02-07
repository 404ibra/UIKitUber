//
//  HomeController.swift
//  UberClone
//
//  Created by İbrahim Aktaş on 5.02.2024.
//

import UIKit
import Firebase
import MapKit

private let reuseIdentifier = "LocationCell"

class HomeController: UIViewController {
    
    //MARK: - Properties
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private let inputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let tableView  = UITableView()
    private final let locationInputViewHeight: CGFloat = 200
    
    private var user: User? {
        didSet { locationInputView.user = user }
    }
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserLoggedIn()
        view.addSubview(inputActivationView)
        inputActivationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(view.frame.width - 64)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        fetchUserData()
    }
    //MARK: - API
    
    func fetchUserData() {
        Service.shared.fetchUserData { user in
            self.user = user
        }
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            print("User not logged in")
            DispatchQueue.main.async {
                let controller = UINavigationController(rootViewController: LoginController())
                self.present(controller, animated: true)
            }
        } else {
            //print("DEBUG: User id is: \(Auth.auth().currentUser?.uid)")
            configureUI()
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Error signing out")
        }
    }
}

//MARK: - Helpers
extension HomeController {
    func configureUI() {
        configureMapView()
    }
    func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        enableLocationServices()
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        oneAlphaInputActionView()
        
        inputActivationView.delegate = self
        locationInputView.delegate = self
    }
    
    func configureLocationInputView() {
        view.addSubview(locationInputView)
        locationInputView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(locationInputViewHeight)
        }
        locationInputView.alpha = 0
        locationInputView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.locationInputView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame.origin.y = self.locationInputViewHeight
            }
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        let height = view.frame.height-locationInputViewHeight
        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
        
        view.backgroundColor = .red
        view.addSubview(tableView)
    }
}

extension HomeController: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("DEBUG: Not determined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("DEBUG: Auth always")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use...")
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
}

//MARK: Input Action View
extension HomeController {
    func zeroAlphaInputActionView() {
        inputActivationView.alpha = 0
    }
    
    func oneAlphaInputActionView() {
        zeroAlphaInputActionView()
        UIView.animate(withDuration: 2.0) {
            self.inputActivationView.alpha = 1
        }
    }
}

//MARK: - Location Input Activation View Delegate
extension HomeController: LocationInputActivationViewDelegate {
    func presentLocationInputView() {
        self.inputActivationView.alpha = 0
        configureLocationInputView()
        configureTableView()
    }
}

//MARK: - LocationInputViewDelegate
extension HomeController: LocationInputViewDelegate {
    func dismissLocationInputView() {
        UIView.animate(withDuration: 0.3) {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
        } completion: { _ in
            self.locationInputView.removeFromSuperview()
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
            }
        }
    }
}


//MARK: UITableViewDelegate,UITableViewDelegate
extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Test"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        return cell
    }
}
