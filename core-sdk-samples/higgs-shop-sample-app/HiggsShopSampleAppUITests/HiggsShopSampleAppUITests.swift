import XCTest

class HiggsShopSampleAppUITests: XCTestCase {

    let kLaunchTimeout = 60.0
    let kActionTimeout = 10.0
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {

    }
    
    private func makeUIApplication() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment = ["IS_UITEST": "YES"]
        return app
    }

    private func waitForAllElements(elementsArray: [XCUIElement], timeout: TimeInterval) -> Bool {
        var allSuccess = true
        for element in elementsArray {
            let foundElement = element.waitForExistence(timeout: timeout)
            if !foundElement {
                XCTAssert(false)
                allSuccess = false
                break
            }
        }
        return allSuccess
    }
    
    private func navigateToTabBarController(_ app: XCUIApplication) {
        let button = app.buttons["LandingCTA"]
        XCTAssert(button.waitForExistence(timeout: kActionTimeout))
        button.tap()
    }
    
    private func navigateToProductDetailController(_ app: XCUIApplication) {
        navigateToTabBarController(app)
        app.tables["ShopTableView"].cells.element(boundBy: 0).tap()
    }
    
    private func navigateToMyAccountController(_ app: XCUIApplication) {
        navigateToTabBarController(app)
        app.buttons["TabBarItemMyAccount"].tap()
    }

    func testLandingView() throws {
        let app = makeUIApplication()
        app.launch()
        
        let backgroundImageView = app.images["LandingBackgroundImageView"]
        XCTAssert(backgroundImageView.waitForExistence(timeout: kActionTimeout))
        XCTAssert(app.images["HiggsWelcomeLogo"].exists)
        XCTAssert(app.buttons["LandingCTA"].exists)
        XCTAssert(app.staticTexts["WelcomeLabel"].exists)
        XCTAssert(app.staticTexts["DisclaimerLabel"].exists)
    }
    
    func testLandingViewShopButton() throws {
        let app = makeUIApplication()
        app.launch()
        navigateToTabBarController(app)
        
        let tabBar = app.otherElements["TabBarController"]
        XCTAssert(tabBar.waitForExistence(timeout: kActionTimeout))
    }
    
    func testShopView() throws {
        let app = makeUIApplication()
        app.launch()
        navigateToTabBarController(app)
        
        let tableView = app.tables["ShopTableView"]
        XCTAssert(tableView.waitForExistence(timeout: kActionTimeout))
        
        let firstCell = tableView.cells.element(boundBy: 0)
        XCTAssert(firstCell.exists)
        XCTAssert(firstCell.images["ShopCellProductImageView"].exists)
        XCTAssert(firstCell.images["ShopCellRightArrowImageView"].exists)
        XCTAssert(firstCell.staticTexts["ShopCellProductNameLabel"].exists)
    }
    
    func testAddAndRemoveFromCart() throws {
        let app = makeUIApplication()
        app.launch()
        navigateToProductDetailController(app)
        
        // Add item to cart
        let button = app.buttons["DetailCTA"]
        XCTAssert(button.waitForExistence(timeout: kActionTimeout))
        button.tap()
        
        // Check the tab bar icon badge
        let tabBarItem = app.buttons["TabBarItemCart"]
        XCTAssert(tabBarItem.waitForExistence(timeout: kActionTimeout))
        if let badgeValue = tabBarItem.value as? String {
            XCTAssertEqual(badgeValue, "1 item")
        } else {
            XCTFail("tabBarItem.value is not a string")
        }
        
        // Navigate to cart tab
        tabBarItem.tap()
        
        // Check that item exists in cart view
        let tableView = app.tables["CartTableView"]
        XCTAssert(tableView.waitForExistence(timeout: kActionTimeout))
        let firstCell = tableView.cells.element(boundBy: 0)
        XCTAssert(firstCell.exists)
        XCTAssert(firstCell.images["CartCellProductImageView"].exists)
        XCTAssert(firstCell.staticTexts["CartCellProductPriceLabel"].exists)
        XCTAssert(firstCell.staticTexts["CartCellProductNameLabel"].exists)
        XCTAssert(firstCell.staticTexts["CartCellProductDetailLabel"].exists)
        
        // Check the tab bar icon badge again
        if let badgeValue = app.buttons["TabBarItemCart"].value as? String {
            XCTAssertEqual(badgeValue, "1 item")
        } else {
            XCTFail("tabBarItem.value is not a string")
        }
        
        // Remove item from the cart
        firstCell.tap()
        let noItemsLabel = tableView.staticTexts["CartNoItemsLabel"]
        XCTAssert(noItemsLabel.waitForExistence(timeout: kActionTimeout))
        XCTAssertFalse(firstCell.exists)
        XCTAssertEqual(tableView.cells.count, 0)
        
        // Check the tab bar icon badge again
        if let badgeValue = app.buttons["TabBarItemCart"].value as? String {
            XCTAssertEqual(badgeValue, "")
        } else {
            XCTFail("tabBarItem.value is not a string")
        }
    }
    
    func testLoginAndLogout() {
        let app = makeUIApplication()
        app.launch()
        navigateToMyAccountController(app)
        
        let myAccountView = app.otherElements["MyAccountView"]
        XCTAssert(myAccountView.waitForExistence(timeout: kActionTimeout))
        
        // Signed out state
        XCTAssert(myAccountView.staticTexts["MyAccountTitle"].exists)
        XCTAssert(myAccountView.otherElements["MyAccountUserIdDefault"].exists)
        XCTAssert(myAccountView.buttons["MyAccountCTAUnselected"].exists)
        XCTAssert(myAccountView.staticTexts["DetailDemoOnly"].exists)
        XCTAssertFalse(myAccountView.staticTexts["MyAccountYouAreSignedInAs"].exists)
        XCTAssertFalse(myAccountView.staticTexts["MyAccountSignedInUserLabel"].exists)
        XCTAssertFalse(myAccountView.buttons["MyAccountCTASelected"].exists)

        // Sign in
        myAccountView.buttons["MyAccountCTAUnselected"].tap()
        
        // Signed in state
        XCTAssert(myAccountView.staticTexts["MyAccountTitle"].exists)
        XCTAssertFalse(myAccountView.otherElements["MyAccountUserIdDefault"].exists)
        XCTAssertFalse(myAccountView.buttons["MyAccountCTAUnselected"].exists)
        XCTAssert(myAccountView.staticTexts["DetailDemoOnly"].exists)
        XCTAssert(myAccountView.staticTexts["MyAccountYouAreSignedInAs"].exists)
        XCTAssert(myAccountView.staticTexts["MyAccountSignedInUserLabel"].exists)
        XCTAssert(myAccountView.buttons["MyAccountCTASelected"].exists)
        if let signedInUserValue = myAccountView.staticTexts["MyAccountSignedInUserLabel"].value as? String {
            XCTAssertEqual(signedInUserValue, "MyHiggsID")
        } else {
            XCTFail("signedInUserValue.value is not a string")
        }
        
        // Sign out
        myAccountView.buttons["MyAccountCTASelected"].tap()
        
        // Signed out state
        XCTAssert(myAccountView.staticTexts["MyAccountTitle"].exists)
        XCTAssert(myAccountView.otherElements["MyAccountUserIdDefault"].exists)
        XCTAssert(myAccountView.buttons["MyAccountCTAUnselected"].exists)
        XCTAssert(myAccountView.staticTexts["DetailDemoOnly"].exists)
        XCTAssertFalse(myAccountView.staticTexts["MyAccountYouAreSignedInAs"].exists)
        XCTAssertFalse(myAccountView.staticTexts["MyAccountSignedInUserLabel"].exists)
        XCTAssertFalse(myAccountView.buttons["MyAccountCTASelected"].exists)
    }
}
