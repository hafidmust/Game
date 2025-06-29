import Foundation
import Combine
import GameCore

class HomeViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getGamesUseCase: GetGamesUseCase
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    
    init(getGamesUseCase: GetGamesUseCase) {
        self.getGamesUseCase = getGamesUseCase
    }
    
    func loadGames() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        getGamesUseCase.execute(page: currentPage)
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
                        if self?.currentPage == 1 {
                            self?.games = games
                        } else {
                            self?.games.append(contentsOf: games)
                        }
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func loadMoreGames() {
        currentPage += 1
        loadGames()
    }
    
    func refreshGames() {
        currentPage = 1
        loadGames()
    }
} 