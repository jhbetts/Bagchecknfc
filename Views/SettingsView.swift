import SwiftUI
import CoreData

struct SettingsView: View {
    @EnvironmentObject var storefront: Storefront
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Club.entity(),
        sortDescriptors:[],
        animation: .default)
    private var clubs:FetchedResults<Club>
    @State var clubsDeleteAlert = false
    @State var roundDeleteAlert = false
    @State var showGoPro = false
    @State var premium = false
    @Binding var refreshClubs: UUID
    @Binding var refreshGames: UUID
    
    var body: some View {
        VStack {
            if !premium {
                Button(action: {
                    showGoPro = true
                }, label: {
                    SettingsButtons(buttonString: "Go Pro!")
                    
                }).buttonStyle(.bordered)
                    .padding(.top)
                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            } else {
                Button(action: {
                    
                }, label: {
                    SettingsButtons(buttonString: "You're a Pro!")
                    
                }).buttonStyle(.bordered)
                    .padding(.top)
                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
            
            
            Button(action: {
                clubsDeleteAlert = true
            }, label: {
                SettingsButtons(buttonString: "Erase All Club Data")
            }).buttonStyle(.bordered)
                .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .alert("Do you want to delete all Club Data? This action cannot be reversed.", isPresented: $clubsDeleteAlert) {
                    Button("Yes", role: .destructive) {deleteAll(name: "Club")}
                }
            
            
            Button(action: {
                roundDeleteAlert = true
            }, label: {
                SettingsButtons(buttonString: "Erase All Round Data")
            }).buttonStyle(.bordered)
                .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .alert("Do you want to delete all Round Data? This action cannot be reversed.", isPresented: $roundDeleteAlert) {
                    Button("Yes", role: .destructive) {deleteAll(name: "Game")}
                }
            
            
            Button(action: {
                print("restore purchases")
            }, label: {
                SettingsButtons(buttonString: "Restore Past Purchases")
            }).buttonStyle(.bordered)
                .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Spacer()
        }.sheet(isPresented: $showGoPro, content: {
            GoProView(showGoPro: $showGoPro)
                //.environmentObject(storefront)
                .accentColor(Color.green)
        })
        .onDisappear(perform: {
            
        })
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
    func deleteAll(name: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            try viewContext.execute(deleteRequest)
            if name == "Club" {
                do {self.refreshClubs = UUID()
                    
                }
            }else {
                do {self.refreshGames = UUID()
                    
                }
            }
        } catch {
            print("d_ error")
        }
    }
}

struct SettingsButtons: View {
    @EnvironmentObject var storefront: Storefront
    @State var buttonString: String
    var body: some View {
        HStack{
            Text(buttonString)
                .font(.title)
                .font(.system(.title, design: .rounded, weight: .bold))
            .shadow(color: .black, radius: 1)
                .frame(maxWidth: .infinity)
            
        }
        
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        
//        SettingsView(refreshClubs: refreshClubs, premium: .constant(true))
//    }
//}
