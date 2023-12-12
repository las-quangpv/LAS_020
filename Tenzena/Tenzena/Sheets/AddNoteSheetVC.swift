

import UIKit

class AddNoteSheetVC: BaseVC, UITextViewDelegate {
    @IBOutlet weak var ivAvatar: PImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tvNote: UITextView!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    @IBOutlet weak var constrantBottom: NSLayoutConstraint!
    
    var noteBlock: ((String)->Void)!
    var context: UIViewController!
    var moveModel: DMoviesDetail!
    var noteString: String = ""
    private var isKeyboardShow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tvNote.delegate = self
        if(noteString != "") {
            tvNote.text = noteString
            lblPlaceHolder.isHidden = true
        }
        ivAvatar.setImage(imageUrl: moveModel.poster_path)
        lblName.text = moveModel.title
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if !isKeyboardShow {
            isKeyboardShow = true
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                self.constrantBottom.constant = keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        isKeyboardShow = false
        self.constrantBottom.constant = 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentString = (textView.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: text)
        lblPlaceHolder.isHidden = newString.count != 0
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        lblPlaceHolder.isHidden = true
        return true
    }
    @IBAction func actionBack(_ sender: Any) {
        self.removeOverlay(contextVC: context)
        self.dismiss(animated: true)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        if let txt = self.tvNote.text, txt != "" {
            self.dismiss(animated: true) {
                self.removeOverlay(contextVC: self.context)
                if(self.noteBlock != nil) {
                    self.noteBlock(txt)
                }
            }
        }else {
            DAppMessagesManage.shared.showMessage(messageType: .error, message: "You haven't entered a note yet")
        }
        
    }
    
}
