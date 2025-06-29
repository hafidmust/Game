import Foundation
import Combine
import CoreData
import GameCore
import GameData

// MARK: - Implementation (Protocol from GameData package)
class GameLocalDataSourceImpl: GameLocalDataSource {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getFavoriteGames() -> AnyPublisher<[Game], Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "GameLocalDataSource", code: 0, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            
            let request: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
            
            do {
                let favoriteGames = try self.context.fetch(request)
                let games = favoriteGames.map { $0.toDomain() }
                promise(.success(games))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addFavoriteGame(_ game: Game) -> AnyPublisher<Bool, Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "GameLocalDataSource", code: 0, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            
            let favoriteGame = FavoriteGame.create(from: game, in: self.context)
            
            do {
                try self.context.save()
                promise(.success(true))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func removeFavoriteGame(id: Int) -> AnyPublisher<Bool, Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "GameLocalDataSource", code: 0, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            
            let request: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                let favoriteGames = try self.context.fetch(request)
                for favoriteGame in favoriteGames {
                    self.context.delete(favoriteGame)
                }
                try self.context.save()
                promise(.success(true))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func isGameFavorite(id: Int) -> AnyPublisher<Bool, Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "GameLocalDataSource", code: 0, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            
            let request: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                let count = try self.context.count(for: request)
                promise(.success(count > 0))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
} 