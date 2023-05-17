import Foundation
//  Created by Alexander Matheson
//  Created on 2023-May-15
//  Version 1.0
//  Copyright (c) 2023 Alexander Matheson. All rights reserved.
//
//  This program uses a selection to sort an array.

// Enum for error checking.
enum InputError: Error {
  case InvalidInput
}

// Input in separate function for error checking.
func convert(strUnconverted: String) throws -> Int {
  guard let numConverted = Int(strUnconverted.trimmingCharacters(in: CharacterSet.newlines)) else {
    throw InputError.InvalidInput
  }
  return numConverted
}

// This function uses a selection sort.
func sort(listOfNum: [Int]) -> [Int] {
  // New array because "listOfNum" is seen as a let constant for some reason.
  var listNum = listOfNum
  // Loop to iterate through array.
  for index in 0..<listNum.count {
    var minIndex = index
    for element in index + 1..<listNum.count {
      // Compare each element to find lowest unsorted element.
      if listNum[element] < listNum[minIndex] {
        minIndex = element
      }
    }

    // Move lowest unsorted element to the front of the unsorted
    // section of the array.
    if minIndex != index {
      let temp = listNum[index]
      listNum[index] = listNum[minIndex]
      listNum[minIndex] = temp
    }
  }
  return listNum
}

// Read in lines from input.txt.
let inputFile = URL(fileURLWithPath: "input.txt")
let inputData = try String(contentsOf: inputFile)
let lineArray = inputData.components(separatedBy: .newlines)

// Open the output file for writing.
let outputFile = URL(fileURLWithPath: "output.txt")

// Call function and print to output file.
var indexString = ""
var counter = 0
while counter < lineArray.count {
  // Convert to int.
  var error = false
  let tempArr = lineArray[counter].components(separatedBy: " ")
  var numArr: [Int] = []
  do {
    for location in tempArr {
      // If statement to fix bug found in previous files where the array would
      // not be converted if the line ended with a space.
      if !location.isEmpty {
        numArr.append(try convert(strUnconverted: location))
      }
    }

    // Continuation of bug fix mentioned on line 65, this time to catch empty lines.
    // For some reason, this functionality (which was present in previous files)
    // was removed by the if statement on line 67.
    if numArr.isEmpty {
      error = true
    }
  } catch InputError.InvalidInput {
    error = true
  }

  // Check for errors
  if error {
    indexString = indexString + "Cannot convert line to int\n"
  } else {
    // Call function and output results.
    let index = sort(listOfNum: numArr)
    indexString = indexString + "\(index)\n"
  }
  try indexString.write(to: outputFile, atomically: true, encoding: .utf8)
  counter = counter + 1
}
print(indexString)
