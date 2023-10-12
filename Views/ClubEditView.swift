import SwiftUI
import SwiftNFC
struct ClubEditView: View {
    @EnvironmentObject var storefront: Storefront
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var club: Club
    @StateObject var NFCW = NFCWriter()
    @StateObject var NFCR = NFCReader()
    //@State var isEditing: Bool = false
//    @State private var nfcTag = ""
//    @State private var scannedNfcTag: String = ""
    @State var showGoPro = false
    @Binding var showEdit: Bool
    @Binding var isPutter: Bool
    @State var premium = false
    var body: some View {
        @State var isPutter: Bool = false
        VStack{
            Spacer()
            VStack(alignment: .leading) {
                HStack{
                    Button(action: {
                        if premium {
                            NFCW.msg = club.name
                            write()
                            print("nfc write here")
                        } else {
                            showGoPro = true
                        }
                    }) {
                        Image(systemName: "wave.3.left.circle")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            .aspectRatio(1.0, contentMode: .fit)
                    }
                    .sheet(isPresented: $showGoPro, content: {
                        GoProView(showGoPro: $showGoPro)
                            .accentColor(.green)
                    })
                    Spacer()
                    Button(action: {self.showEdit = false}){
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.accentColor)
                    }//: Button
                }//:HStack
                .padding(.bottom)
                
                TextField("\(club.name)", text: self.$club.name, onEditingChanged:{self.showEdit = $0})
                    .padding()
                    .background(Color(.systemGray3))
                    .cornerRadius(10)
                    .padding(.bottom)
                    .cornerRadius(10)
                Toggle(isOn: self.$club.putter, label: {
                    Text("Putter")
                    
                }).padding(.bottom)
                HStack{
                    Button(action: {self.club.strokesList.removeAll(keepingCapacity: false)
                    },label: {
                        Text("Erase Shot Data")
                            .foregroundColor(.white)
                            .font(.system(.title, design: .rounded, weight: .bold))
                            .frame(maxWidth: .infinity)
                    }).buttonStyle(.borderedProminent)
                        .tint(.red)
                }
                Spacer()
            }//:VStack
            .padding(.vertical)
            .padding()
            .background(Color(.systemGray4))
            .cornerRadius(10, antialiased: true)
        }//:VStack
        .edgesIgnoringSafeArea(.bottom)
        .task {
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
    func write() {
               NFCW.write()
           }
    
}
