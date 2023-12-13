import UIKit
import WebKit

class PlayVC: BaseMainVC, WKNavigationDelegate{

    @IBOutlet weak var playYoutubeView: WKWebView!
    @IBOutlet weak var lbTitle: UILabel!
    
    var linkUrl: String = ""
    var titleString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playYoutubeView.navigationDelegate = self
        loadFromYtb(link: linkUrl)
        lbTitle.text = titleString
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func loadFromYtb(link: String) {
        guard let url = URL(string: link) else { return  }
        let requestObj = URLRequest(url: url)
        playYoutubeView.load(requestObj)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                   completionHandler: { (html: Any?, error: Error?) in
            
            if html != nil {
                if "\(html!)".contains("UNPLAYABLE") {
                    let alert = UIAlertController(title: "Notification", message: "Trailer does not exist", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Agree", style: .default, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
}
