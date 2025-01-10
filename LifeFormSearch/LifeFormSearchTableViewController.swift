//
//  LifeFormSearchTableViewController.swift
//  LifeFormSearch
//
//  Created by Skyler Robbins on 12/17/24.
//

import UIKit

class LifeFormSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    let searchController = UISearchController()
    let apiController = APIRequestsController()
    var lifeForms = [LifeForm]()
    var selectedLifeForm: LifeForm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Life Forms..."
        navigationItem.searchController = searchController
        
        tableView.rowHeight = 60
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        Task {
            do {
                lifeForms = try await apiController.fetchLifeForms(matching: query)
                tableView.reloadData()
            }
            catch {
                print(error)
            }
        }
        searchController.isActive = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lifeForms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lifeFormIdentifier", for: indexPath)
        
        let lifeForm = lifeForms[indexPath.row]

        cell.textLabel!.text = lifeForm.commonName
        cell.detailTextLabel!.text = lifeForm.scientificName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLifeForm = lifeForms[indexPath.row]
        performSegue(withIdentifier: "lifeFormDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lifeFormDetailSegue" {
            let nextVC = segue.destination as! LifeFormDetailViewController
            nextVC.lifeForm = selectedLifeForm
        }
    }

}
