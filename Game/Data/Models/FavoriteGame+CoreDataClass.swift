import Foundation
import CoreData
import GameCore

@objc(FavoriteGame)
public class FavoriteGame: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteGame> {
        return NSFetchRequest<FavoriteGame>(entityName: "FavoriteGame")
    }
    
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var backgroundImage: String?
    @NSManaged public var rating: Double
    @NSManaged public var released: String?
    @NSManaged public var metacritic: Int32
    @NSManaged public var playtime: Int32
    @NSManaged public var gameDescription: String?
    @NSManaged public var website: String?
}

// MARK: - Identifiable
extension FavoriteGame: Identifiable {
    
} 