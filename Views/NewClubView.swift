import SwiftUI
import CoreNFC
struct NewClubView: View {
    @EnvironmentObject var storefront: Storefront
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var nfcReader = NFCReader()
    @FocusState private var focusedField: Focus?
    @State private var clubName: String = ""
    @State private var clubYards: Yards = .normal
    @State private var isPutter: Bool = false
    @State private var isEditing: Bool = false
    @State var showGoPro = false
    //@State private var nfcTag = ""
    //@State private var scannedNfcTag: String = ""
    @Binding var isShow: Bool
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                HStack{
                    Text("Add a new Club")
                        .font(.system(.title,design: .rounded))
                        .fontWeight(.bold)
                    Spacer()
                    
//                    Button(action:{
//                        addTestClubs()
//                    }, label: {
//                        Text("Test")})
                    
                    Button(action: {self.isShow = false}){
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.accentColor)
                    }//: Button
                }//:HStack
                
                TextField("New Club Name", text: self.$clubName, onEditingChanged:{self.isEditing = $0})
                    .padding()
                    .background(Color(.systemGray3))
                    .cornerRadius(10)
                    .padding(.bottom)
                    .onSubmit {
                        guard self.clubName.trimmingCharacters(in: .whitespaces) != "" else {return}
                        
                        //self.isShow = false
                        self.addNewClub(name: self.clubName, yards: self.clubYards, isPutter: self.isPutter, nfcReader: self.nfcReader, showGoPro: self.showGoPro, storefront: self.storefront)
                        self.clubName = ""
                        focusedField = .name
                    }
                    .focused($focusedField, equals: .name)
                .cornerRadius(10)
                Toggle(isOn: $isPutter, label: {
                    Text("Putter")
                })
                Spacer()
            }//:VStack
            .padding(.vertical)
            .padding()
            .background(Color(.systemGray4))
            .cornerRadius(10, antialiased: true)
            //prevents system keyboard from overlaying view
            //.offset(y: self.isEditing ? -320 : 0)
        }//:VStack
        .onAppear {
            focusedField = .name
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showGoPro, content: {
            GoProView(showGoPro: $showGoPro).accentColor(Color.green)
        })
    }
    private enum Focus: Int, Hashable {
        case name
    }
    
    
//    func addTestClubs() -> Void {
//        let club0 = Club(context: viewContext)
//        let arr0 = (1...30).map({_ in Int.random(in: 270...290)})
//        club0.id = UUID()
//        club0.name = "New Driver"
//        club0.putter = false
//        club0.strokes = 30
//        club0.strokesList = arr0
//        let club1 = Club(context: viewContext)
//        let arr1 = (1...30).map({_ in Int.random(in: 240...300)})
//        club1.id = UUID()
//        club1.name = "Old Driver"
//        club1.putter = false
//        club1.strokes = 30
//        club1.strokesList = arr1
//        
//        let club2 = Club(context: viewContext)
//        let arr2 = (1...30).map({_ in Int.random(in: 170...190)})
//        club2.id = UUID()
//        club2.name = "3 Hybrid"
//        club2.putter = false
//        club2.strokes = 30
//        club2.strokesList = arr2
//        
//        let club3 = Club(context: viewContext)
//        let arr3 = (1...30).map({_ in Int.random(in: 160...175)})
//        club3.id = UUID()
//        club3.name = "4 Hybrid"
//        club3.putter = false
//        club3.strokes = 30
//        club3.strokesList = arr3
//        
//        let club4 = Club(context: viewContext)
//        let arr4 = (1...30).map({_ in Int.random(in: 150...165)})
//        club4.id = UUID()
//        club4.name = "5 Iron"
//        club4.putter = false
//        club4.strokes = 30
//        club4.strokesList = arr4
//        
//        let club5 = Club(context: viewContext)
//        let arr5 = (1...30).map({_ in Int.random(in: 145...155)})
//        club5.id = UUID()
//        club5.name = "6 Iron"
//        club5.putter = false
//        club5.strokes = 30
//        club5.strokesList = arr5
//        
//        let club6 = Club(context: viewContext)
//        let arr6 = (1...30).map({_ in Int.random(in: 140...150)})
//        club6.id = UUID()
//        club6.name = "7 Iron"
//        club6.putter = false
//        club6.strokes = 30
//        club6.strokesList = arr6
//        
//        let club7 = Club(context: viewContext)
//        let arr7 = (1...30).map({_ in Int.random(in: 130...145)})
//        club7.id = UUID()
//        club7.name = "8 Iron"
//        club7.putter = false
//        club7.strokes = 30
//        club7.strokesList = arr7
//        
//        let club8 = Club(context: viewContext)
//        let arr8 = (1...30).map({_ in Int.random(in: 125...135)})
//        club8.id = UUID()
//        club8.name = "9 Iron"
//        club8.putter = false
//        club8.strokes = 30
//        club8.strokesList = arr8
//        
//        let club9 = Club(context: viewContext)
//        let arr9 = (1...30).map({_ in Int.random(in: 115...130)})
//        club9.id = UUID()
//        club9.name = "P Wedge"
//        club9.putter = false
//        club9.strokes = 30
//        club9.strokesList = arr9
//        
//        let club10 = Club(context: viewContext)
//        let arr10 = (1...30).map({_ in Int.random(in: 100...120)})
//        club10.id = UUID()
//        club10.name = "52º Wedge"
//        club10.putter = false
//        club10.strokes = 30
//        club10.strokesList = arr10
//        
//        let club11 = Club(context: viewContext)
//        let arr11 = (1...30).map({_ in Int.random(in: 90...105)})
//        club11.id = UUID()
//        club11.name = "56º Wedge"
//        club11.putter = false
//        club11.strokes = 30
//        club11.strokesList = arr11
//        
//        let club12 = Club(context: viewContext)
//        let arr12 = (1...30).map({_ in Int.random(in: 60...90)})
//        club12.id = UUID()
//        club12.name = "60º Wedge"
//        club12.putter = false
//        club12.strokes = 30
//        club12.strokesList = arr12
//        
//        let club13 = Club(context: viewContext)
//        club13.id = UUID()
//        club13.name = "Putter"
//        club13.putter = true
//        club13.strokes = 30
//        club13.strokesList = []
//        
//        let game0 = Game(context: viewContext)
//        game0.id = UUID()
//        game0.score = 83
//        game0.putts = 33
//        game0.date = Date()
//        game0.golfCourse = "Pebble Beach"
//        
//        let game1 = Game(context: viewContext)
//        game1.id = UUID()
//        game1.score = 77
//        game1.putts = 33
//        game1.date = Date.now.addingTimeInterval(86400 * 1)
//        game1.golfCourse = "Pebble Beach"
//        
//        let game2 = Game(context: viewContext)
//        game2.id = UUID()
//        game2.score = 85
//        game2.putts = 33
//        game2.date = Date.now.addingTimeInterval(86400 * 2)
//        game2.golfCourse = "Pebble Beach"
//        
//        let game3 = Game(context: viewContext)
//        game3.id = UUID()
//        game3.score = 89
//        game3.putts = 33
//        game3.date = Date.now.addingTimeInterval(86400 * 3)
//        game3.golfCourse = "Pebble Beach"
//        
//        let game4 = Game(context: viewContext)
//        game4.id = UUID()
//        game4.score = 76
//        game4.putts = 33
//        game4.date = Date.now.addingTimeInterval(86400 * 4)
//        game4.golfCourse = "Pebble Beach"
//        
//        let game5 = Game(context: viewContext)
//        game5.id = UUID()
//        game5.score = 84
//        game5.putts = 33
//        game5.date = Date.now.addingTimeInterval(86400 * 5)
//        game5.golfCourse = "Pebble Beach"
//        
//        let game6 = Game(context: viewContext)
//        game6.id = UUID()
//        game6.score = 79
//        game6.putts = 33
//        game6.date = Date.now.addingTimeInterval(86400 * 6)
//        game6.golfCourse = "Pebble Beach"
//        
//        let game7 = Game(context: viewContext)
//        game7.id = UUID()
//        game7.score = 81
//        game7.putts = 33
//        game7.date = Date.now.addingTimeInterval(86400 * 7)
//        game7.golfCourse = "Pebble Beach"
//        
//        let game8 = Game(context: viewContext)
//        game8.id = UUID()
//        game8.score = 80
//        game8.putts = 33
//        game8.date = Date.now.addingTimeInterval(86400 * 8)
//        game8.golfCourse = "Pebble Beach"
//        
//        let game9 = Game(context: viewContext)
//        game9.id = UUID()
//        game9.score = 85
//        game9.putts = 33
//        game9.date = Date.now.addingTimeInterval(86400 * 9)
//        game9.golfCourse = "Pebble Beach"
//        
//        let game10 = Game(context: viewContext)
//        game10.id = UUID()
//        game10.score = 78
//        game10.putts = 33
//        game10.date = Date.now.addingTimeInterval(86400 * 10)
//        game10.golfCourse = "Pebble Beach"
//        
//        let game11 = Game(context: viewContext)
//        game11.id = UUID()
//        game11.score = 82
//        game11.putts = 33
//        game11.date = Date.now.addingTimeInterval(86400 * 11)
//        game11.golfCourse = "Pebble Beach"
//        
//        let game12 = Game(context: viewContext)
//        game12.id = UUID()
//        game12.score = 81
//        game12.putts = 33
//        game12.date = Date.now.addingTimeInterval(86400 * 12)
//        game12.golfCourse = "Pebble Beach"
//        
//        let game13 = Game(context: viewContext)
//        game13.id = UUID()
//        game13.score = 84
//        game13.putts = 33
//        game13.date = Date.now.addingTimeInterval(86400 * 13)
//        game13.golfCourse = "Pebble Beach"
//        
//        do {
//            try viewContext.save()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }

    
    
    func addNewClub(name: String, yards: Yards, isPutter: Bool, nfcReader: NFCReader, showGoPro: Bool, storefront: Storefront) -> Void {
        if !storefront.isPro {
            let maxClubs = 14  // Maximum allowed clubs
            if let clubs = try? viewContext.fetch(Club.fetchRequest()) as? [Club], clubs.count < maxClubs {
                let newClub = Club(context: viewContext)
                newClub.id = UUID()
                newClub.name = name.capitalized
                //newClub.yards = yards
                newClub.putter = isPutter
                newClub.strokes = 0
                newClub.strokesList = []
                newClub.hidden = false
                //newClub.nfcTag = ""
                
                do {
                    try viewContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                self.showGoPro = true
                print("Error: Too many clubs. Maximum allowed clubs is \(maxClubs).")
            }
        } else {
            let newClub = Club(context: viewContext)
                    newClub.id = UUID()
                    newClub.name = name.capitalized
                    //newClub.yards = yards
                    newClub.putter = isPutter
                    newClub.strokes = 0
                    newClub.strokesList = []
                    //newClub.nfcTag = ""
                    do {
                        try viewContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
        }
    }
}

struct NewClubView_Previews: PreviewProvider {
    static var previews: some View {
        NewClubView(isShow: .constant(true))
    }
}


