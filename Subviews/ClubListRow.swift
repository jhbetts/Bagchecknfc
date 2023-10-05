import SwiftUI

struct ClubListRow: View {
    @EnvironmentObject var storefront: Storefront
    @ObservedObject var club: Club
    @EnvironmentObject var locationManager: LocationManagerModel
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var shotClub: Club
    var body: some View {
        HStack{
            if locationManager.waiting && shotClub == club {
                Image(systemName: "target")
                    .foregroundColor(.accentColor)
            }
            Text(self.club.name)
                .fontWeight(.bold)
                .font(.title3)
                //.padding(.leading)
            
            Spacer()
                
            if !club.putter {
                Text("\(club.averageYardage)y")
                    .fontWeight(.bold)
                    .font(.title3)
                HStack(spacing: -3){
                    VStack(spacing:-10) {
                        Text("+")
                            .padding(.top)
                        Text("-")
                        Spacer() 
                    }
                    Text(" \(lround(club.strokesStandardDeviation))y")
                }
            }
        }
    }
}

struct ClubListRow_Previews: PreviewProvider {
    static var previews: some View {
        let testClub = Club(context: PersistanceController.preview.container.viewContext)
        testClub.id = UUID()
        testClub.name = "Test Task"
        testClub.putter = false
        
        @State var shotClub = testClub
        
        return ClubListRow(club: testClub, shotClub: $shotClub)
    }
}
