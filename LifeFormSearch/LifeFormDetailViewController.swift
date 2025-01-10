//
//  LifeFormDetailViewController.swift
//  LifeFormSearch
//
//  Created by Skyler Robbins on 12/17/24.
//

import UIKit

class LifeFormDetailViewController: UIViewController {

    @IBOutlet weak var lifeFormImage: UIImageView!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var taxonomyLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var kingdomLabel: UILabel!
    @IBOutlet weak var phylumLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var familyLabel: UILabel!
    @IBOutlet weak var genusLabel: UILabel!
    
    var lifeForm: LifeForm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lifeFormImage.image = UIImage(named: "imageNotFound")
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        if let lifeForm = lifeForm {
            navigationItem.title = lifeForm.commonName
            scientificNameLabel.text = "Scientific Name: \(lifeForm.scientificName)"
            print(lifeForm.id)
            APIRequestsController().displayEOLImage(taxonID: String(1045603), imageView: lifeFormImage)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
