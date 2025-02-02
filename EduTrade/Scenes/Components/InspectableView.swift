//
//  InspectableView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 29.01.2025.
//

import SwiftUI

protocol InspectableView: View {
    var didAppear: ((Self) -> Void)? { get set }
}
