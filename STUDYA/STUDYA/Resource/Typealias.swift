//
//  Typealias.swift
//  STUDYA
//
//  Created by EHDDOMB on 2022/09/08.
//

import UIKit

typealias AllUsersAttendanceForADay = [Time: [SingleUserAnAttendanceInformation]]
typealias UserID = String //사용자의 아이디
typealias ID = Int // 사용자 id 이외의 id
typealias Title = String
typealias Content = String
typealias Password = String
typealias SNSToken = String
typealias Members = [Member]
typealias DashedDate = String
typealias DottedDate = String
typealias ShortenDottedDate = String
typealias Time = String
typealias Deposit = Int
typealias StudyID = String
typealias AllStudyScheduleOfAllStudy = [StudyID: [StudySchedule]]
typealias TimeRange = (StartTime: String, EndTime: String)
