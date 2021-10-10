//: [Previous](@previous)

import Foundation
/*
let rotor1:Rotor = Rotor(rotorId: 1, encodingNo: 1, rotorPos: 0)
do {
    try rotor1.setUpRotor()
} catch RotorError.invalidSelection(let errMsg) {
    print(errMsg)
}

let rotor2:Rotor = Rotor(rotorId: 2, encodingNo: 2, rotorPos: 0)
do {
    try rotor2.setUpRotor()
} catch RotorError.invalidSelection(let errMsg) {
    print(errMsg)
}

let rotor3:Rotor = Rotor(rotorId: 3, encodingNo: 3, rotorPos: 0)
do {
    try rotor3.setUpRotor()
} catch RotorError.invalidSelection(let errMsg) {
    print(errMsg)
}

let reflector1: Reflector = Reflector(reflectorId: 1, encodingNo: 1)
*/
// ----------------------------------
// TESTING WITHOUT PLUGBOARD:
let inputChar:Character = "L"
let rotorPosTest = 12

// ENCODE:
let rotor1:Rotor = Rotor(rotorId: 1, encodingNo: 1, rotorPos: rotorPosTest)
do {
    try rotor1.setUpRotor()
} catch RotorError.invalidSelection(let errMsg) {
    print(errMsg)
}
let (r1Fwd, bool) = rotor1.fwdRotorOp(inputChar: inputChar, isRotorAdv: true)
print(r1Fwd)
rotor1.printRotorMeta()

let reflector1:Reflector = Reflector(reflectorId: 1, encodingNo: 1)
do {
    try reflector1.checkIfNil()
} catch ReflectorError.invalidSelection(let errmsg) {
    print(errmsg)
}
print(reflector1.reflectorEncodingArr)
print()
let ref1Out = reflector1.encrypt(char: r1Fwd)

let r1Bkwd = rotor1.bkwdRotorOp(inputChar: ref1Out)
print(r1Bkwd)
rotor1.printRotorMeta()

print("----------")

// DECODE:
rotor1.rotorPos = rotorPosTest
rotor1.counter = 0
let(r11Fwd, bool2) = rotor1.fwdRotorOp(inputChar: r1Bkwd, isRotorAdv: true)
let ref11Out = reflector1.encrypt(char: r11Fwd)
let r11Bkwd = rotor1.bkwdEncrypt(char: ref11Out)

print("Encoded char: \(inputChar); Decoded char: \(r11Bkwd)")


//: [Next](@next)



// Testing bkwdEncrypt algorithm:
/*
let tmpChar:Character = "C"
let rotorPosTest = 12
var newCharPos:Int = charToIntWrapper(char: tmpChar, fn: {(pos:Int)->Int in return (pos - rotorPosTest) % 26}, defaultReturnInt: 0)
print(newCharPos)
if newCharPos < 0 {
    newCharPos = 26 + newCharPos
}
print(newCharPos)
print(Character(UnicodeScalar(newCharPos+65)!))
//ABCDEFGHIJKLMNOPQRSTUVWXYZ
*/
