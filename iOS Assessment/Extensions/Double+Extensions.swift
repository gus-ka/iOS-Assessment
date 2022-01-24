//
//  Float+Extensions.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 23/01/22.
//

extension Double {
    func string(maximumFractionDigits: Int = 2) -> String {
        let s = String(format: "%.\(maximumFractionDigits)f", self)
        var offset = -maximumFractionDigits - 1
        for i in stride(from: 0, to: -maximumFractionDigits, by: -1) {
            if s[s.index(s.endIndex, offsetBy: i - 1)] != "0" {
                offset = i
                break
            }
        }
        return String(s[..<s.index(s.endIndex, offsetBy: offset)])
    }
}
