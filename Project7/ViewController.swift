//
//  ViewController.swift
//  Project7
//
//  Created by TwoStraws on 15/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    //tried enums
    var navBarType: NavBarType = .showCredit
    
    @objc enum NavBarType : Int  {
      case  showCredit
      case  filterPetitions
    }

	override func viewDidLoad() {
		super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCreditBar))
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showFilterBar))
        
  
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }

        showError()
	}
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
          filteredPetitions = jsonPetitions.results
            tableView.reloadData()
        }
    }

    
    func creditAction(action: UIAlertAction! = nil) {}
    
    func submit (_ answer: String) {
      filteredPetitions = petitions
      filteredPetitions = petitions.filter { petition in
          return petition.title.contains(answer)
                }
        tableView.reloadData()
      
    }
    
    
    @objc func showFilterBar(){
        let message = "Filter Petition"
        let title = "Enter Search"
        let ac = UIAlertController(title:title, message:  message, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    
    
    
    @objc func showCreditBar( ) {
            let message = "This data comes from the We The People API of the Whitehouse"
            let title = "Credit"
           
            let ac = UIAlertController(title:title, message:  message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Got it", style: .default, handler: creditAction))
            present(ac, animated: true)
        
    }
    

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return   filteredPetitions.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		let petition =   filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = DetailViewController()
		vc.detailItem =   filteredPetitions[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
	}

	func showError() {
		let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
}

