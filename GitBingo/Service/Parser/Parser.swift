//
//  Parser.swift
//  GitBingo
//
//  Created by 이동건 on 17/11/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Kanna

class Parser: HTMLParsingProtocol {
    func parse(from data: Data?) -> Contributions? {
        guard let data = data, let rawHTML = String(data: data, encoding: .utf8) else { return nil }
        guard let doc = try? HTML(html: rawHTML, encoding: .utf8) else { return nil }
        if doc.body?.content == "Not Found" { return nil }

        let dayElements = doc.css("g > .day")

        var dots: [Dot] = []

        dayElements.forEach { (day) in
            guard let date = day["data-date"] else { return }
            guard let color = day["fill"] else { return }
            guard let dataCount = day["data-count"], let count = Int(dataCount) else { return }
            let dot = Dot(date: date, color: color, count: count)
            dots.append(dot)
        }
        dots.last?.isToday = true
        return Contributions(dots: dots)
    }
}
