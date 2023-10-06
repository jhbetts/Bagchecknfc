import SwiftUI

struct GameDetailView: View {
    @ObservedObject var game: Game
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack{
            List{
                //Text("Course: \(game.golfCourse)")
                Text("Score: \(game.score)")
                Text("Putts: \(game.putts)")
                Text("Date: \(formatDate(game.date))")
            }
        }
    }
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short // You can adjust the style according to your preference
        //formatter.timeStyle = .short // Adjust time style as needed
        return formatter.string(from: date)
    }
}

//struct GameDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let testGame = Game(context: PersistanceController.preview.container.viewContext)
//        testGame.id = UUID()
//        testGame.date = Date()
//        testGame.score = 75
//        testGame.putts = 40
//        GameDetailView(game: testGame)
//    }
//}
