
import UIKit
import StoreKit

class DrawerMenuViewController: UIViewController {

    let transitionManager = DrawerTransitionManager()

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = transitionManager
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    @IBAction func actionCLose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionRate(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    @IBAction func actionFeedback(_ sender: Any) {
        EmailService().compose(controller: self)

    }
    @IBAction func actionTerm(_ sender: Any) {
        let urlStr = "https://trasarda4488.github.io/privacy.html"
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(URL(string: urlStr)!)
    
        }
    }
    
}
