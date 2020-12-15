//
//  ViewController.swift
//  CT-Covid-Data-App
//
//  Created by Jack on 12/9/20.
//

import UIKit

class ViewController: UIViewController {

    // UI Labels
    @IBOutlet weak var percentPositiveLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    @IBOutlet weak var percentChangeTriangle: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newCasesLabel: UILabel!
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var probableLabel: UILabel!
    @IBOutlet weak var testsLabel: UILabel!
    @IBOutlet weak var totalCasesLabel: UILabel!
    
    // UI Buttons
    @IBAction func linkButton(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://portal.ct.gov/Coronavirus" )! as URL, options: [:], completionHandler: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Organize fetched JSON Data
        fetchTotalsData { (json) in
            
            // Get and organize dates
            let today = json[0].date!
            
            // Get and organize date
            let dateYear = today.prefix(4);
            let dateMonth = today.dropFirst(5).prefix(2) as Substring
            let dateDay = today.dropFirst(8).prefix(2) as Substring
            let fixedDateYear = String(dateYear)
            let fixedDateMonth = String(dateMonth)
            let fixedDateDay = String(dateDay)
            let todayDate = fixedDateMonth + "/" + fixedDateDay + "/" + fixedDateYear
            
            // Today's Basic Data
            let confirmedCases = String(Int(json[0].confirmedcases)! - Int(json[1].confirmedcases)!)
            let probableCases = String(Int(json[0].probablecases)! - Int(json[1].probablecases)!)
            let todayTotalCases = json[0].totalcases!
            let todayTotalTests = json[0].covid_19_tests_reported!
            
            // Yesterday's Basic Data
            let yesterdayTotalCases = json[1].totalcases!
            let yesterdayTotalTests = json[1].covid_19_tests_reported!
            
            // Day Before Yesterday's Basic Data
            let beforeYesterdayTotalCases = json[2].totalcases!
            let beforeYesterdayTotalTests = json[2].covid_19_tests_reported!
            
            
            // Today's Calculated New Tests and Cases
            let todaysTests = String(Int(todayTotalTests)! - Int(yesterdayTotalTests)!)
            let newCases = String(Int(todayTotalCases)! - Int(yesterdayTotalCases)!)
            
            // Yesterday's Calculated Tests and Cases
            let yesterdayTests = String(Int(yesterdayTotalTests)! - Int(beforeYesterdayTotalTests)!)
            let yesterdayNewCases = String(Int(yesterdayTotalCases)! - Int(beforeYesterdayTotalCases)!)
            
            // Today and Yesterday's Percent
            let todayPercent = getPercentPositive(increasedTests: todaysTests, increasedCases: newCases)
            let yesterdayPercent = getPercentPositive(increasedTests: yesterdayTests, increasedCases: yesterdayNewCases)

            // Percent Difference Between Today and Yesterday
            let percentChange = getPercentChange(today: todayPercent, yesterday: yesterdayPercent)
            
            // Execute and Pass Data to the UI
            DispatchQueue.main.async {
                // Check for negative percent change
                if percentChange.prefix(1) == "-"{
                    self.percentChangeTriangle.image = #imageLiteral(resourceName: "upsidedown")
                    self.percentChangeLabel.text = String(percentChange.dropFirst(1))
                } else {
                    self.percentChangeTriangle.image = #imageLiteral(resourceName: "Polygon 1")
                    self.percentChangeLabel.text = percentChange
                }
                // UI Labels
                self.percentPositiveLabel.text = todayPercent
                self.dateLabel.text = todayDate
                self.newCasesLabel.text = addCommas(numberString: newCases)
                self.confirmedLabel.text = addCommas(numberString: confirmedCases)
                self.probableLabel.text = addCommas(numberString: probableCases)
                self.testsLabel.text = addCommas(numberString: todaysTests)
                self.totalCasesLabel.text = addCommas(numberString: todayTotalCases)
            }
        }
    }
    
    // Fetch and parse JSON Data
    func fetchTotalsData(completionHandler: @escaping([Totals]) -> Void){
        let url = URL(string: "https://data.ct.gov/resource/rf3k-f8fg.json?$$app_token=oqfaeHTIlak3SguVrHEfqIs4n")!
        // Start URL Session
        URLSession.shared.dataTask(with: url) { (data, response, error) in
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
