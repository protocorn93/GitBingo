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
        let dots = extractDots(from: doc)
        return Contributions(dots: dots)
    }
    private func extractDots(from doc: HTMLDocument) -> [Dot] {
        let dayElements = doc.css("g > .day")
        let dots = extractDots(from: dayElements)
        dots.last?.isToday = true
        return dots
    }
    private func extractDots(from object: XPathObject) -> [Dot] {
        var dots: [Dot] = []
        dots = object.compactMap { extractDot(from: $0) }
        return dots
    }
    private func extractDot(from element: XMLElement) -> Dot? {
        guard let date = element["data-date"] else { return nil }
        guard let color = element["fill"] else { return nil }
        guard let dataCount = element["data-count"], let count = Int(dataCount) else { return nil }
        return Dot(date: date, color: color, count: count)
    }
}
