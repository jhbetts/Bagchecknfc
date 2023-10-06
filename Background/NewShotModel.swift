import SwiftUI
import CoreData
import CoreLocation


class NewShotModel: ObservableObject {
    
    private let locationManager: LocationManagerModel
    @Binding var counter: Int
    @Binding var roundStarted: Bool
    init(locationManager: LocationManagerModel, counter: Binding<Int>, roundStarted: Binding<Bool>) {
        self.locationManager = locationManager
        self._counter = counter
        self._roundStarted = roundStarted
    }
    
    
    
    
    func addNewShot(shotClub: Club, newShot: Int, waiting: Bool, ballClub: Club, viewContext: NSManagedObjectContext) -> Void {
        let shotClub = shotClub
        let newShot = newShot
        shotClub.strokesList.append(newShot)
        
        if roundStarted {
            counter += 1
        }
        do {
            try viewContext.save()
            
            locationManager.shotCoord = locationManager.ballCoord
            //let shotClub = ballClub
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError.localizedDescription)")
        }
    }
}
