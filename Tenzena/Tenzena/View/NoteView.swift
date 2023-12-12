//
//  NoteView.swift
//  Las020
//
//  Created by Trung Nguyễn on 16/11/2023.
//
import UIKit
class NoteView: UIView {
    @IBOutlet weak var lblNote: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        let nib = UINib(nibName: "NoteView", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
            
        }
    }
}
