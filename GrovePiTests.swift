import Foundation
import GrovePi

//setup run loop

var inputs = [GrovePiItem]()

func wait(for wait: inout Bool) {
    while (wait) {
	for input in inputs {
	    print(input.read())
	}
	RunLoop.current.run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0.1))
    }
}



var wait: Bool = true

let button = GrovePiItem(pin: 8, isDigital: true, mode: .input)
inputs.append(button)

//wait(for: &wait)
/*
let led = GrovePiItem(pin: 4, isDigital: true, mode: .output)

for _ in 1...5 {
	print("On")	
	led.write(value: 1)
	sleep(1)
	print("Off")
	led.write(value: 0)
	sleep(1)
}

*/

var screen = GrovePiLCDRGB(color: RGBColor(red: 100, green: 100, blue: 100))
screen.set(text: "Hello\nWorld")
print(screen)
