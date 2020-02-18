

import XCTest
@testable import CheckWeather

// test behavior of JSONTalker against a _mock_ server
// as I'm fond of saying on Stack Overflow, there's no point testing URLSession's actual networking;
// we _know_ what _that_ does

// proper technique is to subclass URLProtocol:
// boilerplate, see e.g. https://developer.apple.com/videos/play/wwdc2018/417/
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func startLoading() {
        guard let handler = Self.requestHandler else {
            XCTFail("you forgot to set the mock protocol request handler")
            return
        }
        do {
            let (response, data) = try handler(request)
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        } catch {
            self.client?.urlProtocol(self, didFailWithError:error)
        }
    }
    override func stopLoading() {} // not interested
}


class JSONTalkerTests: XCTestCase {
    
    // make a talker, a configuration that uses our mock protocol, and a dummy URL
    let talker = JSONTalker()
    let testConfig : URLSessionConfiguration = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return config
    }()
    let testUrl = URL(string:"https://dummy.com")!
    
    // don't let static values from different tests infect one another
    override func setUp() {
        MockURLProtocol.requestHandler = nil
    }
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
    }
    
    // test JSONTalker makeTheURL
    func testMakeUrl() {
        let url : URL? = talker.makeTheURLTesting(zip:"12345")
        XCTAssertNotNil(url, "url should be valid")
        
        let comps : URLComponents? = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        XCTAssertNotNil(comps, "url should be analysable into components")
        
        XCTAssertNotNil(comps!.scheme, "scheme should be present")
        XCTAssertEqual(comps!.scheme!, "https")
        
        XCTAssertNotNil(comps!.host, "host should be present")
        XCTAssertEqual(comps!.host!, "api.openweathermap.org")
        
        XCTAssertEqual(comps!.path, "/data/2.5/forecast")
        
        let queries = comps!.queryItems
        XCTAssertNotNil(queries, "queries should be present")
        
        let zip = queries!.first {$0.name == "zip"}
        XCTAssertNotNil(zip?.value)
        XCTAssertEqual(zip?.value!, "12345")
        
        let mode = queries!.first {$0.name == "mode"}
        XCTAssertNotNil(mode?.value)
        XCTAssertEqual(mode?.value!, "json")
        
        let appid = queries!.first {$0.name == "appid"}
        XCTAssertNotNil(appid?.value)
        // no point testing what it is
    }
    
    // utility
    func setRequestHandler(data:Data) {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion:nil, headerFields:nil)!
            return (response, data)
        }
    }
    
    // test JSONTalker talkToTheServer
    // good JSON should return good result (a Forecast)
    func testGoodJson() {
        let forecast = CheckWeather.samplejson
        let data = forecast.data(using: .utf8)!
        self.setRequestHandler(data:data)
        
        let expect = XCTestExpectation(description:"testing talker")
        self.talker.talkToTheServerTesting(url:self.testUrl, config:self.testConfig, save:false) {
            (result:JSONTalker.MyResult) in
            do {
                XCTAssertNoThrow(try result.get(), "good json, should succeed")
                _ = try result.get() // shut the compiler up
                // I suppose we could proceed to examine the resulting Forecast...
                // ...but this seems pointless, as we know how it is constructed
                // see also the forecast tests
            } catch {
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }

    // suppose data comes back empty, should throw 4864
    func testEmptyData() {
        self.setRequestHandler(data:Data())
        let expect = XCTestExpectation(description:"testing talker")
        self.talker.talkToTheServerTesting(url:self.testUrl, config:self.testConfig, save:false) {
            (result:JSONTalker.MyResult) in
            do {
                XCTAssertThrowsError(try result.get(), "empty data, should throw")
                _ = try result.get()
            } catch {
                let err = error as NSError
                XCTAssertEqual(err.code, 4864)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }
    
    // suppose data is missing something important like city, should throw 4865
    func testBadJson() {
        var forecast = CheckWeather.samplejson
        forecast = forecast.replacingOccurrences(of: #""city""#, with: #""cityy""#) // oops, no city
        let data = forecast.data(using: .utf8)!
        self.setRequestHandler(data:data)
        
        let expect = XCTestExpectation(description:"testing talker")
        self.talker.talkToTheServerTesting(url:self.testUrl, config:self.testConfig, save:false) {
            (result:JSONTalker.MyResult) in
            do {
                XCTAssertThrowsError(try result.get(), "bad data, should throw")
                _ = try result.get()
            } catch {
                let err = error as NSError
                XCTAssertEqual(err.code, 4865)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }
    
    // suppose an error is thrown at the top of the stack
    func testNetworkThrows() {
        MockURLProtocol.requestHandler = { request in
            throw MyLocalizedError.oops("zing!")
        }
        
        let expect = XCTestExpectation(description:"testing talker")
        self.talker.talkToTheServerTesting(url:self.testUrl, config:self.testConfig, save:false) {
            (result:JSONTalker.MyResult) in
            do {
                XCTAssertThrowsError(try result.get(), "talker threw, we should throw")
                _ = try result.get()
            } catch MyLocalizedError.oops(let message) {
                XCTAssertEqual(message, "zing!")
            } catch {
                XCTFail("should not get here, error should have been MyLocalizedError.oops")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }
    
    // we've tested the core functionality already, this is merely the public top of the stack
    // we only need one test for this and only for the sake of code coverage
    func testFetchJson() {
        let forecast = CheckWeather.samplejson
        let data = forecast.data(using: .utf8)!
        self.setRequestHandler(data: data)
        
        let expect = XCTestExpectation(description:"testing talker")
        self.talker.fetchJSON(zip: "12345", config:self.testConfig) {
            (result:JSONTalker.MyResult) in
            do {
                XCTAssertNoThrow(_ = try result.get(), "should be a valid forecast")
                _ = try result.get() // shut the compiler up
            } catch {
                XCTFail("should not get here, we should have gotten a valid forecast")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }
    
    // there is no harm in actually testing the server once just to make sure it's still working
    func testServer() {
        let expect = XCTestExpectation(description:"testing server")
        self.talker.fetchJSON(zip:"93023") {
            (result:JSONTalker.MyResult) in
            do {
                let forecast = try result.get()
                XCTAssertEqual(forecast.city.name, "Ojai")
            } catch {
                XCTFail("server is broken?")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }
}
