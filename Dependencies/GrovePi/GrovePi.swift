
import Foundation

internal class GrovePiManager {
    
    static var sharedManager = GrovePiManager()
    
    init() {
        grove_pi_init()
    }
}

public enum PinMode {
    case input
    case output
}

public struct GrovePiItem {
    
    public let pin: UInt
    public let isDigital: Bool
    public let mode: PinMode
    
    public init(pin: UInt, isDigital: Bool, mode: PinMode) {
        self.pin = pin
        self.isDigital = isDigital
        self.mode = mode
        pinMode(Int32(pin), mode == .output ? 1 : 0)
        _ = GrovePiManager.sharedManager
    }
    
    public func read() -> Int {
        guard self.mode == .input else {
            return 0
        }
        
        let corePin = Int32(pin)
        return Int(isDigital ? digitalRead(corePin) : analogRead(corePin))  //Call into C api
    }
    
    public func write(value: Int) {
        guard self.mode == .output else {
            return
        }
        
        let corePin = Int32(pin)
        let coreValue = Int32(value)
        if isDigital {
            digitalWrite(corePin, coreValue) //Call into C api
        } else {
            analogWrite(corePin, coreValue) //Call into C api
        }
    }
}

internal func writeBlock(_ address: UInt8, _ command: UInt8, _ value: UInt8) {
    write_byte_data(address, command, value) //Call into C api
}

internal enum Commands: Int8 {
    case digitalRead = 1
    case digitalWrite = 2
    case analogRead = 3
    case analogWrite = 4
    case pMode = 5
}
