import SwiftUI

@main
struct MyApp: App {

    @State private var showSplash = true

    var body: some Scene {

        WindowGroup {

            Group {

                if showSplash {
                    SplashScreen()
                } else {
                    MainPage()
                }

            }
            .task {

                try? await Task.sleep(nanoseconds: 2_000_000_000)

                withAnimation {
                    showSplash = false
                }
            }
            .preferredColorScheme(.dark)

        }
    }
}
