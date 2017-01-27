//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var firstName = "Jack"
var lastName = "Bauer"

var age = 45
var fullName = firstName + " " + lastName
var fullName2 = "\(firstName) \(lastName) is \(age)" // string interpolation

fullName.append(" III")

// Capitalization
var bookTitle = "revenge of the crab cakes"
bookTitle = bookTitle.capitalized

// Lowercase
var chatroomAnnoyingCapsGuy = "PLEASE HELP ME NOW! HERE IS MY 100 LINES OF CODE"
var lowercasedChat = chatroomAnnoyingCapsGuy.lowercased()

// String replacements
// Mormon Swear Words: Oh My Heck, Fetch

var sentence = "What the fetch?! Heck, that is crazy!"

if sentence.contains("fetch") || sentence.contains("Heck") {
    sentence.replacingOccurrences(of: "fetch", with: "tuna")
    sentence.replacingOccurrences(of: "Heck", with: "Playa")
}