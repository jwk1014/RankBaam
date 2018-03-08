//
//  String+Extension.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 3. 2..
//  Copyright © 2018년 김정원. All rights reserved.
//


public extension String {
    
    func widthForHeight(_ height: CGFloat, font: UIFont) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.size.width
    }
    
    func heightForWidth(_ width: CGFloat, font: UIFont) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.size.height
    }
    
}
