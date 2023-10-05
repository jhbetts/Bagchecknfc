import SwiftUI
import Charts

struct RoundView: View {
    @EnvironmentObject var storefront: Storefront
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Game.entity(),
        sortDescriptors:[])
    private var games:FetchedResults<Game>
    var scores: [Int] {
        games.map { Int($0.score) }
    }

    //@State private var game = Game()
    //@State var golfCourse = ""
    @State var today = Date()
    @State var gamesList: [Game] = []
    @State private var refreshID = UUID()
    @Binding var counter: Int
    @Binding var puttCounter: Int
    @Binding var roundStarted: Bool
    
    var body: some View {
        //var golfCourse = "test"
        let width: CGFloat = UIScreen.main.bounds.width * 0.9
        //ScrollView{
            VStack {
                if !roundStarted {
                    Button(action: {
                        roundStarted = true
                    }, label: {
                        Text("Start a Round")
                            .font(.title)
                    }).frame(width: width)
                        .padding()
                        .background(.quaternary)
                        .cornerRadius(10, antialiased: true)
                    Spacer()
                }
                if roundStarted {
                    VStack {
                        Text("\(counter)")
                            .font(.system(size: 100, weight: .bold, design: .default))
                        Text("Score")
                            .font(.title)
                            .frame(width: width, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        HStack{
                            Text("Putts: \(puttCounter)")
                        }
                        Button(action: {
                            roundStarted = false
                            today = Date.now
                            guard counter != 0 else {return}
                            self.addNewGame(today: today, puttCounter: puttCounter, counter: counter)
                            counter = 0
                            puttCounter = 0
                            self.refreshID = UUID()
                        }, label: {
                            Text("Finish Round")
                                .font(.title)
                        }).padding(.top)
                    }
                    .frame(width: width)
                    .padding()
                    .background(.quaternary)
                    .cornerRadius(10, antialiased: true)
                    .transition(.move(edge: .top))
                    Spacer()
                
                }
                if games.count > 0{
                    Section {
                        Chart {
                            ForEach(games) {
                                game in PointMark(x: PlottableValue.value("Date", game.date), y: PlottableValue.value("Score", game.score))
                            }
                        }.chartYScale(domain: scores.min()! - 5...scores.max()! + 5)
                            .padding(.all)
                            .frame(height: 250.0)
                    }
                    
                    
                
//                if games.count > 0{
//                    Section {
//                        Chart {
//                            ForEach(games) {
//                                game in PointMark(x: PlottableValue.value("Date", game.date), y: PlottableValue.value("Score", game.score))
//                            }
//                        }.padding(.all)
//                            .frame(height: 250.0)
//                    }
//                    NavigationView {
//                        List(games) {game in NavigationLink(destination: GameDetailView(game: game), label: {Text("Score: \(game.score)")})
//                        }
//                    }
                    
                    NavigationView {
                        List {
                            ForEach(games, id: \.id) {game in NavigationLink(destination: {GameDetailView(game: game)}, label: {GameListRow(game: game)})}
                            .onDelete(perform: deleteGame)
                        }.id(refreshID)
                    }
                }
            }
        //}
        .animation(.easeInOut, value: roundStarted)
    }
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short // You can adjust the style according to your preference
        //formatter.timeStyle = .short // Adjust time style as needed
        return formatter.string(from: date)
    }
    
    
    
    
    private func addNewGame(today: Date, puttCounter: Int, counter: Int) -> Void {
        let newGame = Game(context: viewContext)
        newGame.id = UUID()
        newGame.score = counter
        newGame.putts = puttCounter
        newGame.date = today
        newGame.golfCourse = ""
        
        
        do {
            
            try viewContext.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    func deleteGame(index: IndexSet) -> Void {
        withAnimation {
            index.map { games[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
                do{refreshID = UUID()}
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError.localizedDescription)")
            }
        }
    }
    
    
//    func deleteGame(index: IndexSet) {
//        for index in offsets {
//            let game = games[index]
//            viewContext.delete(game)
//        }
//        
//        do {
//            try viewContext.save()
//        } catch {
//            // Handle the error here
//            print("Error deleting game: \(error)")
//        }
//    }
}
struct RoundView_Previews: PreviewProvider {
    static var previews: some View {
        let testCounter = 10
        let roundStarted = Binding.constant(true)
        let counter = Binding.constant(testCounter)
        let puttCounter = Binding.constant(10)
        return RoundView(counter: counter, puttCounter: puttCounter, roundStarted: roundStarted)
    }
}
