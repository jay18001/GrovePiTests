// I2C addresses
fileprivate let I2CBacklight: UInt8 = 0x62
fileprivate let I2CCharacter: UInt8 = 0x3e

fileprivate let ClearDisplay: UInt8 = 0x01
fileprivate let DisplayOn: UInt8 = 0x0F
fileprivate let TwoLines: UInt8 = 0x38

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

public struct GrovePiLCDRGB {

    let color: RGBColor

    public init(color: RGBColor) {
        self.color = color
        setup()
	
    }

    private func setup() {
       	print("blacklightMode1 \(writeBlock(.digitalWrite, I2CBacklight, blacklightMode1, blacklightMode1))")
	print("blacklightMode2 \(writeBlock(.digitalWrite, I2CBacklight, blacklightMode2, blacklightMode1))")        
        print("blacklightLEDout \(writeBlock(.digitalWrite, I2CBacklight, 8, UInt8(0xaa)))")
	setupColor(color: color)
	print("setupColor")
    }
	
    public func clearDisplay() {
        _ = writeBlock(.digitalWrite, I2CCharacter, characterDisplay, ClearDisplay)
	print("characterDisplay")
    }

    private func setupColor(color: RGBColor) {
        _ = writeBlock(.digitalWrite, I2CBacklight, blacklightBlue, color.blue)
        print("blacklightBlue")
	_ = writeBlock(.digitalWrite, I2CBacklight, blacklightRed, color.red)
        print("blacklightRed")
	_ = writeBlock(.digitalWrite, I2CBacklight, blacklightGreen, color.green)
    	print("blacklightGreen")
    }

    public mutating func setColor(color: RGBColor) {
        self.setupColor(color: color)
    }

    public func setText(string: String) {
        _ = writeBlock(.digitalWrite, I2CCharacter, characterDisplay, DisplayOn)
        print("characterDisplay-DisplayOn")
	_ = writeBlock(.digitalWrite, I2CCharacter, characterDisplay, TwoLines)
	print("characterDisplay-TwoLines")
        let characters = string.characters.flatMap { UInt8(String($0)) }
        characters.forEach {
            _ = writeBlock(.digitalWrite, I2CCharacter, characterLetters, $0)
      	    print("I2CCharacter-characterLetters")
	}
    }
}
