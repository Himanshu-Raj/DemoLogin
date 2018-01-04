//
//  UserDetailsDisplayVC.swift
//  DemoLogin Algofocus
//
//  Created by Chaudhary Himanshu Raj on 30/12/17.
//  Copyright © 2017 Chaudhary Himanshu Raj. All rights reserved.
//

import UIKit
import CoreLocation
import FBSDKLoginKit

class UserDetailsDisplayVC: UIViewController, CLLocationManagerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var userProfilePicIV: UIImageView!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailIDLabel: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var birthdayLbl: UILabel!
    @IBOutlet weak var nativePlaceLbl: UILabel!
    @IBOutlet weak var currentLocationLbl: UILabel!
    @IBOutlet weak var HiSomeoneLabel: UILabel!
    
    
    // MARK: Variables Declaration
    var setName : String!
    var setFirstName : String!
    var setLastName : String!
    var setEmailId : String!
    var setBirthday : String!
    var setGender : String!
    var setNativeLocation : String!
    var setProfilePic : String!
    
    // Instantiating Location Manager
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var currentLocation : CLLocation!
    
    // MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfilePicIV.layer.cornerRadius = userProfilePicIV.frame.size.width / 2
        // Do any additional setup after loading the view.
        // Setting manager delegates
        locationManager.delegate = self
        
        // Setting location accuracy for user to best
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Asking for user's permission to access it's location
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startMonitoringSignificantLocationChanges()
        
        // Now this ensures everytime a function(namely, didUpdateLocations) is to be called whenever users' last location has changed even by a bit.
        locationManager.startUpdatingLocation()
        
        updateDetailFields()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        locationAuthorizationStatus()
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: IBActions for the VC.
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let manager : FBSDKLoginManager = FBSDKLoginManager()
        manager.logOut()
        
        // These will also forget user details if they get saved while login, so that next it's a fresh login
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        
        // This will navigate back to previous view controller.
        _ = navigationController?.popToRootViewController(animated:true)
    }
    
    // MARK: Functions for misc.
    // Add masking th the selected image but to only on the front image
    func masking()
    {
        let maskLayer = CALayer()
        maskLayer.frame = userProfilePicIV.bounds
        maskLayer.shadowRadius = 5
        maskLayer.shadowPath = CGPath(roundedRect: userProfilePicIV.bounds.insetBy(dx: CGFloat(5), dy: CGFloat(5)), cornerWidth: 10, cornerHeight: 10, transform: nil)
        maskLayer.shadowOpacity = 15
        maskLayer.shadowOffset = CGSize.zero
        maskLayer.shadowColor = UIColor.black.cgColor
        userProfilePicIV.layer.mask = maskLayer
        userProfilePicIV.layer.cornerRadius = userProfilePicIV.frame.size.width / 2
    }
    
    func updateDetailFields() {
        HiSomeoneLabel.text = "Hi, \(setName!)...!!! This is what Facebook told us about you..!!!"
        
        // Pushing Downloading image task to the background thread
        let url = URL(string: setProfilePic)!
        DispatchQueue.global().async {
            do {
                let data = try Data (contentsOf : url)
                DispatchQueue.global().sync {
                    self.userProfilePicIV.image = UIImage(data : data)
                }
            } catch {
                print("Some Error Occured in Downloading the Profile pic")
            }
        }
        
        firstNameLbl.text = "First Name is : \(setFirstName!)"
        lastNameLbl.text = "Last Name is : \(setLastName!)"
        emailIDLabel.text = "Email Id is : \(setEmailId!)"
        genderLbl.text = "Gender is : \(setGender!)"
        birthdayLbl.text = "Your were born on : \(setBirthday!)"
        nativePlaceLbl.text = "And your hometown is : \(setNativeLocation!)"
    }
    
    // MARK: Function to get authorization from user.
    func locationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthorizationStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Users' all locations will be stored in this array, latest being on index 0.
        let location = locations[0]
        
         // Location.sharedInstance.latitude = currentLocation.coordinate.latitude
         // Location.sharedInstance.longitude = currentLocation.coordinate.longitude
        
        // Taking location Coordinates.
        // let userLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Location.sharedInstance.latitude , Location.sharedInstance.longitude)
        
        // We can may details from the location variable.
        print(location.altitude)
        print(location.speed)
        
        // MARK: Geocoding using latitude and longitude
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("Error in reverseGeocode")
            }
            
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let place = placemarks![0]

                var adressString : String = ""
                
                if place.thoroughfare != nil {
                    adressString = adressString + place.thoroughfare! + ", "
                }
                if place.subThoroughfare != nil {
                    adressString = adressString + place.subThoroughfare! + "\n"
                }
                if place.locality != nil {
                    adressString = adressString + place.locality! + " - "
                }
                if place.postalCode != nil {
                    adressString = adressString + place.postalCode! + "\n"
                }
                if place.subAdministrativeArea != nil {
                    adressString = adressString + place.subAdministrativeArea! + " - "
                }
                if place.country != nil {
                    adressString = adressString + place.country!
                }
                
                self.currentLocationLbl.text = "Currently, your are in : \(adressString)"
            }
        })
    }
}
