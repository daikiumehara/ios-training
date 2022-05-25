//
//  WeatherViewControllerTests.swift
//  ExampleTests
//
//  Created by 渡部 陽太 on 2020/04/01.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
import YumemiWeather
@testable import Example

class WeatherViewControllerTests: XCTestCase {
    
    var weahterViewController: WeatherViewController!
    var weahterModel: WeatherModelMock!
    var disasterModel: DisasterModel!
    
    override func setUpWithError() throws {
        weahterModel = WeatherModelMock()
        disasterModel = DisasterModelImpl()
        weahterViewController = R.storyboard.weather.instantiateInitialViewController()!
        weahterViewController.weatherModel = weahterModel
        weahterViewController.disasterModel = disasterModel
        _ = weahterViewController.view
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_天気予報がsunnyだったらImageViewのImageにsunnyが設定されること_TintColorがredに設定されること() throws {
        let exp = XCTestExpectation(description: "\(#function)のデータ取得を待機")
        weahterModel.fetchWeatherImpl = { _ in
            Response(weather: .sunny, maxTemp: 0, minTemp: 0, date: Date())
        }
        self.weahterViewController.loadWeather(nil)
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.weahterViewController.weatherImageView.tintColor, R.color.red())
            XCTAssertEqual(self.weahterViewController.weatherImageView.image, R.image.sunny())
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func test_天気予報がcloudyだったらImageViewのImageにcloudyが設定されること_TintColorがgrayに設定されること() throws {
        let exp = XCTestExpectation(description: "\(#function)のデータ取得を待機")
        weahterModel.fetchWeatherImpl = { _ in
            Response(weather: .cloudy, maxTemp: 0, minTemp: 0, date: Date())
        }
        
        weahterViewController.loadWeather(nil)
        DispatchQueue.main.async {
            XCTAssertEqual(self.weahterViewController.weatherImageView.tintColor, R.color.gray())
            XCTAssertEqual(self.weahterViewController.weatherImageView.image, R.image.cloudy())
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func test_天気予報がrainyだったらImageViewのImageにrainyが設定されること_TintColorがblueに設定されること() throws {
        let exp = XCTestExpectation(description: "\(#function)のデータ取得を待機")
        weahterModel.fetchWeatherImpl = { _ in
            Response(weather: .rainy, maxTemp: 0, minTemp: 0, date: Date())
        }
        
        weahterViewController.loadWeather(nil)
        DispatchQueue.main.async {
            XCTAssertEqual(self.weahterViewController.weatherImageView.tintColor, R.color.blue())
            XCTAssertEqual(self.weahterViewController.weatherImageView.image, R.image.rainy())
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func test_最高気温_最低気温がUILabelに設定されること() throws {
        let exp = XCTestExpectation(description: "\(#function)のデータ取得を待機")
        weahterModel.fetchWeatherImpl = { _ in
            Response(weather: .rainy, maxTemp: 100, minTemp: -100, date: Date())
        }
        
        weahterViewController.loadWeather(nil)
        DispatchQueue.main.async {
            XCTAssertEqual(self.weahterViewController.minTempLabel.text, "-100")
            XCTAssertEqual(self.weahterViewController.maxTempLabel.text, "100")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
}

class WeatherModelMock: WeatherModel {
    let exp = XCTestExpectation(description: "\(#function)のデータ取得を待機")
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<Response, WeatherError>) -> Void) {
        let response = try! fetchWeatherImpl(Request(area: area,
                                                     date: date))
        completion(.success(response))
    }
    var fetchWeatherImpl: ((Request) throws -> Response)!
}
