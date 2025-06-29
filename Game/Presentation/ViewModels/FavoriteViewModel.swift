import Foundation
import Combine
import GameCore

class FavoriteViewModel: ObservableObject {
    @Published var favoriteGames: [Game] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getFavoriteGamesUseCase: GetFavoriteGamesUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(getFavoriteGamesUseCase: GetFavoriteGamesUseCase) {
        self.getFavoriteGamesUseCase = getFavoriteGamesUseCase
    }
    
    func loadFavoriteGames() {
        isLoading = true
        errorMessage = nil
        
        getFavoriteGamesUseCase.execute()
            .sink(
                receiveCompletion: { [weak self] completion in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        if case .failure(let error) = completion {
                            self?.errorMessage = error.localizedDescription
                        }
                    }
                },
                receiveValue: { [weak self] games in
                    DispatchQueue.main.async {
                        self?.favoriteGames = games
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshFavorites() {
        loadFavoriteGames()
    }
} 