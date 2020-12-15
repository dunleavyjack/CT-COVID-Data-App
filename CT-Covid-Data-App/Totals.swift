//
//  Totals.swift
//  CT-Covid-Data-App
//
//  Created by Jack on 12/15/20.
//

import Foundation

struct Totals: Codable {
    var date: String!
    var state: String!
    var covid_19_tests_reported: String!
    var totalcases: String!
    var confirmedcases: String!
    var probablecases: String!
    var hospitalizedcases: String!
    var totaldeaths: String!
    var confirmeddeaths: String!
    var probabledeaths: String!
    var cases_age0_9: String!
    var cases_age10_19: String!
    var cases_age20_29: String!
    var cases_age30_39: String!
    var cases_age40_49: String!
    var cases_age50_59: String!
    var cases_age60_69: String!
    var cases_age70_79: String!
    var cases_age80_older: String!
}
