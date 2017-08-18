//
//  FuelConsumptionTableViewCell.swift
//  VehicleAttributes
//
//  Created by Tom Dowding on 17/08/2017.
//
//

import UIKit

class FuelConsumptionTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var describingLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
  
    // MARK: - Functions
    
    func setupForConsumption(consumption: FuelConsumption) {
        
        describingLabel.text = "\(NSLocalizedString("average_consumption", comment:"For description in consumption cell")), \(FuelConsumption.getReadableType(drivingType: consumption.drivingType).lowercased())"
        
        let milesString = "\(String(format: "%.3f", consumption.amount * metersPerMile)) \(NSLocalizedString("consumption_unit_imperial", comment: "to indicate unit of fuel consumption"))"
        amountLabel.text = "\(milesString)"
    }
}
