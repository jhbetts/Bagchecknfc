import SwiftUI
import CoreLocation
import CoreData
import Combine
//import CoreNFC

struct ContentView: View {
    @EnvironmentObject var storefront: Storefront
    @ObservedObject var NFCR = NFCReader()
    @ObservedObject var NFCW = NFCWriter()
    @State private var shotClub = Club()
    @State private var ballClub = Club()
    @State private var showNewClub: Bool = false
    @State var refreshClubs: UUID = UUID()
    @State var refreshGames: UUID = UUID()
    @State var roundStarted = false
    @State var premium = false
    @EnvironmentObject var locationManager: LocationManagerModel
    @AppStorage("STROKES") var counter = 0
    @AppStorage("PUTTS") var puttCounter = 0
    

    var body: some View {
        VStack{
            if !premium {
                SwiftUIBannerAd(adPosition: .top, adUnitId: "ca-app-pub-3940256099942544/2934735716")
            }
            
            TabView{
                ClubListView(premium: $premium, refreshGames: $refreshGames, refreshClubs: $refreshClubs, counter: $counter, puttCounter: $puttCounter, roundStarted: $roundStarted)
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle.portrait")
                    }
                    .accentColor(Color.green)
                    .id(refreshClubs)
                
                RoundView(counter: $counter, puttCounter: $puttCounter, roundStarted: $roundStarted)
                    .tabItem {
                        Image(systemName: "flag")
                    }
                    .accentColor(Color.green)
                    .id(refreshGames)
            }.task {
                do {
                    premium = try await storefront.store.isPurchased("com.BagCheck.PurchasePro.GoPro")
                    print("isPurchased ran")
                }
                catch {
                    premium = false
                    print("isPurchased failed")
                }
            }
        }
        
    }
}


