//
//  Car.swift
//  VehicleAttributesApp
//
//  Created by Tom Dowding on 15/08/2017.
//  Copyright © 2017 TomDowding. All rights reserved.
//

import Foundation

class Car {
    
    typealias GetDataCompletion = (String) -> ()

    // MARK: - Properties
    
    var vin: String
    var timestamp: String?
    var fuels: [Fuel]
    var emissions: [Emission]
    var regno: String?
    var gearbox: Gearbox?
    var year: Int?
    var brand: String?
    var fuelTypes: (String)?
    
    // MARK: - Initialization
    
    init?(vin: String) {
        
        // The vin must not be empty
        guard !vin.isEmpty else {
            return nil
        }
        
        self.vin = vin
        self.emissions = [Emission]()
        self.fuels = [Fuel]()
    }
    
    // Uses the Car's vin to fetch data from the api and define it's properties
    func GetData(completion: @escaping GetDataCompletion) {
        
        APIHelper.GetData(vin: self.vin) { json, errorMessage in
             
            if let regno = json?["regno"] as? String {
                self.regno = regno
            }
            if let gearboxType = json?["gearbox_type"] as? String {
                self.gearbox = Gearbox(gearboxType: gearboxType)
            }
            if let brand = json?["brand"] as? String {
                self.brand = brand
            }
            if let timestamp = json?["timestamp"] as? String {
                self.timestamp = timestamp
            }
            if let year = json?["year"] as? Int {
                self.year = year
            }
        
            if let fuelsDict = json?["fuel"] as? [String: Any] {
                
                self.fuels = [Fuel]()
                
                for fuelType in fuelsDict {
                    
                    if let fuelDict = fuelType.value as? [String: Any] {
                        
                        // Create a new fuel for the fuels array
                        let fuel = Fuel(fuelType: fuelType.key)
                        self.fuels.append(fuel)
                        
                        if let consumptionDict = fuelDict["average_consumption"] as? [String: Any] {
                            
                            for consumptionDrivingTypeKVP in consumptionDict {
                                
                                let consumption = FuelConsumption(drivingType: consumptionDrivingTypeKVP.key, amount: consumptionDrivingTypeKVP.value as! Float)
                                fuel.consumptions.append(consumption)
                            }
                        }
                    }
                }
            }
            
            if let emissionDict = json?["emission"] as? [String: Any] {
                
                self.emissions = [Emission]()
                
                for emissionFuel in emissionDict {
            
                    if let emissionFuelDict = emissionFuel.value as? [String: Any] {
                       
                        // Create a new emission for the emissions array
                        let emission = Emission(fuelType: emissionFuel.key)
                        self.emissions.append(emission)
                        
                        for emissionSubstance in emissionFuelDict {
                            
                            if let emissionSubstanceDict = emissionSubstance.value as? [String: Any] {
                             
                                for emissionDrivingTypeKVP in emissionSubstanceDict {
                                 
                                    // Add each substance / driving style pair to substances array
                                    let substance = EmissionSubstance(name: emissionSubstance.key, drivingType: emissionDrivingTypeKVP.key, amount: emissionDrivingTypeKVP.value as! Float)
                                    emission.substances.append(substance)
                                }
                            }
                        }
                    }
                }
            }
           
            // Now data is populated, send the closure for completion
            DispatchQueue.main.async {
                completion(errorMessage)
            }
        }
    }
    
    func debugPrint() {
        
        print("Car has regno: \(self.regno ?? "unknown"))")
        print("Car has gearbox of type: \(self.gearbox?.gearboxType ?? GearboxType.Unknown)")
        print("Car has brand: \(self.brand ?? "unknown")")
        print("Car has year: \(self.year ?? 0)")
        print("Car has timestamp: \(self.timestamp ?? "unknown")")
        
        self.debugPrintEmissions()
        self.debugPrintFuels()
    }
    
    func debugPrintEmissions() {
      
        for emission in self.emissions {
            
            print("Car has emissions from fuel type \(emission.fuelType):")
            
            for substance in emission.substances {
                
                print("\tSubstance \(substance.name) has amount \(substance.amount) for driving style \(substance.drivingType)")
            }
        }
    }
    
    func debugPrintFuels() {
        
        for fuel in self.fuels {
            
            print("Car has fuel of type \(fuel.fuelType) with tank volume \(String(describing:fuel.tankVolume))")
            
            for consumption in fuel.consumptions {
                
                print ("\tAverage consumption of \(consumption.amount) for driving style \(consumption.drivingType)")
            }
        }
    }
}
