//
//  ViewController.swift
//  CT-Covid-Data-App
//
//  Created by Jack on 12/9/20.
//

import UIKit

class ViewController: UIViewController {

    // Buttons go here
    
    @IBOutlet weak var percentPositiveLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    @IBOutlet weak var percentChangeTriangle: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newCasesLabel: UILabel!
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var probableLabel: UILabel!
    @IBOutlet weak var testsLabel: UILabel!
    @IBOutlet weak var totalCasesLabel: UILabel!
    
    // Buttons end here
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         
        fetchTotalsData { (totals) in
            let today = totals[0].date!
            let todayReported = totals[0].covid_19_tests_reported!
            let totalCases = totals[0].totalcases!
            let confirmedCases = totals[0].confirmedcases!
            
            DispatchQueue.main.async {
                self.newCasesLabel.text = "1,211"
            }
            
            print("Today's date: " + today)
            print("Cases reported today: " + todayReported)
            print("Total Cases: " + totalCases)
            print("Confirmed Cases: " + confirmedCases)
            
        }
    }
    
    
    func fetchTotalsData(completionHandler: @escaping([Totals]) -> Void){
        let url = URL(string: "https://data.ct.gov/resource/rf3k-f8fg.json")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let totalsData = try JSONDecoder().decode([Totals].self, from: data)
            
                completionHandler(totalsData)
            }
            catch {
                let error = error
                print(error.localizedDescription)
            }
        }.resume()
    }
}
