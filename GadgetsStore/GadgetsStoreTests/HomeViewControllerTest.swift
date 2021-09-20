//
//  HomeViewControllerTest.swift
//  GadgetsStore
//
//  Created by Vulisi Sahithi on 20/09/21.
//

import XCTest
@testable import GadgetsStore

class HomeViewControllerTest: XCTestCase {
    var viewController: HomePageViewController!

    override func setUpWithError() throws {
        viewController = HomePageViewController()
        
    }

    override func tearDownWithError() throws {
        viewController = nil
    }

    func testGetDataFromApi() {
        let exception = XCTestExpectation(description: "Getting Data from API")
        viewController.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            exception.fulfill()
        }
        wait(for: [exception], timeout: 10)
        XCTAssertTrue(viewController.gadgetslistWithHighPrice.first != nil)
        XCTAssertTrue(viewController.gadgetslistWithLowPrice.first != nil)
        XCTAssertTrue(viewController.tableView.numberOfSections == 2)
    }
    
    func testItemsSelected() {
        let gadget = GadgetDetails(name: "IPhone", price: "100000", rating: 4, image_url: "someurl")
        let gadgetinfo = GadgetsInfo(gadget: gadget, isAddedToCart: false, itemStatus: "")
        viewController.gadgetslistWithLowPrice.append(gadgetinfo)
        viewController.itemsSelected(cartData: gadgetinfo, index: IndexPath(item: 0, section: 0))
        XCTAssertTrue(viewController.gadgetslistWithLowPrice.first?.isAddedToCart ?? false, "should be true")
    }

}
