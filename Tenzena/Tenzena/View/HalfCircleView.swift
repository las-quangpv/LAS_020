//
//  HalfCircleView.swift
//  Las020
//
//  Created by apple on 15/11/2023.
//

import UIKit
class HalfCircleView: UIView {
    override func draw(_ rect: CGRect) {
            // Vẽ hình tròn
            let radius: CGFloat = 76.0
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.minY),
                                          radius: radius,
                                          startAngle: 0,
                                          endAngle: CGFloat.pi,
                                          clockwise: true)

            circlePath.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            circlePath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            circlePath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            circlePath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            circlePath.close()

            // Đặt màu cho hình vẽ
            UIColor(hex: 0x191919, alpha: 1).setFill() // Thay đổi màu sắc nếu cần

            // Fill và vẽ đường viền của hình vẽ
            circlePath.fill()
        }
}
