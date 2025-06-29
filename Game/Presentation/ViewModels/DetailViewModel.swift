import Foundation
import Combine
import GameCore

class DetailViewModel: ObservableObject {
    @Published var game: Game?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFavorite = false
    
    private let getGameDetailUseCase: GetGameDetailUseCase
    private let addFavoriteGameUseCase: AddFavoriteGameUseCase
    private let removeFavoriteGameUseCase: RemoveFavoriteGameUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(
        getGameDetailUseCase: GetGameDetailUseCase,
        addFavoriteGameUseCase: AddFavoriteGameUseCase,
        removeFavoriteGameUseCase: RemoveFavoriteGameUseCase
    ) {
        self.getGameDetailUseCase = getGameDetailUseCase
        self.addFavoriteGameUseCase = addFavoriteGameUseCase
        self.removeFavoriteGameUseCase = removeFavoriteGameUseCase
    }
    
    func loadGameDetail(id: Int) {
        isLoading = true
        errorMessage = nil
        
        getGameDetailUseCase.execute(id: id)
            .sink(
                receiveCompletion: { [weak self] completion in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        if case .failure(let error) = completion {
                            self?.errorMessage = error.localizedDescription
                        }
                    }
                },
                receiveValue: { [weak self] game in
                    DispatchQueue.main.async {
                        self?.game = game
                        self?.isFavorite = game.isFavorite
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func toggleFavorite() {
        guard let game = game else { return }
        
        if isFavorite {
            removeFavoriteGameUseCase.execute(id: game.id)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            print("Error removing favorite: \(error)")
                        }
                    },
                    receiveValue: { [weak self] success in
                        DispatchQueue.main.async {
                            if success {
                                self?.isFavorite = false
                            }
                        }
                    }
                )
                .store(in: &cancellables)
        } else {
            addFavoriteGameUseCase.execute(game: game)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            print("Error adding favorite: \(error)")
                        }
                    },
                    receiveValue: { [weak self] success in
                        DispatchQueue.main.async {
                            if success {
                                self?.isFavorite = true
                            }
                        }
                    }
                )
                .store(in: &cancellables)
        }
    }
} 