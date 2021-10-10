//: [Previous](@previous)

import Foundation

private let ReflectorEncodingsDict:[Int:String] = [1: "EJMZALYXVBWFCRQUONTSPIKHGD",
                                                   2: "YRUHQSLDPXNGOKMIEBFZCWVJAT",
                                                   3: "FVPJIAOYEDRZXWGCTKUQSBNMHL"]
                                                    // corresponds to Reflector A, Reflector B, Reflector C

/**
 Is subclass of the Rotor class.
 */
public class Reflector: Rotor {
    
    /**
      CONSTRUCTOR.
      - Parameter rotorId: the id number of the rotor (user selected).
      - Parameter encodingNo: the number of the encoding in RotorEncodingDict.
     */
    public init(reflectorId:Int, encodingNo:Int) {
        super.init(rotorId: reflectorId, encodingNo: encodingNo, rotorPos: 0)
                                    // sets super.rotorPos = 0 by default
    }
    
    /**
     Performs operation of the reflector in the "forward" direction; reflector has no "backward" operating direction.
     - Parameter char: inputted character to be encoded.
     - Returns: encoded character.
     */
    public func reflectorOp(char:Character) -> Character {
        return fwdEncrypt(char:char)
    }
    
}


//: [Next](@next)
