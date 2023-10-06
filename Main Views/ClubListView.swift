import SwiftUI
//import SwiftNFC
import CoreNFC

struct ClubListView: View {
    @EnvironmentObject var storefront: Storefront
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var locationManager: LocationManagerModel
    @FetchRequest(
        entity: Club.entity(),
        sortDescriptors:[])
    private var clubs:FetchedResults<Club>
    @ObservedObject var NFCR = NFCReader()
    @ObservedObject var NFCW = NFCWriter()
    @State private var shotClub = Club()
    @State private var ballClub = Club()
    @State private var showNewClub: Bool = false
    @State private var showSettings: Bool = false
    @State var premium = false
    @Binding var refreshGames: UUID
    @Binding var refreshClubs: UUID 
    @Binding var counter: Int
    @Binding var puttCounter: Int
    @Binding var roundStarted: Bool
    //@Binding var waiting: Bool
    //@Binding var showError: Bool
    
    var body: some View {
        let addNewShot = NewShotModel(locationManager: locationManager, counter: $counter, roundStarted: $roundStarted)
        NavigationView{
            ZStack {
                HStack{
                    Spacer()
                    VStack{
                        Spacer()
                        if premium {
                            Button(action: {
                                read()
                                ////READ NFC TAG
                            }, label: {
                                ReadNFCButton()
                                    .frame(width: 50, height: 50, alignment: .center)
                            })
                            .padding(.bottom, 30)
                            .padding(.horizontal, 30)
                            .shadow(color: Color.black.opacity(0.3), radius: 3, x: -3.0, y: 0.0)
                            }
                        }
                        
                }
                .zIndex(1.0)
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: -2, y: 0)
                List { 
                    ForEach(clubs.sorted{$0.averageYardage > $1.averageYardage}) {club in 
                        NavigationLink(destination: ClubDetailView(club: club, shotClub: $shotClub, ballClub: $ballClub, counter: $counter, puttCounter: $puttCounter, roundStarted: $roundStarted, showError: $locationManager.showError)
                            , label:{
                                ClubListRow(club: club, shotClub: $shotClub).environmentObject(locationManager)
                            } )
                    }
                    .onDelete(perform: deleteClub)
                } //: List
                .scrollIndicators(.hidden)
                
                if clubs.count == 0 && !self.showNewClub {
                    //locationManager.waiting = false
                    Button("Tap to Start Adding Clubs!") {
                        self.showNewClub = true
                    } .foregroundColor(.accentColor)
                        .font(.system(.largeTitle,design: .rounded))
                }
            } //: ZStack
            .navigationTitle("Clubs")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.showSettings = true
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.accentColor)
                    } //: Button
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showNewClub = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.accentColor)
                    } //: Button
                } //: ToolbarItem
            } //: .toolbar
        }//.id(refreshClubs)
        .onChange(of: locationManager.distanceChange, perform: {
            value in
            if locationManager.distanceYards != nil{
                addNewShot.addNewShot(shotClub: shotClub, newShot: locationManager.distanceYards!, waiting: locationManager.waiting, ballClub: ballClub, viewContext: viewContext)
                
                shotClub = ballClub
            }
        })
        //.environmentObject(locationManager)
        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
        .sheet(isPresented: $showNewClub) {
            NewClubView(isShow: $showNewClub).accentColor(Color.green)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(refreshClubs: $refreshClubs, refreshGames: $refreshGames)
                .accentColor(Color.green)
        }.task {
            do {
                premium = try await storefront.store.isPurchased("com.BagCheck.PurchasePro.GoPro")
                print("isPurchased ran")
            }
            catch {
                premium = false
                print("isPurchased failed")
            }
        }.onChange(of: NFCR.msg) {newValue in
            print("test")
            if !locationManager.waiting && !shotClub.putter{
                locationManager.currentLocation(mode: .shot)
                shotClub.name = NFCR.msg
            } else if locationManager.waiting && shotClub.putter {
                locationManager.currentLocation(mode: .ball)
                    ballClub = shotClub
                    if roundStarted {
                        puttCounter += 1
                        counter += 1
                    }
                    
                    shotClub.strokesList.append(0)
                    if ballClub.putter == true {
                        locationManager.waiting = false
                    }
            } else if !locationManager.waiting && shotClub.putter {
                if roundStarted{
                    counter += 1
                    puttCounter += 1
                }
                shotClub.strokesList.append(0)
            }

        }
    }
    func read() {
        NFCR.read()
    }
    
    private func deleteClub(index: IndexSet) -> Void {
        withAnimation {
            index.map { clubs[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError.localizedDescription)")
            }
        }
    }
}
struct ReadNFCButton: View {
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Image(systemName: "wave.3.left.circle")
                    .symbolRenderingMode(.monochrome)
                    .resizable()
                    .foregroundColor(.green)
                    .aspectRatio(1.0, contentMode: .fit)
            }
        }
        
    }
}

struct ReadNFCButton_Previews: PreviewProvider {
    static var previews: some View {
        ReadNFCButton()
    }
}
