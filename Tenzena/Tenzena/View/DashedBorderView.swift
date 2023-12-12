//
//  DashedBorderView.swift
//  Las020
//
//  Created by apple on 16/11/2023.
//

import Foundation
import UIKit

class DashedBorderView: UIView {
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    var dashedBorderLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Tạo một đường đứt với kích thước và mẫu mong muốn
        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = UIColor.gray.cgColor
        dashedBorder.lineDashPattern = [4, 4]  // Mẫu đường đứt: 4 điểm đứt, 4 điểm trống
        dashedBorder.frame = bounds
        dashedBorder.fillColor = nil
        dashedBorder.path = UIBezierPath(rect: bounds).cgPath
        // Thêm bo góc
        let cornerRadius: CGFloat = 10
        dashedBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        // Xóa tất cả các lớp con hiện có
        dashedBorderLayer.sublayers?.removeAll()

        // Thêm lớp đường đứt vào lớp chính
        dashedBorderLayer.addSublayer(dashedBorder)
    }
}

// Sử dụng trong ViewController
