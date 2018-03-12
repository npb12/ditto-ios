//
//  UUColor.swift
//  Useful Utilities - Extensions for UIColor
//
//	License:
//  You are free to use this code for whatever purposes you desire.
//  The only requirement is that you smile everytime you use it.
//

import UIKit

extension UIColor
{
    // Calculates the midpoint value of each color component between two colors
    public static func uuCalculateMidColor(startColor: UIColor, endColor: UIColor) -> UIColor
    {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
        startColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        var startColors : [CGFloat] = [r, g, b, a]
        
        endColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        var endColors : [CGFloat] = [r, g, b, a]
        
        var midColors : [CGFloat] = [0, 0, 0, 0]
        
        var i = 0
        while (i < midColors.count)
        {
            midColors[i] = (startColors[i] + endColors[i]) / 2.0
            i = i + 1
        }
        
        let midColor = UIColor.init(red: midColors[0], green: midColors[1], blue: midColors[2], alpha: midColors[3])
        return midColor
    }
}
