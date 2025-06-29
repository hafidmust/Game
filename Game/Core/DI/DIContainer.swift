import Foundation
import GameCore
import GameData

class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Data Layer
    private lazy var gameRemoteDataSource: GameRemoteDataSource = GameRemoteDataSourceImpl()
    private lazy var gameLocalDataSource: GameLocalDataSource = GameLocalDataSourceImpl()
    private lazy var gameRepository: GameDataRepository = GameRepositoryImpl(
        remoteDataSource: gameRemoteDataSource,
        localDataSource: gameLocalDataSource
    )
    
    // MARK: - Domain Layer (Use Cases from GameCore)
    private lazy var getGamesUseCase: GetGamesUseCase = GetGamesUseCase(repository: gameRepository)
    private lazy var getGameDetailUseCase: GetGameDetailUseCase = GetGameDetailUseCase(repository: gameRepository)
    private lazy var getFavoriteGamesUseCase: GetFavoriteGamesUseCase = GetFavoriteGamesUseCase(repository: gameRepository)
    private lazy var addFavoriteGameUseCase: AddFavoriteGameUseCase = AddFavoriteGameUseCase(repository: gameRepository)
    private lazy var removeFavoriteGameUseCase: RemoveFavoriteGameUseCase = RemoveFavoriteGameUseCase(repository: gameRepository)
    
    // MARK: - Presentation Layer
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(getGamesUseCase: getGamesUseCase)
    }
    
    func makeDetailViewModel() -> DetailViewModel {
        return DetailViewModel(
            getGameDetailUseCase: getGameDetailUseCase,
            addFavoriteGameUseCase: addFavoriteGameUseCase,
            removeFavoriteGameUseCase: removeFavoriteGameUseCase
        )
    }
    
    func makeFavoriteViewModel() -> FavoriteViewModel {
        return FavoriteViewModel(getFavoriteGamesUseCase: getFavoriteGamesUseCase)
    }
} 
