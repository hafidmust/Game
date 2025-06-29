import SwiftUI
import GameCore

struct HomeView: View {
    @StateObject private var viewModel = DIContainer.shared.makeHomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && viewModel.games.isEmpty {
                    ProgressView("Loading games...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Error")
                            .font(.headline)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            viewModel.refreshGames()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.games) { game in
                            NavigationLink(destination: DetailView(gameId: game.id)) {
                                GameRowView(game: game)
                            }
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                    .refreshable {
                        viewModel.refreshGames()
                    }
                }
            }
            .navigationTitle("Games")
            .onAppear {
                if viewModel.games.isEmpty {
                    viewModel.loadGames()
                }
            }
        }
    }
}

struct GameRowView: View {
    let game: Game
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: game.backgroundImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 80, height: 60)
            .clipped()
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(game.name)
                    .font(.headline)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", game.rating))
                        .font(.caption)
                    
                    Spacer()
                    
                    if game.isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                }
                
                if let released = game.released {
                    Text("Released: \(released)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    HomeView()
} 