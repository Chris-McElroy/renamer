//
//  main.swift
//  renamer
//
//  Created by Chris McElroy on 10/29/22.
//

import SwiftUI


// how to run:
// swift ~/main/code/renamer/renamer/renamer/main.swift

let fm = FileManager.default
let path = fm.currentDirectoryPath
let oldDays = (try? fm.contentsOfDirectory(atPath: path)) ?? []

// how to move things
// try fm.moveItem(atPath: path.appending("/October 1, 2022"), toPath: path.appending("/Testtest123"))

for day in oldDays {
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
		try fm.moveItem(atPath: oldPath, toPath: newPath)
	}
	
	let newDayPath = path.appending("/" + yearString + monthString + "/" + dateString)
	
	if !((try? fm.contentsOfDirectory(atPath: path)) ?? []).contains(yearString + monthString) {
		try fm.createDirectory(atPath: path.appending("/" + yearString + monthString), withIntermediateDirectories: false)
	}
	
	try fm.moveItem(atPath: path.appending("/" + day), toPath: newDayPath)
}

print("finished!")

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

// per day folder,
// make the string that represents the day
// add that string to all the image names within that folder
// move the whole folder to be inside of the correct month folder

//print(oldDays)

//let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
//let toURL = documentsDirectory.URLByAppendingPathComponent(to.lastPathComponent!)
//
//print("renaming file \(from.absoluteString) to \(to) url \(toURL)")
//let fileManager = NSFileManager.defaultManager()
//fileManager.delegate = self
//do {
//	try NSFileManager.defaultManager().moveItemAtURL(from, toURL: toURL)
//} catch let error as NSError {
//	print(error.localizedDescription)
//} catch {
//	print("error renaming recording")
//}
//dispatch_async(dispatch_get_main_queue(), {
//	self.listRecordings()
//	/
//})
