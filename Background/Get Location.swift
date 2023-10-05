import SwiftUI
import CoreLocation
import CoreNFC


class LocationManagerModel : NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    
    enum LocationMode {
        case ball, shot, putt 
        //addNewShot(distance: Double, shotClub: Club)
    }
    
    //@Environment(\.managedObjectContext) private var viewContext
    //@ObservedObject var club: Club
    @Published var shotCoord : CLLocation?
    @Published var ballCoord : CLLocation?
    //@Published var clubContext: NSManagedObjectContext?
    @Published var waiting = false
    @Published var errorMessage = ""
    @Published var showError = false
    @Published var distanceYards: Int?
    @Published var distanceChange = false
    //@Published var shotClub: Club
    private let locationManager = CLLocationManager()
    private var mode : LocationMode = .ball
    private var nfcSession: NFCReaderSession?
    private var scannedClubID: String?
    
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
    }
    
    func startNFCReader() {
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {
            print("NFC Reader Error: \(readerError.localizedDescription)")
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        guard let tag = messages.first?.records.first, tag.typeNameFormat == .nfcWellKnown, let payloadType = String(data: tag.type, encoding: .utf8), payloadType == "T", let clubID = String(data: tag.payload, encoding: .utf8) else {
            session.invalidate(errorMessage: "Invalid NFC Tag")
            return
        }
        DispatchQueue.main.async {
            self.scannedClubID = clubID
        }
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
