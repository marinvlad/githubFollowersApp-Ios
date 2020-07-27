//
//  ErrorMessage.swift
//  GitHub
//
//  Created by Vlad on 7/22/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import Foundation
enum GFError : String, Error {
    case invalidUsername = "This username created an invalid reques. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data received from the server was invalid. Please try again"
    case unableToFavorite = "Error favoriteing the user. Please try again"
    case alreadyInFavorties = "You already favorited this user"
}
