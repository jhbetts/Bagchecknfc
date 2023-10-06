import SwiftUI



struct CompareButton: View {
    @EnvironmentObject var storefront: Storefront
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Club.entity(),
        sortDescriptors:[])
    private var clubs:FetchedResults<Club>
    @State var compareClub: Club?
    var body: some View {
        VStack{
            Picker(selection:$compareClub,
                   label: Text("Compare"),
                   content: {ForEach(clubs) {club in 
                Text(club.name)
                    .tag(Optional(club))
            }
            }).pickerStyle(.menu)
        }
    }
}

struct CompareButton_Previews: PreviewProvider {
    static var previews: some View {
        CompareButton()
    }
}
