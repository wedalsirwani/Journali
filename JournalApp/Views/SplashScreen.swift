import SwiftUI

struct SplashScreen: View {

    var body: some View {
        VStack(spacing: 20) {
            Image("JournalLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text("Journali")
                .font(.system(size: 42, weight: .bold))
            
            Text("Your thoughts, your story")
                .font(.system(size: 18, weight: .light))
        }
//   .preferredColorScheme(.dark)
    }
}

#Preview {
    SplashScreen()
}
//
