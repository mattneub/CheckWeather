

import Foundation

// network communication

// COOL FEATURE: use Result enum (introduced in Swift 5)
// my philosophy for asynchronous stuff is:
// * use completion handler
// * use Result enum as parameter of completion handler
// the reason this is brilliant is that we can extend asynchronousness as long as we like
// passing the completion handler from method to method
// provided we _eventually_ call the completion handler no matter what;
// when the caller is called back with the completion handler,
// either it contains data or it contains an error object and the caller can proceed as desired

// error object that we can customize with localized description suitable for display to user
enum MyLocalizedError : LocalizedError {
    case oops(String)
    var errorDescription: String? {
        if case let .oops(desc) = self {
            return desc
        }
        return nil
    }
}

// all the communication business logic is here
final class JSONTalker {
    typealias MyResult = Result<Forecast, Error>
    typealias MyCompletion = (MyResult) -> Void
    
    func fetchJSON(zip:String, config:URLSessionConfiguration = .ephemeral, completionHandler: @escaping MyCompletion) {
        guard let url = self.makeTheURL(zip: zip) else {
            // this shouldn't happen but it's a nice demonstration
            // besides, in real life we might be forming the URL dynamically
            completionHandler(MyResult.failure(MyLocalizedError.oops("Got a bad URL")))
            return
        }
        self.talkToTheServer(url:url, config:config, completionHandler: completionHandler)
    }
    
    // private with a public door for testing
    #if TESTING
    func makeTheURLTesting(zip:String = "08540") -> URL? {
        return self.makeTheURL(zip:zip)
    }
    #endif
    private func makeTheURL(zip:String = "08540") -> URL? {
        // api.openweathermap.org/data/2.5/forecast?zip=93023&appid=...
        // how to construct a URL, the _right_ way
        // never never never call URL(string:)...!
        let appid = "ffbc284a4912fb5804c20b1894524a58"
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "api.openweathermap.org"
        comp.path = "/data/2.5/forecast"
        let items : [URLQueryItem] = [
            URLQueryItem(name: "zip", value: zip),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "appid", value: appid),
        ]
        comp.queryItems = items
        // return nil // uncomment to test, pretend we failed
        return comp.url
    }
    
    // turn JSON data into a Forecast object
    // note use of `throws`! if there's an error, we automatically propagate it to our caller...
    // ... who will call the completion handler in good order
    // public because view controller might have some saved data that needs display
    func decodeResponse(fromData data:Data) throws -> Forecast {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try decoder.decode(Forecast.self, from: data)
    }
    
    // this is the heart of the matter
    // all paths must call the completion handler!
    // private with a public door for testing
    #if TESTING
    func talkToTheServerTesting(url:URL, config:URLSessionConfiguration = .ephemeral,
                                save:Bool=false, completionHandler: @escaping MyCompletion) {
        self.talkToTheServer(url:url, config:config, save:save, completionHandler: completionHandler)
    }
    #endif
    private func talkToTheServer(url:URL, config:URLSessionConfiguration,
                                 save:Bool=true, completionHandler: @escaping MyCompletion) {
        
        // TESTING defaults key can be injected by the scheme as a signal
        // so we don't thrash the server during development
        // use a constant of sample data instead
        // to use, Edit Scheme > Run > Arguments, check the TESTING checkbox
        // note that this is not the same as TESTING as in unit testing
        // this is a way of building and running during development
        let testing = UserDefaults.standard.bool(forKey: "TESTING")
        if testing {
            print("using cached data")
            let data = samplejson.data(using:.utf8)!
            let response = try! self.decodeResponse(fromData:data)
            completionHandler(MyResult.success(response))
            return
        }
        
        // real networking code
        let sess = URLSession(configuration: config)
        let task = sess.dataTask(with: url) { data, response, err in
            // did we get an error? if so, pass it along
            if let err = err {
                completionHandler(MyResult.failure(err))
                return
            }
            // do we have data? if so, try to decode it
            if let data = data {
                do {
                    let result = try self.decodeResponse(fromData:data)
                    if save {
                        // got successful decode, save raw data directly into defaults
                        UserDefaults.standard.set(data, forKey: DefaultKeys.json)
                    }
                    completionHandler(MyResult.success(result))
                } catch {
                    completionHandler(MyResult.failure(error))
                }
                return
            }
            // shouldn't happen but let's cover all the bases
            completionHandler(MyResult.failure(MyLocalizedError.oops("An unknown networking error occurred")))
        }
        task.resume()
    }
}
