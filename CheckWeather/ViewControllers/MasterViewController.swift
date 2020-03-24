

import UIKit
import Combine

final class MasterViewController: UIViewController {
    
    private let jsonTalker = JSONTalker()
    
    // this is the actual data that arrives from the server query
    private var forecast : Forecast? {
        didSet {
            // whenever we get a new forecast repopulate the interface
            self.updateInterface()
        }
    }
    
    // this is the key piece of info because it is what we'll use to perform the server request
    // TODO: harden the coordination between the zip default and the data default
    
    // COOL FEATURE: property wrapper gives automatic interface to user defaults
    @Default(key:DefaultKeys.zip, defaultValue:"")
    private var currentZip {
        didSet {
            self.doFetchForecast(self)
        }
    }

    // "header"
    @IBOutlet private weak var predictionDateLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    
    @IBOutlet private weak var tableView: UITableView!
    
    // COOL FEATURE: diffable data source for our table view
    lazy var datasource = MasterViewTableDataSource(tableView: self.tableView)
    
    var storage = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // repoint table view delegate at data source
        // also cause lazy diffable data source to spring to life
        self.tableView.delegate = self.datasource
        
        // configure refresh control
        let ref = UIRefreshControl()
        ref.sizeToFit()
        ref.addTarget(self, action: #selector(doFetchForecast), for: .valueChanged)
        self.tableView.refreshControl = ref
        
        // COOL FEATURE: new in iOS 13, let's use Combine framework!
        // set up pipeline for receiving change of zip via notification
        NotificationCenter.default.publisher(for: ZipEntryCoordinator.zipCodeDidChange)
            .compactMap { $0.userInfo?["zip"] as? String }
            .assign(to: \.currentZip, on: self)
            .store(in:&storage)
        
        // try to get data from defaults
        do {
            guard let data = UserDefaults.standard.data(forKey: DefaultKeys.json) else {
                print("no data in user defaults")
                enum Dummy : Error { case dummy }
                throw Dummy.dummy // dummy, just get us out of here
            }
            let response = try self.jsonTalker.decodeResponse(fromData: data)
            print("found data in user defaults, using")
            self.forecast = response
        } catch {
            // well, that didn't work
            // do we have a prior zip code? if so, go fetch
            if !self.currentZip.isEmpty {
                self.doFetchForecast(self)
            } else {
                // no data, no zip code, this is a dead cold start
                // offer user a chance to enter the zip code
                delay(1) {
                    self.performSegue(withIdentifier: "ZipEntry", sender: self)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.selectRow(at: nil, animated: false, scrollPosition: .none)
    }
    
    // MARK: - networking and interface updating

    var fetching = false // crude barrier, don't fetch while fetching
    @IBAction private func doFetchForecast(_ sender: Any) {
        if self.fetching { return }
        self.fetching = true
        guard self.currentZip.count == 5 else {
            self.fetching = false
            self.tableView.refreshControl?.endRefreshing() // in case user pulled down table view
            return
        }
        // we can be called two ways: manually or thru refresh control
        // if manually, _show_ the refresh control to give user feedback
        if sender is MasterViewController {
            if let refresh = self.tableView.refreshControl {
                refresh.sizeToFit()
                self.tableView.setContentOffset(CGPoint(x:0, y:-refresh.bounds.height), animated:true)
                refresh.beginRefreshing()
            }
        }
        print("fetching data from server")
        self.jsonTalker.fetchJSON(zip:self.currentZip) { result in
            DispatchQueue.main.async {
                self.fetching = false
                // delays make for nicer user experience
                delay(0.3) {
                    // COOL FEATURE: interrogating Result
                    // this is what I love about Result! we just call `get`...
                    // and we either get data or throw
                    do {
                        let response = try result.get()
                        print("success!")
                        self.tableView.refreshControl?.endRefreshing()
                        delay(0.3) {
                            self.forecast = response // and that will trigger interface update
                        }
                    } catch {
                        // something went wrong, crude alert
                        // TODO: Could greatly improve analysis / presentation of error
                        let err = error as NSError
                        print(error)
                        let desc = err.localizedDescription
                        let alert = UIAlertController(title: "Sorry", message: desc, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default) { _ in
                            delay(0.1) {
                                self.tableView.refreshControl?.endRefreshing()
                                self.tableView.setContentOffset(.zero, animated:true)
                            }
                        }
                        alert.addAction(ok)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    // bottleneck for entire interface, triggered by self.forecast setter observer
    private func updateInterface() {
        guard let forecast = forecast else { return }

        // display header
        self.cityLabel.text = forecast.city.name
        // TODO: This is not giving me the desired abbreviation, not easy to do it turns out
        let tzname = forecast.city.timezoneStruct?.localizedName(for: .generic, locale: Locale.current)
        self.predictionDateLabel.text = "Times are " + (tzname ?? "local to destination")
        
        // repopulate table data source
        self.datasource.populate(from: forecast)
        // display table
        self.tableView.reloadData()
    }
    
    // MARK: - segues
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "Detail":
            // user has asked to navigate to detail
            // make sure we have data and we know what row was selected
            // the chances of there being an issue are probably zero but let's not gamble
            guard self.forecast != nil else { return false }
            guard self.tableView.indexPathForSelectedRow != nil else { return false }
            return true
        case "ZipEntry":
            return true
        default: return false
        }
    }
    
    // COOL FEATURE: new in iOS 13,
    // we can call a custom initializer as we create the destination view controller of a segue!
    // this is _way_ better than having to call `prepare(forSegue:)`
    @IBSegueAction private func instantiateDetailViewController(_ coder: NSCoder) -> UIViewController? {
        guard let forecast = self.forecast else { return nil }
        guard let ip = self.tableView.indexPathForSelectedRow else { return nil }
        let snap = self.datasource.snapshot()
        let section = snap.sectionIdentifiers[ip.section]
        let prediction = snap.itemIdentifiers(inSection: section)[ip.row]
        return DetailViewController(
            prediction: prediction,
            city: forecast.city,
            formatters: forecast.formatters,
            coder: coder)
    }
}
