

import UIKit

class DetailViewController: UIViewController {
    
    var lab : UILabel!
    var boy : String = "" {
        didSet {
            if self.lab != nil {
                self.lab.text = self.boy
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let lab = UILabel(frame:CGRectMake(100,100,200,30))
        self.view.addSubview(lab)
        self.lab = lab
        let lines =  linesFromResourceForced("Introduction.txt")
        
        self.lab.text = lines.joinWithSeparator("")
    }
    
    deinit {
        print("farewell from detail view controller")
    }
    
    func linesFromResourceForced(fileName: String) -> [String] {
        
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: nil)!
        let content = try! String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        return content.componentsSeparatedByString("\n")
    }

}
