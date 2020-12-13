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
        
        fetchTotalsData { (json) in
            
            
            // Get and organize dates
            let today = json[0].date!
            // Get month, day, and year
            let dateYear = today.prefix(4);
            let dateMonth = today.dropFirst(5).prefix(2) as Substring
            let dateDay = today.dropFirst(8).prefix(2) as Substring
            let fixedDateYear = String(dateYear)
            let fixedDateMonth = String(dateMonth)
            let fixedDateDay = String(dateDay)
            
            
            let todayDate = fixedDateMonth + "/" + fixedDateDay + "/" + fixedDateYear
            
            let confirmedCases = String(Int(json[0].confirmedcases)! - Int(json[1].confirmedcases)!)
            let probableCases = String(Int(json[0].probablecases)! - Int(json[1].probablecases)!)
            
//            let todayReported = json[0].covid_19_tests_reported!
            let todayTotalCases = json[0].totalcases!
            let todayTotalTests = json[0].covid_19_tests_reported!
            
            // Yesterday
//            let yesterday = json[1].date!
//            let yesterdayReported = json[1].covid_19_tests_reported!
            let yesterdayTotalCases = json[1].totalcases!
            let yesterdayTotalTests = json[1].covid_19_tests_reported!
            
            //Day Before Yesterday
//            let beforeYesterday = json[2].date!
//            let beforeYesterdayReported = json[2].covid_19_tests_reported!
            let beforeYesterdayTotalCases = json[2].totalcases!
            let beforeYesterdayTotalTests = json[2].covid_19_tests_reported!
            
            // today Tests and yesterday total cases
            let todaysTests = String(Int(todayTotalTests)! - Int(yesterdayTotalTests)!)
            let newCases = String(Int(todayTotalCases)! - Int(yesterdayTotalCases)!)
            
            let yesterdayTests = String(Int(yesterdayTotalTests)! - Int(beforeYesterdayTotalTests)!)
            let yesterdayNewCases = String(Int(yesterdayTotalCases)! - Int(beforeYesterdayTotalCases)!)
            
        
            //begining of hard things
            let todayPercent = getPercentPositive(increasedTests: todaysTests, increasedCases: newCases)
            let yesterdayPercent = getPercentPositive(increasedTests: yesterdayTests, increasedCases: yesterdayNewCases)
            print(todayPercent)
            print(yesterdayPercent)
            
            
            //Percent Difference always error
            let percentChange = getPercentChange(today: todayPercent, yesterday: yesterdayPercent)
            
            
            
//            let percentChangeFixed = formatPercentChange(percent: percentChange)
            
            
            DispatchQueue.main.async {
                if percentChange.prefix(1) == "-"{
                    self.percentChangeTriangle.image = #imageLiteral(resourceName: "upsidedown")
                    self.percentChangeLabel.text = String(percentChange.dropFirst(1))
                } else {
                    self.percentChangeTriangle.image = #imageLiteral(resourceName: "Polygon 1")
                    self.percentChangeLabel.text = percentChange
                }
                
                self.percentPositiveLabel.text = todayPercent
                self.dateLabel.text = todayDate
                self.newCasesLabel.text = newCases
                self.confirmedLabel.text = confirmedCases
                self.probableLabel.text = probableCases
                self.testsLabel.text = todaysTests
                self.totalCasesLabel.text = todayTotalCases
            }
//
//            print("############# Today ##################")
//            print("Today's date: " + today)
//            print("Cases reported today: " + todayReported)
//            print("Total Cases: " + todayTotalCases)
//            print("Year is " + fixedDateYear)
//            print("Month is " + fixedDateMonth)
//            print("Day is " + fixedDateDay)
//            print(fixedDateMonth + "/" + fixedDateDay + "/" + fixedDateYear)
//            print(todayPercent)
//
//            print("############# Changes ##################")
//            print(newCases)
//
//            print("########### Yesterday  ###############")
//            print("Yesterday's date: " + yesterday)
//            print("Cases reported yesterday: " + yesterdayReported)
//            print("Total Cases: " + yesterdayTotalCases)
//
//            print("########### Day Before Yesterday  ###############")
//            print("Day before yesterday's date: " + beforeYesterday)
//            print("Cases reported the day before yesterday: " + beforeYesterdayReported)
//            print("Total Cases: " + beforeYesterdayTotalCases)
//
            
        }
    }
    
    
    func fetchTotalsData(completionHandler: @escaping([Totals]) -> Void){
        let url = URL(string: "https://data.ct.gov/resource/rf3k-f8fg.json")!
        
        // At the begining of the next line there used to be "task =" before the URLSession call but it showed an error so I removed it and things are still working
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
