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
    let rotorEncoding:String?
    var isValidRotor: Bool = false
    var counter:UInt = 0
    var advNext:Bool = false

    init(rotorId:Int , encodingNo:Int) throws {
        self.rotorId = rotorId
        
        guard RotorEncodingsDict[encodingNo] != nil else {
            throw RotorError.invalidSelection(message: "Invalid encoding number selected")
        }
        self.rotorEncoding = RotorEncodingsDict[encodingNo]
    }
}


