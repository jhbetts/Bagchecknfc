import SwiftUI
import CoreLocation
import CoreNFC


class LocationManagerModel : NSObject, ObservableObject {
    
    enum LocationMode {
        case ball, shot, putt 
    }
    
    @Published var shotCoord : CLLocation?
    @Published var ballCoord : CLLocation?
    @Published var waiting = false
    @Published var errorMessage = ""
    @Published var showError = false
    @Published var distanceYards: Int?
    @Published var distanceChange = false
    private let locationManager = CLLocationManager()
    private var mode : LocationMode = .ball
    private var nfcSession: NFCReaderSession?
    private var scannedClubID: String?
    
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
    }
    
    
    public func currentLocation(mode: LocationMode) {
        self.mode = mode
        locationManager.requestLocation()
    }
}

extension LocationManagerModel : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        switch mode {
        case .ball:
            if let shotCoord = shotCoord {
                ballCoord = locations.last!
                let distance = ballCoord!.distance(from: shotCoord)
                distanceYards = lround(distance * 1.09361)
                distanceChange.toggle()
                
            } else {
                showError = true
                print("shotCoord is nil")
                waiting = false
                
            }
            
        case .shot:
            shotCoord = locations.last!
            waiting = true
            
        case .putt:
            if let shotCoord = shotCoord {
                ballCoord = locations.last!
                waiting = false
            } else {
                print("shotCoord is nil")
            }
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            return
            
        case .authorizedWhenInUse:
            return
            
        case .denied, .restricted: print("denied")
            
        case .notDetermined: print("notDetermined")
            locationManager.requestWhenInUseAuthorization()
        @unknown default: print("This should never appear")
        }
    }
}
