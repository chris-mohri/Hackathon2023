import CoreLocation
import UIKit
import MapKit
import SwiftUI



//-------------------------
class ViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    let defaults = UserDefaults.standard
    var list = [0.0];


    struct Keys {
        static let potholes = "potholes"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        
        // get list of pothole coords
        list = defaults.value(forKey: "potholes") as? Array ?? []
        //list=[]
        //add markers to map
        for i in stride(from:0, to: list.count, by:2){
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: list[i], longitude: list[i+1])
            mapView.addAnnotation(annotation)
          
        }
        

        // Request location authorization from the user
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //locationManager.startUpdatingLocation()
        }
        // Set up shake detection
        self.becomeFirstResponder()
        
       /*
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        
        }
        */
    }

    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            // Get the current location
            //locationManager.startUpdatingLocation()
            //locationManager.requestLocation()
            //locationManager.stopUpdatingLocation()
            //save the coordinates
            if let location = locationManager.location {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                let annotation = MKPointAnnotation()
                // Do something with the coordinates, such as save them to a file or send them to a server
                print("WAOW! Location: \(latitude), \(longitude)")
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                mapView.addAnnotation(annotation)
                
                //save to defaults
                list.append(latitude)
                list.append(longitude)
                
                defaults.set(list, forKey:"potholes")
                
                
                
            }
            
            } else {
                print("Location not available")
            }
        }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            print("Please allow location in preferences")
        }
    }
    
    func centerViewOnUserLocation() {

        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
}


extension ViewController: CLLocationManagerDelegate {
    
    // CLLocationManagerDelegate method to handle location authorization status changes
    func locationManager( _ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
            // Start updating location
            //locationManager.startUpdatingLocation()
        }
    
    
    // CLLocationManagerDelegate method to handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated:true)
        /*
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate

        mapView.mapType = MKMapType.standard

        let span = MKCoordinateSpan(latitudeDelta:0.05, longitudeDelta:0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Javed Multani"
        annotation.subtitle = "current location"
        mapView.addAnnotation(annotation)

            //centerMap(locValue)
        */
        
        // Do nothing - we're only using location when the shake gesture is detected
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
        }
        
        
    }
    
    
    // CLLocationManagerDelegate method to handle location errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: (error.localizedDescription)")
    }
    
}


