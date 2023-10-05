import SwiftUI
import CoreData
import Foundation

@objc(Game)
public class Game: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var score: Int
    @NSManaged public var putts: Int
    @NSManaged public var date: Date
    @NSManaged public var golfCourse: String
}

@objc(Club)
public class Club: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var strokes: Int
    @NSManaged public var putter: Bool
    @NSManaged public var strokesList: [Int]
    @NSManaged public var hidden: Bool
    @NSManaged public var nfcTag: String
}

extension Club: Identifiable {
//    var yards: Yards{
//        get {
//            Yards(rawValue: Int(yardsNum)) ?? .normal
//        }
//        
//        set {
//            self.yardsNum = Int(newValue.rawValue)
//        }
//    }
    var strokesStandardDeviation: Double {
        guard !strokesList.isEmpty else {
            return 0.0 // or another appropriate value when the list is empty
        }
        let mean = Double(strokesList.reduce(0, +)) / Double(strokesList.count)
        let squaredDifferences = strokesList.map { pow(Double($0) - mean, 2) }
        let variance = squaredDifferences.reduce(0, +) / Double(strokesList.count)
        return sqrt(variance)
    }
    var averageYardage: Int {
        guard !strokesList.isEmpty else {
            return 0
        }
        let numStrokes = strokesList.count
        let sumArray = strokesList.reduce(0,+)
        let averageYardage = sumArray / numStrokes
        return averageYardage
    }
}
enum Yards: Int {
    case normal = 0
}
