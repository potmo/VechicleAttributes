//
//  DataStructures.swift
//  VehicleAttributes
//
//  Created by Tom Dowding on 15/08/2017.
//
//

import Foundation


enum GearboxType {
    case Manual
    case Automatic
    case Unknown
}

enum FuelType {
    case Gasoline
    case Diesel
    case Unknown
    // There may be more, this is passed in json
}

enum DrivingType {
    case Urban
    case Rural
    case Mixed
    case Unknown
}


struct Gearbox {
    
    let gearboxType: GearboxType
    
    init(gearboxType: String) {
        
        switch gearboxType.lowercased() {
        case "manual":
            self.gearboxType = GearboxType.Manual
        case "automatic":
            self.gearboxType = GearboxType.Automatic
        default:
            self.gearboxType = GearboxType.Unknown
        }
    }
    
    static func getReadableType (gearboxType: GearboxType) -> String {
    
        switch gearboxType {
        case GearboxType.Manual:
            return NSLocalizedString("manual_gearbox", comment: "displaying gearbox type")
        case GearboxType.Automatic:
            return NSLocalizedString("automatic_gearbox", comment: "displaying gearbox type")
        default:
            return NSLocalizedString("unknown_attribute", comment: "displaying unknown attribute")
        }
    }
}

struct EmissionSubstance {
    
    let name: String
    let drivingType: DrivingType
    let amount: Float
    
    init(name: String, drivingType: String, amount: Float) {
        self.name = name
        
        switch drivingType.lowercased() {
        case "urban":
            self.drivingType = DrivingType.Urban
        case "rural":
            self.drivingType = DrivingType.Rural
        case "mixed":
            self.drivingType = DrivingType.Mixed
        default:
            self.drivingType = DrivingType.Unknown
        }
        
        self.amount = amount
    }
    
    static func getReadableType (drivingType: DrivingType) -> String {
        return FuelConsumption.getReadableType(drivingType:drivingType)
    }
}

class Emission {
    
    let fuelType: FuelType
    var substances = [EmissionSubstance]()
   
    init(fuelType: String) {
        
        switch fuelType.lowercased() {
        case "gasoline":
            self.fuelType = FuelType.Gasoline
        case "diesel":
            self.fuelType = FuelType.Diesel
        default:
            self.fuelType = FuelType.Unknown
        }
    }
}

struct FuelConsumption {
    
    let drivingType: DrivingType
    let amount: Float
    
    init(drivingType: String, amount: Float) {
        
        switch drivingType.lowercased() {
        case "urban":
            self.drivingType = DrivingType.Urban
        case "rural":
            self.drivingType = DrivingType.Rural
        case "mixed":
            self.drivingType = DrivingType.Mixed
        default:
            self.drivingType = DrivingType.Unknown
        }
        
        self.amount = amount
    }
    
    static func getReadableType (drivingType: DrivingType) -> String {
        
        switch drivingType {
        case DrivingType.Mixed:
            return NSLocalizedString("mixed_driving_style", comment: "displaying driving type")
        case DrivingType.Urban:
            return NSLocalizedString("urban_driving_style", comment: "displaying driving type")
        case DrivingType.Rural:
            return NSLocalizedString("rural_driving_style", comment: "displaying driving type")
        default:
            return NSLocalizedString("unknown_attribute", comment: "displaying unknown attribute")
        }
    }
}

class Fuel {
    
    let fuelType: FuelType
    var tankVolume: Float? // in liters
    var consumptions = [FuelConsumption]()
    
    init(fuelType: String) {
        
        switch fuelType.lowercased() {
        case "gasoline":
            self.fuelType = FuelType.Gasoline
        case "diesel":
            self.fuelType = FuelType.Diesel
        default:
            self.fuelType = FuelType.Unknown
        }
    }
    
    static func getReadableFuelType (fuelType: FuelType) -> String {
        
        switch fuelType {
        case FuelType.Gasoline:
            return NSLocalizedString("gasoline", comment: "displaying fuel type")
        case FuelType.Diesel:
            return NSLocalizedString("diesel", comment: "displaying fuel type")
        default:
            return NSLocalizedString("unknown_attribute", comment: "displaying unknown attribute")
        }
    }
}
