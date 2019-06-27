//
//  Storyboarded.swift
//  GitBingo
//
//  Created by 이동건 on 27/06/2019.
//  Copyright © 2019 이동건. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self?
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self? {
        let storyboard = UIStoryboard(name: Self.reusableIdentifier, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Self.reusableIdentifier) as? Self
    }
}
