import UIKit
import DGCharts

class ProfileStatsCell: UITableViewCell {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setPieChartData()
    }
}

extension ProfileStatsCell {
    func setPieChartData() {
        let entries = [
            PieChartDataEntry(value: 20.0, label: "Watching"),
            PieChartDataEntry(value: 30.0, label: "Completed"),
            PieChartDataEntry(value: 10.0, label: "On-Hold"),
            PieChartDataEntry(value: 5.0, label: "Dropped"),
            PieChartDataEntry(value: 35.0, label: "Plan-to-Watch")
        ]
        
        let dataSet = PieChartDataSet(entries: entries, label: "Anime Status")
        dataSet.colors = ChartColorTemplates.colorful()
        dataSet.drawValuesEnabled = false
        
        let data = PieChartData(dataSet: dataSet)
        
        pieChart.data = data
        pieChart.legend.enabled = false
        pieChart.drawEntryLabelsEnabled = false
        pieChart.highlightPerTapEnabled = false
        
        pieChart.animate(xAxisDuration: 1.5, easingOption: .easeOutBack)
        
    }
}
