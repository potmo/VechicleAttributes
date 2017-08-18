//
//  EmissionTableViewCell.swift
//  VehicleAttributes
//
//  Created by Tom Dowding on 17/08/2017.
//
//

import UIKit

class EmissionTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet weak var describingLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    // MARK: - Functions
    
    func setupForEmission(substance: EmissionSubstance) {
        
        describingLabel.text = "\(substance.name), \(EmissionSubstance.getReadableType(drivingType: substance.drivingType).lowercased())"
   
        let milesString = "\(String(format: "%.3f", substance.amount * metersPerMile)) \(NSLocalizedString("emission_unit_imperial", comment: "to indicate unit of emission"))"
        amountLabel.text = "\(milesString)"
    }
}
