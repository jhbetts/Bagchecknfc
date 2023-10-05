import SwiftUI

struct GoProView: View {
    @EnvironmentObject var storefront: Storefront
    @Binding var showGoPro: Bool
    var body: some View {
        VStack{
//            Image("BagCheck Icon Empty")
//                .resizable()
//                .frame(width: 200, height: 200)
//                .padding(.top)
            VStack(alignment: .center) {
                Image("BagCheck Icon Empty")
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .cornerRadius(10, antialiased: true)
//                    .shadow(color: .black, radius: 10, x: 10.0, y: 0.0)
                    .padding(.top)
                TabView() {
                    VStack{
                        CopyBlock(copy: "Get ad-free, permanent access to all pro features including: ")
                            .padding(.top, 75)
                            .padding(.horizontal, 30)
                        Spacer()
                    }
                    VStack{
                        CopyBlock(copy: "NFC Club Tagging for quick shot tracking, so you can focus on your shot, not your phone.")
                        .padding(.top, 75)
                        .padding(.horizontal, 30)
                        Spacer()
                    }
                    VStack{
                        CopyBlock(copy: "Adding unlimited clubs to your bag, great for comparing models to find the best club for your game")
                        .padding(.top, 75)
                        .padding(.horizontal, 30)
                        Spacer()
                    }
                    VStack{
                        CopyBlock(copy: "Apple Watch companion app coming soon!")
                            .padding(.top, 75)
                        Spacer()
                    }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                
                
                Button(action: {
                    storefront.purchasePro()
                    showGoPro = false
                }, label: {
                    SettingsButtons(buttonString: "\(storefront.product!.displayName) \(storefront.product!.displayPrice)")
                        .shadow(color: .black, radius: 1)
                        .font(.system(.title, design: .rounded, weight: .bold))
                }).buttonStyle(.borderedProminent)
                    .padding(.top)
                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .padding(.bottom)
            }
        }.background(
            Image("Background Image 4")
                .resizable()
                .ignoresSafeArea()
        )
    }
}

struct GoProView_Previews: PreviewProvider {
    //@EnvironmentObject var storefront: Storefront
    static var previews: some View {
        
        GoProView(showGoPro: .constant(true))
    }
}


struct CopyBlock: View {
    let copy: String
    var body: some View {
        Text(copy)
            .shadow(color: .black, radius: 5)
            .font(.title2)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            
            
    }
}
