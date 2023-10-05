import SwiftUI

struct GameListRow: View {
    @ObservedObject var game: Game
    @EnvironmentObject var storefront: Storefront
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        HStack {
            Text("Score: \(self.game.score)")
            Spacer()
            //Text("\(formatDate(game.date))")
        }
    }
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short // You can adjust the style according to your preference
        //formatter.timeStyle = .short // Adjust time style as needed
        return formatter.string(from: date)
    }
}

