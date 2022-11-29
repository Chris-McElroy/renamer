//
//  main.swift
//  renamer
//
//  Created by Chris McElroy on 10/29/22.
//

import SwiftUI

// how to run:
// swift ~/main/code/renamer/renamer/renamer/main.swift <month>
// if you want to rename within a folder, based on the folder name:
// swift ~/main/code/renamer/renamer/renamer/main.swift -f

let fm = FileManager.default
let path = fm.currentDirectoryPath
var contents = (try? fm.contentsOfDirectory(atPath: path)) ?? []

if CommandLine.arguments.count > 1 {
	if CommandLine.arguments[1] == "-f" {
		renameImages(in: contents)
	} else {
		let month = CommandLine.arguments[1]
		contents.removeAll(where: {
			!$0.hasPrefix(month)
		})
		sortDays(in: contents)
	}
} else {
	sortDays(in: contents)
}

print("finished!")

func sortDays(in days: [String]) {
	for day in days {
		let dayComp = day.split(separator: " ")
		guard dayComp.count == 3 else { continue }
		guard let dayString = getDay(from: dayComp[1]) else { continue }
		guard let monthString = getMonth(from: dayComp[0]) else { continue }
		guard let yearString = getYear(from: dayComp[2]) else { continue }
		
		let dateString = yearString + monthString + dayString
		
		let oldImages = (try? fm.contentsOfDirectory(atPath: path.appending("/" + day))) ?? []
		
		for image in oldImages {
			if image.hasPrefix(".") { continue }
			let oldPath = path.appending("/" + day + "/" + image)
			let newPath: String
			if image.hasPrefix("IMG_") {
				newPath = path.appending("/" + day + "/" + dateString + image.dropFirst(3))
			} else {
				newPath = path.appending("/" + day + "/" + dateString + "_" + image)
			}
			try? fm.moveItem(atPath: oldPath, toPath: newPath)
		}
		
		let newDayPath = path.appending("/" + yearString + monthString + "/" + dateString)
		
		if !((try? fm.contentsOfDirectory(atPath: path)) ?? []).contains(yearString + monthString) {
			try? fm.createDirectory(atPath: path.appending("/" + yearString + monthString), withIntermediateDirectories: false)
		}
		
		try? fm.moveItem(atPath: path.appending("/" + day), toPath: newDayPath)
	}
}

func renameImages(in images: [String]) {
	guard let name = path.split(separator: "/").last else { return }
	
	for image in images {
		if image.hasPrefix(".") { continue }
		let oldPath = path.appending("/" + image)
		let newPath: String
		if image.hasPrefix("IMG_") {
			newPath = path.appending("/" + name + image.dropFirst(3))
		} else {
			newPath = path.appending("/" + name + "_" + image)
		}
		try? fm.moveItem(atPath: oldPath, toPath: newPath)
	}
}

func getDay(from day: Substring) -> String? {
	let noCommaDay = day.dropLast()
	guard let dayInt = Int(noCommaDay) else { return nil }
	let fullDay = noCommaDay.count == 1 ? "0" + noCommaDay : String(noCommaDay)
	if dayInt > 0 && dayInt < 32 {
		return fullDay
	} else {
		return nil
	}
}

func getMonth(from month: Substring) -> String? {
	switch month {
	case "January": return "01"
	case "February": return "02"
	case "March": return "03"
	case "April": return "04"
	case "May": return "05"
	case "June": return "06"
	case "July": return "07"
	case "August": return "08"
	case "September": return "09"
	case "October": return "10"
	case "November": return "11"
	case "December": return "12"
	default: return nil
	}
}

func getYear(from year: Substring) -> String? {
	guard let yearInt = Int(year) else { return nil }
	if yearInt > 1000 && yearInt < 3000 {
		return String(year)
	} else {
		return nil
	}
}
