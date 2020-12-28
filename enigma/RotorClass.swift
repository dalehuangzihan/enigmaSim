//
//  rotor.swift
//  enigma
//
//  Created by Dale Huang on 28/12/20.
//

import Foundation

let RotorEncodingsDict:[Int:String] = [1: "EKMFLGDQVZNTOWYHXUSPAIBRCJ",
                                       2: "AJDKSIRUXBLHWTMCQGZNPYFVOE",
                                       3: "BDFHJLCPRTXVZNYEIWGAKMUSQO",
                                       4: "ESOVPZJAYQUIRHXLNFTGKDCMWB",
                                       5: "VZBRGITYUPSDNHLXAWMJQOFECK",
                                       6: "JPGVOUMFYQBENHZRDKASXLICTW",
                                       7: "NZJHGRCXMYSWBOUFAIVLPEKQDT",
                                       8: "FKQHTLXOCBJSPDZRAMEWNIUYGV"]

enum RotorError:Error {
    case invalidSelection(message:String)
}

class Rotor {
    
    let rotorId:Int
    //let rotorEncodingsDict:[Int:String]
    let rotorEncoding:String?
    var isValidRotor: Bool = false
    var counter:UInt = 0
    var advNext:Bool = false

    init(rotorId:Int , encodingNo:Int) {
        self.rotorId = rotorId
        self.rotorEncoding = RotorEncodingsDict[encodingNo]
    }
    
    func checkValidRotor() throws {
        print("Rotor \(self.rotorId): ")
        guard let encoding = self.rotorEncoding else {
            throw RotorError.invalidSelection(message: "Invalid encoding number selected")
        }
        print("Has encoding \(encoding)")
    }
    
}

var testRotor = Rotor(rotorId: 0, encodingNo: 1)
