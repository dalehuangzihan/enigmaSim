//: [Previous](@previous)

import Foundation

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

public enum PlugboardError:Error {
    case invalidSelection(message:String)
    case invalidAction(message:String)
}

public func toUpperChar(char:Character) -> Character {
    return Character(String(char).uppercased())
}

open class Plugboard {
    
    public var plugboardMappingsDict:[Character:Character] = [:]
                                    // dict stores only capital letters
    
    public init(){}
    
    /**
     Adds new mapping to 'plugboardMappingsDict'.
     Ensures that mappings are one-to-one.
     - Parameter inChar: one of two characters linked by the plugboard
     - Parameter outChar: one of two characters linked by the plugboard
     - Throws: 'PlugboardError.invalidSelection' if either input already exists in the dictionary.
     */
    private func addMapping(inChar:Character, outChar:Character) throws {
        
        let inCharU = toUpperChar(char: inChar)
        let outCharU = toUpperChar(char: outChar)
    
        if plugboardMappingsDict.keys.contains(inCharU) {
            throw PlugboardError.invalidSelection(message: "ERROR: Mapping to '\(inChar)' already exists.")
            
        } else if plugboardMappingsDict.keys.contains(outCharU) {
            throw PlugboardError.invalidSelection(message: "ERROR: Mapping to '\(outChar)' already exists.")
        
        } else if plugboardMappingsDict.values.contains(inCharU) {
            throw PlugboardError.invalidSelection(message: "ERROR: Mapping from '\(inChar)' already exists.")
        
        } else if plugboardMappingsDict.values.contains(outCharU) {
            throw PlugboardError.invalidSelection(message: "ERROR: Mapping from '\(outChar)' already exists.")
        
        } else {
            plugboardMappingsDict[inCharU] = outCharU
        }
        
    }
    
    /**
     Wrapper method to perform error handling for addMapping.
     */
    public func addMappingWrapper(inChar:Character, outChar: Character) -> Bool {
        do {
            try addMapping(inChar: inChar, outChar: outChar)
            return true
        } catch PlugboardError.invalidSelection(let errmsg) {
            print(errmsg)
            return false
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    /**
     Removes mapping associated with inputted character from plugboardMappingsDict.
     */
    public func removeMapping(char:Character) throws {
        let charU = toUpperChar(char: char)
        
        if plugboardMappingsDict.keys.contains(charU) {
            plugboardMappingsDict.removeValue(forKey: charU)
            
        } else if plugboardMappingsDict.values.contains(charU) {
            let key = plugboardMappingsDict.someKey(forValue: charU)!
                                    // since line only runs if 'char' is a value in dict, 'key' will never be nil.
            plugboardMappingsDict.removeValue(forKey: key)
        } else {
            throw PlugboardError.invalidAction(message: "ERROR: '\(char)' does not exist in the plugboard mappings.")
        }
    }
    
    /**
     Deletes all entries (mappings) from plugboardMappingsDict.
     */
    public func clearMappings() {
        plugboardMappingsDict = [:]
    }
    
    /**
     Simulates operation of the plugboard.
     */
    public func plugboardOp(inChar:Character) -> Character {
        let inCharU = toUpperChar(char: inChar)
        
        if plugboardMappingsDict.keys.contains(inCharU) {
            //forward op (only runs if 'inCharU' is a key in dict):
            return plugboardMappingsDict[inCharU]!
            
        } else if plugboardMappingsDict.values.contains(inCharU) {
            //backward op (only runs if 'inCharU' is a value in dict):
            let key = plugboardMappingsDict.someKey(forValue: inCharU)!
            return key
        
        } else {
            return inCharU
        }
    }
    
}


/*
var testPB = Plugboard()
testPB.addMappingWrapper(inChar: "A", outChar: "K")
testPB.addMappingWrapper(inChar: "C", outChar: "D")
dump(testPB)

print(testPB.addMappingWrapper(inChar: "A", outChar: "M"))
print(testPB.addMappingWrapper(inChar: "K", outChar: "M"))

do {
    try testPB.removeMapping(char: "K")
} catch PlugboardError.invalidSelection(let errmsg) {
    print(errmsg)
}

dump(testPB)

print(testPB.plugboardOp(inChar: "C"))
print(testPB.plugboardOp(inChar: "D"))
*/

//: [Next](@next)
