import UIKit

class BaseVC: UIViewController {
    var loadingView: LoadingView! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: ActivityEx.screenWidth(), height: ActivityEx.screenHeight()))
        loadingView.tag = 100
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showLoading() {
        self.view.addSubview(loadingView)
        loadingView.animationView.play()
    }
    
    func hideLoading() {
        loadingView.animationView.stop()
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        } else{
            print("No!")
        }
    }

}
