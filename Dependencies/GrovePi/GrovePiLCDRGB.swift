import Foundation

// I2C addresses
fileprivate let I2CBacklight: UInt8 = 0x62
fileprivate let I2CCharacter: UInt8 = 0x3e

fileprivate let ClearDisplay: UInt8 = 0x01
fileprivate let ReturnHome: UInt8 = 0x02
fileprivate let DisplayOn: UInt8 = 0xFE
fileprivate let TwoLines: UInt8 = 0x38
fileprivate let NoCursor: UInt8 = 0x04

//backlight registers
fileprivate let blacklightMode1: UInt8 = 0x00
fileprivate let blacklightMode2: UInt8 = 0x01
fileprivate let blacklightBlue: UInt8 = 0x02
fileprivate let blacklightGreen: UInt8 = 0x03
fileprivate let blacklightRed: UInt8 = 0x04
fileprivate let blacklightLEDout: UInt8 = 0x08

// character registers
fileprivate let characterDisplay: UInt8 = 0x80
fileprivate let characterLetters: UInt8 = 0x40

public struct RGBColor {
    let red: UInt8
    let green: UInt8
    let blue: UInt8

    public init(red: UInt8, green: UInt8, blue: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}

public struct GrovePiLCDRGB: CustomStringConvertible {

    public private(set) var color: RGBColor
    public private(set) var text: String

    public var description: String {
	var count = 0
	var row = 0
	var displayText = ""
	for c in text.characters {
            if c == "\n" || count == 16 {
                count = 0
                row += 1
                if row == 2 {
                    break
                }
		displayText.append("\n")                
                if c == "\n" {
                    continue
                }
            }
            count += 1
	    displayText.append(c)
        }
        return "LCD-RGB-Screen Color: \(self.color)\n\(displayText)"
    }


    public init(text: String = "", color: RGBColor) {
        self.color = color
	self.text = text
	_ = GrovePiManager.sharedManager
        setup()
    }

    private func setup() {
       	writeBlock(I2CBacklight, blacklightMode1, blacklightMode1)
	writeBlock(I2CBacklight, blacklightMode2, blacklightMode1)        
        writeBlock(I2CBacklight, blacklightLEDout, UInt8(0xaa))
	setup(color: color)
    }
	
    public func clearDisplay() {
        writeBlock(I2CCharacter, characterDisplay, ClearDisplay)
    }

    private func setup(color: RGBColor) {
        writeBlock(I2CBacklight, blacklightBlue, color.blue)
	writeBlock(I2CBacklight, blacklightRed, color.red)
	writeBlock(I2CBacklight, blacklightGreen, color.green)
    }

    public mutating func set(color: RGBColor) {
        self.color = color
	self.setup(color: color)
    }

    public mutating func set(text: String, refresh: Bool = true) {
	self.text = text

        writeBlock(I2CCharacter, characterDisplay, refresh ? ClearDisplay : ReturnHome)
        writeBlock(I2CCharacter, characterDisplay, DisplayOn)
        
        writeBlock(I2CCharacter, characterDisplay, TwoLines)
        
        let characters = text.characters.flatMap { String($0).utf8.first }
        
   	var count = 0
	var row = 0
    
        for c in characters {
            if c == 0x0A || count == 16 {
                count = 0
                row += 1
                if row == 2 {
                    break
                }
                writeBlock(I2CCharacter, characterDisplay, UInt8(0xc0))
                
		if c == 0x0A {
                    continue
                }
            }
            count += 1
            
            writeBlock(I2CCharacter, characterLetters, c)
        }
    }
}
