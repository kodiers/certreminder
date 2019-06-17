//
//  testChooseExamDateVC.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 18/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class testChooseExamDateVC: XCTestCase {
    var storyboard: UIStoryboard!
    var chooseExamDateVC: ChooseExamDateVC!
    var certification: Certification!
    var exam: Exam!
    var date: Date!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        chooseExamDateVC = storyboard.instantiateViewController(withIdentifier: "ChooseExamDateVC") as! ChooseExamDateVC
        certification = Certification(id: id1, title: TEST, vendor: 1)
        exam = Exam(id: id1, title: TEST, certification: certification)
        date = Date()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewLoad() {
        chooseExamDateVC.exam = exam
        chooseExamDateVC.examDate = date
        _ = chooseExamDateVC.view
        XCTAssertEqual(chooseExamDateVC.examTitleLabel.text, exam.title)
        XCTAssertEqual(chooseExamDateVC.datePicker.date, date)
    }
    
    func testPrepareToDetailVC() {
        let userCert = UserCertification(id: id1, certification: certification, expirationDate: date)
        let userExam = UserExam(id: id1, userCertId: userCert.id, exam: exam, dateOfPass: date)
        var mockChoosedDataService: ChoosedDataServiceProtocol = MockChoosedDataService()
        mockChoosedDataService.userExams = [userExam]
        mockChoosedDataService.userCertification = userCert
        let destVC = MockViewController()
        chooseExamDateVC.choosedDataService = mockChoosedDataService
        chooseExamDateVC.prepareToDetailVC(destination: destVC)
        XCTAssertEqual(destVC.userCerification?.id, userCert.id)
        XCTAssertEqual(destVC.usersExams[0].id, userExam.id)
    }
    
}
