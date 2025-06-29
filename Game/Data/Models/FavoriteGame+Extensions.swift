import Foundation
import CoreData
import GameCore

// MARK: - Domain Mapper Extensions
extension FavoriteGame {
    func toDomain() -> Game {
        return Game(
            id: Int(id),
            name: name ?? "",
            backgroundImage: backgroundImage,
            rating: rating,
            released: released,
            metacritic: Int(metacritic),
            playtime: Int(playtime),
            genres: [], // Simplified for favorite
            platforms: [], // Simplified for favorite
            description: gameDescription,
            website: website,
            isFavorite: true
        )
    }
    
    func fromDomain(_ game: Game) {
        self.id = Int32(game.id)
        self.name = game.name
        self.backgroundImage = game.backgroundImage
        self.rating = game.rating
        self.released = game.released
        self.metacritic = Int32(game.metacritic ?? 0)
        self.playtime = Int32(game.playtime)
        self.gameDescription = game.description
        self.website = game.website
    }
    
    // Helper method to create new instance
    static func create(from game: Game, in context: NSManagedObjectContext) -> FavoriteGame {
        let favoriteGame = FavoriteGame(context: context)
        favoriteGame.fromDomain(game)
        return favoriteGame
    }
} 