import SwiftUI
import CoreLocation
import CoreData
import Charts


struct ClubDetailView: View {
    @EnvironmentObject var storefront: Storefront
    @ObservedObject var club: Club
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var locationManager: LocationManagerModel
    @FetchRequest(
        entity: Club.entity(),
        sortDescriptors:[])
    private var clubs:FetchedResults<Club>
    @State var compareClub: Club?
    @State var newShot: Int = 0
    @State private var showEdit: Bool = false
    @Binding var shotClub: Club
    @Binding var ballClub: Club
    @Binding var counter: Int
    @Binding var puttCounter: Int
    @Binding var roundStarted: Bool
    @Binding var showError: Bool
    
    

    var body: some View{
        ZStack {
            if locationManager.waiting && club == shotClub{
                HStack{
                    Spacer()
                    VStack{
                        Spacer()
                        Button(action: {
                            locationManager.waiting = false
                        }, label: {
                            CancelTrackingButton()
                                .frame(width: 50, height: 50, alignment: .center)
                        })
                        .padding(.bottom, 75)
                        .padding(.horizontal, 10)
                        .shadow(color: Color.black.opacity(0.3), radius: 3, x: -3.0, y: 0.0)
                    }
                }
                .zIndex(1.0)
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: -2, y: 0)
            }
            VStack{
                List {
                    if self.club.putter == false {
                        ClubDetailBody(club: club, compareClub: compareClub)
                        
                        Section {
                            ForEach(club.strokesList, id: \.self) { stroke in
                                Text("\(stroke)y") 
                            }.onDelete(perform: deleteStroke)
                        }
                    } else {
                        Section {
                            Text("Average Putts per Hole: club.strokesList.count / holes played")
                            Text("\(club.strokesList.count) Strokes Counted")
                        }
                    }
                }.scrollIndicators(.hidden)
                
                Spacer()

                if !locationManager.waiting && !club.putter {
                    Button(action: {locationManager.currentLocation(mode: .shot)
                        //waiting = true
                        shotClub = club
                        //let clubContext = viewContext
                    },label: {
                        Text("Swing Location")
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 1)
                            .font(.system(.title, design: .rounded, weight: .bold))
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.borderedProminent)
                    .alert("Shot Location has not been recorded. Please try again.", isPresented: $showError) {
                        Button("OK", role: .cancel) {}
                    }
                }
                if locationManager.waiting && !club.putter {
                    Button(action: {locationManager.currentLocation(mode: .ball)
                        ballClub = club
                    }, label: {
                        Text("Ball Location")
                            .foregroundColor(.white)
                        .shadow(color: .black, radius: 1)
                            .font(.system(.title, design: .rounded, weight: .bold))
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.borderedProminent)
                }
                if locationManager.waiting && club.putter {
                    Button(action: {locationManager.currentLocation(mode: .ball)
                        ballClub = club
                        if roundStarted {
                            puttCounter += 1
                            counter += 1
                        }
                        club.strokesList.append(0)
                        if ballClub.putter {
                            locationManager.waiting = false
                        }
                    }, label: {
                        Text("Start Putting")
                            .foregroundColor(.white)
                        .shadow(color: .black, radius: 1)
                            .font(.system(.title, design: .rounded, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .transition(.move(edge: .bottom))
                            .animation(.spring(), value: true)
                    })
                    .buttonStyle(.borderedProminent)
                }
                if !locationManager.waiting && club.putter {
                    Button(action: {
                        if roundStarted{
                            counter += 1
                            puttCounter += 1
                        } 
                        club.strokesList.append(0)                        
                    }, label: {
                        Text("Record Putts")
                            .foregroundColor(.white)
                            .font(.system(.title, design: .rounded, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .transition(.move(edge: .bottom))
                            .animation(.spring(), value: true)
                    })
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle(club.name)
            
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu{
                            Picker("Compare", selection: $compareClub) {
                                Text("Nothing").tag(nil as Club?)
                                ForEach(clubs.filter{$0 != club}) {club in
                                    Text(club.name)
                                        .tag(Optional(club))
                                }
                            }
                        } label: {
                            Text("Compare")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Edit") {
                            self.showEdit = true
                        }.foregroundColor(.accentColor).opacity(100)
                    } //: ToolbarItem 
                }
                .toolbar{
                    if locationManager.waiting {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Holed Out!") {
                                locationManager.currentLocation(mode: .ball)
                                locationManager.waiting = false
                            }.foregroundColor(.accentColor).opacity(100)
                        } //: ToolbarItem 
                    }
                }
                .zIndex(0)
                .sheet(isPresented: $showEdit) {
                    ClubEditView(club: club, showEdit: self.$showEdit, isPutter: $club.putter).accentColor(Color.green)
                        //.environmentObject(storefront)
                }
        }
        
    }
    private func deleteStroke(at offsets: IndexSet) {
        club.strokesList.remove(atOffsets: offsets)
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
extension UINavigationController{
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }   
}

struct CancelTrackingButton: View {
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.monochrome)
                    .resizable()
                    .foregroundColor(.red)
                    .aspectRatio(contentMode: .fit)
            }
        }
        
    }
}

struct CancelTrackingButton_Previews: PreviewProvider {
    static var previews: some View {
        CancelTrackingButton()
    }
}

struct ClubCompareChartView: View {
    var club: Club
    var compareClub: Club?
    var body: some View {
        let yMinValue = min(club.strokesList.min()!, compareClub?.strokesList.min()! ?? club.strokesList.min()!)
        let yMaxValue = max(club.strokesList.max()!, compareClub?.strokesList.max()! ?? club.strokesList.max()!)
        Chart(Array(club.strokesList.enumerated()), id: \.offset) { nr, element in
            PointMark(
                x: .value("X value", nr),
                y: .value("Y value", element)
            )
            
            
            if let cmpr = compareClub{
                ForEach(Array(cmpr.strokesList.enumerated()), id: \.offset) {nr, element in
                    PointMark(
                        x: .value("X value", nr),
                        y: .value("Y value", element)
                    ).foregroundStyle(.blue)
                }
            }
        }.chartYScale(domain: yMinValue - 10...yMaxValue + 10)
    }
}

struct ClubDetailBody: View {
    let club: Club
    let compareClub: Club?
    var body: some View {
        Section {
            //Text(self.club.name)
            Text("Average distance: \(club.averageYardage) yards")
            Text("\(club.strokesList.count) Strokes Counted")
            Text("Distance Standard Deviation: \(lround(club.strokesStandardDeviation))y")
        }
        ClubCompareChartView(club: club, compareClub: compareClub)
            .animation(.easeInOut, value: compareClub)
        
            .listRowBackground(Color.clear)
    }
}
