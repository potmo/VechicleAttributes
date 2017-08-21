//
//  VehicleAttributesViewController.swift
//  VehicleAttributes
//
//  Created by Tom Dowding on 15/08/2017.
//
//

import UIKit

class VehicleAttributesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var generalBox: UIView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var regNoLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var gearboxLabel: UILabel!
    
    @IBOutlet weak var fuelBox: UIView!
    @IBOutlet weak var fuelBoxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fuelsTableView: UITableView!
    @IBOutlet weak var fuelsTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emissionsBox: UIView!
    @IBOutlet weak var emissionsBoxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emissionsTableView: UITableView!
    @IBOutlet weak var emissionsTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var loadingBkrdView: UIView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    let car = Car(vin: "123")!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Default to non-loading state
        self.hideLoading()
        
        // Refresh UI with latest data
        self.refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        self.setupScrollView()
    }
    
    // MARK: - Functions
    
    func presentPopupAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("ok_button", comment: "Text for an ok button"), style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    func refreshData() {
        
        self.showLoading()
        
        car.GetData() { errorMessage in
            
            self.hideLoading()
            
            if !errorMessage.isEmpty {
                
                self.presentPopupAlert(title: NSLocalizedString("car_data_request_error_title", comment: "Title for the error alert when getting car data failed"), message: errorMessage)
            }
            
            self.updateCarAttributes();
        }
    }
    
    func showLoading() {
        self.loadingBkrdView.isHidden = false
        self.loadingSpinner.startAnimating()
    }
    
    func hideLoading() {
        self.loadingBkrdView.isHidden = true
        self.loadingSpinner.stopAnimating()
    }
    
    func updateCarAttributes() {
        
        let unknownTextColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        let knownTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        
        // General attributes
        if let brand = self.car.brand {
            self.brandLabel.text = brand.uppercased()
            self.brandLabel.textColor = knownTextColor
        }
        else {
            self.brandLabel.text = NSLocalizedString("unknown_attribute", comment: "displaying unknown attribute").uppercased()
            self.brandLabel.textColor = unknownTextColor
        }
        
        if let regNo = self.car.regno {
            self.regNoLabel.text = regNo.uppercased()
            self.regNoLabel.textColor = knownTextColor
        }
        else {
            self.regNoLabel.text = NSLocalizedString("unknown_attribute", comment: "displaying unknown attribute").uppercased()
            self.regNoLabel.textColor = unknownTextColor
        }
        
        if let gearbox = self.car.gearbox {
            self.gearboxLabel.text = Gearbox.getReadableType(gearboxType: gearbox.gearboxType).uppercased()
            self.gearboxLabel.textColor = knownTextColor
        }
        else {
            self.gearboxLabel.text = NSLocalizedString("unknown_attribute", comment: "displaying unknown attribute").uppercased()
            self.gearboxLabel.textColor = unknownTextColor
        }
        
        if let year = self.car.year {
            self.yearLabel.text = String(format:"%d", year)
            self.yearLabel.textColor = knownTextColor
        }
        else {
            self.yearLabel.text = NSLocalizedString("unknown_attribute", comment: "displaying unknown attribute").uppercased()
            self.yearLabel.textColor = unknownTextColor
        }
        
        self.generalBox.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5)
     
        
        // Fuels
        self.fuelsTableView.reloadData()
        self.fuelsTableHeightConstraint.constant = self.fuelsTableView.contentSize.height
        self.fuelBoxHeightConstraint.constant = self.fuelsTableView.frame.origin.y + self.fuelsTableView.contentSize.height + 5
       
        self.fuelBox.layoutIfNeeded()
        self.fuelBox.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5)
        self.fuelsTableView.layoutIfNeeded()
        
        // Emissions
        self.emissionsTableView.reloadData()
        self.emissionsTableHeightConstraint.constant = self.emissionsTableView.contentSize.height
        self.emissionsBoxHeightConstraint.constant = self.emissionsTableView.frame.origin.y + self.emissionsTableView.contentSize.height + 5
        self.emissionsBox.layoutIfNeeded()
        self.emissionsBox.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5)
        self.emissionsTableView.layoutIfNeeded()
        
        
        // Timestamp
        if let timestamp = self.car.timestamp {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: timestamp) {
                dateFormatter.dateFormat = "MM/dd/yy HH:mm"
                self.timestampLabel.text = "\(NSLocalizedString("last_updated_on", comment:"")) \(dateFormatter.string(from: date))"
            }
        }
        else {
            self.timestampLabel.text = ""
        }
        
        // Scroll view
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.setupScrollView()
        })
    }
    
  
    func setupScrollView() {
  
        let offset = (self.timestampLabel.frame.origin.y + self.timestampLabel.frame.size.height) - self.scrollView.frame.size.height
        let scrollBottomPadding: CGFloat = 15
        self.scrollContentHeightConstraint.constant = offset + scrollBottomPadding
    }
        
    // MARK: - UITableViewDatasource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.fuelsTableView {
            guard section < self.car.fuels.count else {
                return 0
            }
         
            return self.car.fuels[section].consumptions.count
        }
        else {
            guard section < self.car.emissions.count else {
                return 0
            }
            
            return self.car.emissions[section].substances.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == self.fuelsTableView {
            return self.car.fuels.count
        }
        else {
            return self.car.emissions.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView == self.fuelsTableView {
            guard section < self.car.fuels.count else {
                return ""
            }
            return Fuel.getReadableFuelType(fuelType: self.car.fuels[section].fuelType)
        }
        else {
            guard section < self.car.emissions.count else {
                return ""
            }
            return Fuel.getReadableFuelType(fuelType: self.car.emissions[section].fuelType)
        }
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.fuelsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FuelConsumptionCell", for: indexPath) as! FuelConsumptionTableViewCell
            
            guard indexPath.section < self.car.fuels.count else {
                return cell
            }
            guard indexPath.row < self.car.fuels[indexPath.section].consumptions.count else {
                return cell
            }
            
            cell.setupForConsumption(consumption: self.car.fuels[indexPath.section].consumptions[indexPath.row])
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmissionCell", for: indexPath) as! EmissionTableViewCell
            
            guard indexPath.section < self.car.emissions.count else {
                return cell
            }
            guard indexPath.row < self.car.emissions[indexPath.section].substances.count else {
                return cell
            }
            
            cell.setupForEmission(substance: self.car.emissions[indexPath.section].substances[indexPath.row])
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    // MARK: - IBActions
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        self.refreshData()
    }
}

