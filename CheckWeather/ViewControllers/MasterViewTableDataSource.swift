
import UIKit

final class PredictionCell : UITableViewCell {
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var tempLabel : UILabel!
    @IBOutlet var humidityLabel : UILabel!
    @IBOutlet var weatherLabel : UILabel!
    @IBOutlet var weatherImageView : UIImageView!
}

// COOL FEATURE: new in iOS 13, diffable data source!
// all code for configuration and population of table view is moved out of the view controller

class MasterViewTableDataSource: UITableViewDiffableDataSource<Date,Prediction>, UITableViewDelegate {
    var forecast:Forecast? // needed by CellProvider closure in `init`
    let headerID = "header"
    init(tableView:UITableView) {
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: self.headerID)
        tableView.estimatedSectionHeaderHeight = 30
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        // wish I could take credit for _this_ little trick, but no, alas
        // see https://stackoverflow.com/a/60252772/341994
        weak var selff : MasterViewTableDataSource?
        super.init(tableView: tableView) { tableView, indexPath, prediction in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PredictionCell
            let weather = prediction.weather
            cell.weatherImageView.image = weather?.image
            let datestring = selff?.forecast?.formatters.dateTimeFormatter.string(from:prediction.date) ?? " "
            cell.dateLabel.text = datestring
            cell.weatherLabel.text = weather?.secondaryDescription
            cell.tempLabel.text = prediction.tempFormatted
            cell.humidityLabel.text = prediction.humidityFormatted
            return cell
        }
        selff = self
    }
    func populate(from forecast: Forecast) {
        self.forecast = forecast // so CellProvider closure can get at it
        var snap = NSDiffableDataSourceSnapshot<Date,Prediction>()
        let d = Dictionary(grouping: forecast.predictions) { forecast.startOfDay(for: $0) }
        for (date,predictions) in d.sorted(by: { $0.key < $1.key }) {
            snap.appendSections([date])
            snap.appendItems(predictions)
        }
        self.apply(snap, animatingDifferences: false)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let snap = self.snapshot()
        let date = snap.sectionIdentifiers[section]
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerID)!
        var label = view.viewWithTag(99) as? UILabel
        if label == nil {
            let lab = UILabel()
            view.contentView.addSubview(lab)
            lab.tag = 99
            lab.translatesAutoresizingMaskIntoConstraints = false
            lab.font = UIFont(name: "GillSans-Bold", size: 20)!
            lab.topAnchor.constraint(equalTo: view.contentView.topAnchor).isActive = true
            lab.bottomAnchor.constraint(equalTo: view.contentView.bottomAnchor, constant:-2).isActive = true
            lab.leadingAnchor.constraint(equalTo: view.contentView.leadingAnchor, constant:15).isActive = true
            lab.trailingAnchor.constraint(equalTo: view.contentView.trailingAnchor).isActive = true
            label = lab
        }
        label?.text = forecast?.formatters.wordyDateFormatter.string(from: date)
        let background = UIView()
        background.backgroundColor = .systemGray3
        view.backgroundView = background
        return view
    }
}
