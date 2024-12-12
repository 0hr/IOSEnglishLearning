//
//  SignInViewModel.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/11/24.
//

import Foundation
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    @AppStorage("accessToken") public var accessToken: String?
    @AppStorage("userName") public var userName: String?
    @AppStorage("userEmail") public var userEmail: String?
    @AppStorage("userLevel") public var userLevel: String?
}
