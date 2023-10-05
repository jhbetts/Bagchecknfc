import SwiftUI

struct BlankView: View {
    @EnvironmentObject var storefront: Storefront
    var body: some View {
        Color.black
            .opacity(1.0)
            .ignoresSafeArea()
    }
}

struct BlankView_Previews: PreviewProvider {
    static var previews: some View {
        BlankView()
    }
}
