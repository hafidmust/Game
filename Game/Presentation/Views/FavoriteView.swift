import SwiftUI
import GameCore

struct FavoriteView: View {
    @StateObject private var viewModel = DIContainer.shared.makeFavoriteViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading favorites...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Error")
                            .font(.headline)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            viewModel.refreshFavorites()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.favoriteGames.isEmpty {
                    VStack {
                        Image(systemName: "heart")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No Favorite Games")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Add games to favorites from the detail page")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.favoriteGames) { game in
                            NavigationLink(destination: DetailView(gameId: game.id)) {
                                GameRowView(game: game)
                            }
                        }
                    }
                    .refreshable {
                        viewModel.refreshFavorites()
                    }
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.loadFavoriteGames()
            }
        }
    }
}

#Preview {
    FavoriteView()
}