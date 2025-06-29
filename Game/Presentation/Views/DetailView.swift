import SwiftUI
import GameCore

struct DetailView: View {
    let gameId: Int
    @StateObject private var viewModel = DIContainer.shared.makeDetailViewModel()
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Loading game details...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Text("Error")
                        .font(.headline)
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        viewModel.loadGameDetail(id: gameId)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let game = viewModel.game {
                VStack(alignment: .leading, spacing: 16) {
                    // Header Image
                    AsyncImage(url: URL(string: game.backgroundImage ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(height: 250)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // Title and Favorite Button
                        HStack {
                            Text(game.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.toggleFavorite()
                            }) {
                                Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                    .font(.title2)
                                    .foregroundColor(viewModel.isFavorite ? .red : .gray)
                            }
                        }
                        
                        // Rating and Release Info
                        HStack {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", game.rating))
                                    .fontWeight(.semibold)
                            }
                            
                            Spacer()
                            
                            if let released = game.released {
                                Text("Released: \(released)")
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Metacritic Score
                        if let metacritic = game.metacritic, metacritic > 0 {
                            HStack {
                                Text("Metacritic Score:")
                                    .fontWeight(.semibold)
                                Text("\(metacritic)")
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(metacriticColor(score: metacritic))
                                    )
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        // Playtime
                        if game.playtime > 0 {
                            HStack {
                                Image(systemName: "clock")
                                Text("Average playtime: \(game.playtime) hours")
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        // Genres
                        if !game.genres.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Genres")
                                    .font(.headline)
                                
                                LazyVGrid(columns: [
                                    GridItem(.adaptive(minimum: 100))
                                ], alignment: .leading) {
                                    ForEach(game.genres) { genre in
                                        Text(genre.name)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(Color.blue.opacity(0.2))
                                            )
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        
                        // Platforms
                        if !game.platforms.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Platforms")
                                    .font(.headline)
                                
                                LazyVGrid(columns: [
                                    GridItem(.adaptive(minimum: 120))
                                ], alignment: .leading) {
                                    ForEach(game.platforms) { platform in
                                        Text(platform.name)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(Color.green.opacity(0.2))
                                            )
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                        }
                        
                        // Description
                        if let description = game.description, !description.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Description")
                                    .font(.headline)
                                
                                Text(description)
                                    .lineLimit(nil)
                            }
                        }
                        
                        // Website Link
                        if let website = game.website, !website.isEmpty {
                            Link(destination: URL(string: website)!) {
                                HStack {
                                    Image(systemName: "link")
                                    Text("Visit Website")
                                }
                                .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadGameDetail(id: gameId)
        }
    }
    
    private func metacriticColor(score: Int) -> Color {
        switch score {
        case 75...100:
            return .green
        case 50..<75:
            return .yellow
        default:
            return .red
        }
    }
}

#Preview {
    NavigationView {
        DetailView(gameId: 1)
    }
}