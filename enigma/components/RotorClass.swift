
import Foundation

private let RotorEncodingsDict:[Int:String] = [1: "EKMFLGDQVZNTOWYHXUSPAIBRCJ",
                                               2: "AJDKSIRUXBLHWTMCQGZNPYFVOE",
                                               3: "BDFHJLCPRTXVZNYEIWGAKMUSQO",
                                               4: "ESOVPZJAYQUIRHXLNFTGKDCMWB",
                                               5: "VZBRGITYUPSDNHLXAWMJQOFECK",
                                               6: "JPGVOUMFYQBENHZRDKASXLICTW",
                                               7: "NZJHGRCXMYSWBOUFAIVLPEKQDT",
                                               8: "FKQHTLXOCBJSPDZRAMEWNIUYGV"]

public enum RotorError:Error {
    case invalidSelection(message:String)
    case invalidCharacter(message:String)
}


// ##################################################################################################################
public func charToInt(char:Character) throws -> Int {
    let upperChar = Character(String(char).uppercased())
    if let posInAlphabet = upperChar.asciiValue {
        return Int(posInAlphabet) - 65
                    // 'A' is 0 (zero-based to aid array access)
    } else {
        throw RotorError.invalidCharacter(message: "ERROR: Character is nil.")
    }
}

// Helper function to handle the exceptions thrown by charToInt()
public func charToIntWrapper(char:Character,
                      fn:(Int)->Int = {(inputInt:Int)->Int in return inputInt},
                                                // returns inputInt by default
                      defaultReturnInt:Int)
                      -> Int {
    var returnInt:Int
    do {
        let tmp = try charToInt(char: char)
        returnInt = fn(tmp)
    } catch RotorError.invalidCharacter(let errMsg) {
        returnInt = defaultReturnInt
        print("\(errMsg); newIndx set to \(returnInt)")
    } catch let error {
        returnInt = defaultReturnInt
        print("\(error.localizedDescription); newIndx set to \(returnInt)")
    }
    return returnInt
}
// ##################################################################################################################


let DefaultReturnAscii = 92 // is the ascii for "\", our default character.

var selectedEncodingNos:Set<Int> = []
var selectedIds:Set<Int> = []

open class Rotor {
    
    public let rotorId:Int
    public let rotorEncodingNo:Int
    public let rotorEncodingStr:String?
    public var rotorEncodingArr:[Character] = []
    public var invRotorEncodingArr:[Character] = []
    public var isValidRotor: Bool = false
    public var counter:UInt = 0
                    // is zero-based
    public var rotorPos:Int = 0
                    // is zero-based
    public var isAdvNext:Bool = false
    
    /**
     CONSTRUCTOR.
     - Parameter rotorId: the id number of the rotor (user selected).
     - Parameter encodingNo: the number of the encoding in RotorEncodingDict.
     - Parameter rotorPos: the starting position of the rotor.
     */
    public init(rotorId:Int , encodingNo:Int, rotorPos:Int) {
        self.rotorId = rotorId
        self.rotorPos = rotorPos
        self.rotorEncodingNo = encodingNo
        
        self.rotorEncodingStr = RotorEncodingsDict[encodingNo]
        if let encoding = self.rotorEncodingStr {
            self.rotorEncodingArr = Array(encoding)
        }
    }
    
    /**
     Checks if rotor encoding string is nil (occurs when incorrect encoding number is selected).
     - Throws: 'RotorError.invalidSelection' if 'self.rotorEncodingStr' == nil.
     */
    private func checkIfNil() throws {
        guard self.rotorEncodingStr != nil else {
            throw RotorError.invalidSelection(message: "ERROR: Invalid encoding number selected.")
        }
    }
    
    /**
     Encrypts the inputted character in the "forward" direction of rotor operation (before passing through reflector).
     - Parameter char: the input character to be encoded.
     - Returns: the forward-encoded character.
     */
    public func fwdEncrypt(char:Character) ->Character {
        let newIndx:Int = charToIntWrapper(char: char,
                                           fn: {(displacement:Int)->Int in return (displacement + self.rotorPos) % 26} ,
                                           defaultReturnInt: 0)
        return self.rotorEncodingArr[newIndx]
    }
    
    /**
     Generates the inverse rotor encoding for use in encryption in the "backwards" direction from self.rotorEncodingArr.
     - Returns: an array containing the "inverse" rotor mapping.
     */
    private func getInvEncodingArr() -> [Character] {
        var invArr = Array<Character>(repeating:"\\", count:self.rotorEncodingArr.count)
        for i in 0 ..< self.rotorEncodingArr.count {
            let char = self.rotorEncodingArr[i]
            do {
                let charPos = try charToInt(char: char)
                if let newCharStr = UnicodeScalar(i+65) {
                    invArr[charPos] = Character(newCharStr)
                } else {
                    invArr[charPos] = "\\"      // is a default case
                }
            } catch RotorError.invalidCharacter(let errmsg) {
                print(errmsg)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return invArr
    }
    
    /**
     Encrypts the inputted character in the "backwards" direction of rotor operation (after passing through reflector).
     - Parameter char: the input character to be encoded.
     - Returns: the backward-encoded character.
     */
    private func bkwdEncrypt (char:Character) -> Character {
        let newIndx:Int = charToIntWrapper(char: char,
                                           fn: {(displacement:Int)->Int in return (displacement + self.rotorPos) % 26} ,
                                           defaultReturnInt: 0)
        return self.invRotorEncodingArr[newIndx]
    }
    
    /**
     Checks if the rotor has completed one complete rotation. If yes, signal to advance the next rotor.
     - Returns: bool indicating whether to advance the next rotor.
     */
    private func checkAdvNxt() -> Bool {
        if self.counter == self.rotorEncodingArr.count {
            self.counter = 0
            return true
        } else {
            return false
        }
    }
    
    /**
     Advances the rotor by 1 position.
     */
    private func rotorAdv(isRotorAdv: Bool) {
        if isRotorAdv {
            self.counter += 1
            self.rotorPos = (self.rotorPos + 1) % 26
        }
    }
    
    /**
     Wrapper method to:
     1. check if rotor is valid,
     2. generate and assign the inverse rotor encoding,
     3. check if freshly-constructed rotor's 'encodingNo' has previously been selected.
     4. check if freshly-constructed rotor's 'rotorId' has previously been selected,
     - Throws: 'RotorError.invalidSelection' if 'encodingNo' has previously been selected.
     - Throws: 'RotorError.invalidSelection' if 'rotorId' has previously been selected.
     */
    public func setUpRotor() throws {
        do {
            try checkIfNil()
        } catch RotorError.invalidSelection (let errmsg) {
            print(errmsg)
        } catch let error {
            print(error.localizedDescription)
        }
        
        self.invRotorEncodingArr = getInvEncodingArr()
        
        if !selectedEncodingNos.contains(self.rotorEncodingNo) {
            selectedEncodingNos.insert(self.rotorEncodingNo)
        } else {
            throw RotorError.invalidSelection(message: "ERROR: Rotor encoding \(self.rotorEncodingNo) is already in use.")
        }
        
        if !selectedIds.contains(self.rotorId) {
            selectedIds.insert(self.rotorId)
        } else {
            throw RotorError.invalidSelection(message: "ERROR: Rotor Id \(self.rotorId) is already taken.")
        }
    }
    
    /**
     Method to carry out rotor operation in the forward direction (before passing through reflector).
     - Parameter inputChar: the inputted character to be encoded.
     - Parameter isRotorAdv: the inputted bool indicating whether the rotor is to be advanced (is advanced before encoding).
     - Returns: tuple '(outputChar, isAdvNxtRotor)' with foward-encoded character and bool to indicate if next rotor should be advanced.
     */
    public func fwdRotorOp (inputChar:Character, isRotorAdv:Bool) -> (outptChar:Character, isAdvNxtRotor:Bool) {
        rotorAdv(isRotorAdv: isRotorAdv)
        let outputChar:Character = fwdEncrypt(char: inputChar)
        let isAdvNextRotor:Bool = checkAdvNxt()
        
        print("inputChar:           \(inputChar)")
        print("outputChar:          \(outputChar)")
        print("isAdvNextRotor:      \(isAdvNextRotor)")
        print()
        
        return (outputChar, isAdvNextRotor)
    }
    
    /**
     Method to carry out rotor operation in the backward direction (after passing through reflector).
     - Parameter inputChar: the inputted character to be encoded.
     - Returns: encoded character.
     */
    public func bkwdRotorOp (inputChar:Character) -> Character {
        return bkwdEncrypt(char: inputChar)
    }
    
    /**
     Prints rotor Metadata.
     */
    public func printRotorMeta() {
        print("rotorId:             \(self.rotorId)")
        print("rotorPos:            \(self.rotorPos)")
        print("counter:             \(self.counter)")
        print("isAdvNext:           \(self.isAdvNext)")
        print("rotorEncodingArr:    \(self.rotorEncodingArr)")
        print("invRotorEncodingArr: \(self.invRotorEncodingArr)")
        print()
    }
    
}

