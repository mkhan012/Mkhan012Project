//
//This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries


import UIKit

class StringPickerAlertViewController: UIViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    
    // MARK: - Public Variables
    public typealias Selection = ([JMGeneralModel]) -> Swift.Void
    public typealias GetExternalText = (String) -> Swift.Void
    static let identifier = String(describing: StringPickerAlertViewController.self)
    static let cellIdentifier = String(describing: StringPickerAlertViewController.self)
    var stringData: [JMGeneralModel] = []
    var selectedStrings: [JMGeneralModel] = []
    var selection: Selection?
    var externalText: GetExternalText?
    public var editText:String = ""
    public var selectionType: Picker.Selection = .single
    public var sectionIndexEnable:Bool = false
    public var maximumSelectionLimit: Int = Int.max
    
    
    // MARK: - Fileprivate Variables
    private var safeHeight: CGFloat!
    private var keyboardHeight: CGFloat = 0.0
    fileprivate let noDataMessage = "No results found"
    fileprivate let collation = UILocalizedIndexedCollation.current()
    fileprivate var filteredData: [JMGeneralModel] = [] { didSet { showHideNoDataFoundLabel() } }
    fileprivate var sectionTitles : [String] = []
    fileprivate var sectionIndexFilteredData:[[JMGeneralModel]] = []
    fileprivate var scrollToFirstSelectedItem:Bool = true
    fileprivate var scrollToSelectedItem: ((_ indexPath: IndexPath) -> Void)?
    
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let safeAreas = UIApplication.key_Window?.safeAreaInsets ?? UIEdgeInsets.zero
        let actionButtonHeight: CGFloat = 57.0
        let secondaryActionButtonHeight: CGFloat = self.selectionType == .multi || self.selectionType == .visitReason ? 65.0:0.0
        self.safeHeight = self.view.height - (safeAreas.top + safeAreas.bottom + actionButtonHeight + secondaryActionButtonHeight + 55.0)
        
        self.filteredData = self.stringData
        
        if self.sectionIndexEnable {
            self.setupIndexTableView(stringData: self.filteredData)
        }
        
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        self.setContentHeight()
    }
    
    deinit {}
    
    func keyboardVisibleHeightWillChange(newHeight: CGFloat) {
        
        self.keyboardHeight = newHeight
        
        self.preferredContentSize.height = max(min((self.tblList.contentSize.height + self.searchbar.height), (self.safeHeight-self.keyboardHeight)), 200.0)
    }
    
    
    // MARK: - Private Methods
    fileprivate func setupTableView() {
        
        self.tblList.rowHeight = UITableView.automaticDimension
        self.tblList.estimatedRowHeight = 44.0
        self.tblList.tableFooterView = UIView()
        self.tblList.sectionIndexColor = R.ThemeColor.selectedColor
        
        if self.selectionType == .visitReason && self.editText.count > 0 {
            self.searchbar.text = self.editText
//            self.searchbar.becomeFirstResponder()
        }
        
        self.setContentHeight()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { self.scrollToSelectedData() }
    }
    
    fileprivate func showHideNoDataFoundLabel() {
        
        if (self.searchbar.text ?? "").count > 0 {
            
            self.lblNoDataFound.isHidden = self.filteredData.count > 0
            self.lblNoDataFound.text = JMControls.JMPickerViewNoDataMessage
            
        } else {
            
            self.lblNoDataFound.isHidden = self.stringData.count > 0
            self.lblNoDataFound.text = self.noDataMessage
        }
    }
    
    fileprivate func scrollToSelectedData() {
        
        if let data = self.selectedStrings.first {
        
            if self.sectionIndexEnable {
                
                for i in 0..<self.sectionIndexFilteredData.count  {
                    
                    if let index = self.sectionIndexFilteredData[i].firstIndex(where: {$0.id == data.id}) {
                        self.tblList.scrollToRow(at: IndexPath(row: index, section: i), at: .middle, animated: false)
                        break
                    }
                }
            } else {
                
                if let index = self.filteredData.firstIndex(where: {$0.id == data.id}) {
                    self.tblList.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: false)
                }
            }
        }
    }
    
    fileprivate func setContentHeight() {
        
        self.preferredContentSize.height = max(min((self.tblList.contentSize.height + self.searchbar.height), (self.safeHeight-self.keyboardHeight)), 200.0)
    }
    
    fileprivate func setupIndexTableView(stringData: [JMGeneralModel]) {
        
        let (arrayData, arrayTitles) = collation.tableViewIndexsObjects(array: stringData, collationStringSelector: #selector(JMGeneralModel.getTitleForObjcPatch))
        
        self.sectionIndexFilteredData = arrayData as! [[JMGeneralModel]]
        
        self.sectionTitles = arrayTitles
    }
}


// MARK: - UITableViewDataSource
extension StringPickerAlertViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if stringData.count > 0 {
            return sectionIndexEnable ? sectionTitles.count:1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionIndexEnable ? sectionTitles[section]:nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = R.ThemeColor.TableViewCellSelectedColor
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return sectionTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        if let ind = sectionTitles.firstIndex(of: title) {
            return ind
        }
        return index
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sectionIndexEnable ? self.sectionIndexFilteredData[section].count : self.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: StringPickerAlertViewController.cellIdentifier)
        
        if cell == nil {
            
            cell = UITableViewCell(style: .default, reuseIdentifier: StringPickerAlertViewController.cellIdentifier)
        }
        
        let data = self.sectionIndexEnable ? self.sectionIndexFilteredData[indexPath.section][indexPath.row] : self.filteredData[indexPath.row]
        
        cell.textLabel?.text = data.title
        cell.textLabel?.textColor = data.isRed ? .red:.black
        cell.textLabel?.font = UIFont.robotoRegular(13.0)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        cell.accessoryType = self.selectedStrings.filter({ $0.id == data.id }).count > 0 ? .checkmark:.none
        
        cell.selectionStyle = .none
        cell.removeSeparatorInsets()
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension StringPickerAlertViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = self.sectionIndexEnable ? self.sectionIndexFilteredData[indexPath.section][indexPath.row] : self.filteredData[indexPath.row]
        
        if self.selectionType == .multi {
            
            if self.selectedStrings.filter({$0.id == data.id}).count == 0 {
                
                if !data.isRed && self.selectedStrings.count < self.maximumSelectionLimit { self.selectedStrings.append(data) }
                
            } else {
                
                self.selectedStrings.removeAll(where: { $0.id == data.id })
            }
            
        } else {
            
            if !data.isRed {
                self.selectedStrings.removeAll()
                self.selectedStrings.append(data)
            }
        }
        
        self.tblList.reloadData()
        
        if self.selectionType != .multi {
            
            if !data.isRed { self.selection?(self.selectedStrings) }
        }
    }
}


// MARK: - UISearchBarDelegate
extension StringPickerAlertViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Do nothing, just hide the keyboard :D
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let text = searchText.cleanedString()
        
        if text.count > 0 { // Filter locally
            
            self.filteredData = self.stringData.filter({ $0.title.containsString(text, compareOption: .caseInsensitive) })
            
        } else if text.count == 0 { // Reset filter
            
            self.filteredData = self.stringData
        }

        if self.sectionIndexEnable {
            self.setupIndexTableView(stringData: self.filteredData)
        }
        
        if  externalText != nil && self.selectionType == .visitReason && text.count > 0 {
            self.externalText?(text)
        }
        self.tblList.reloadData()
    }
}
