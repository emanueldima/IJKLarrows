import Foundation
import Cocoa


var SwitchTilde = false
let SwitchTildeArgument = "--tilde"

main()

func main() {
    let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue) | (1 << CGEventType.flagsChanged.rawValue)
    guard let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap, place: .headInsertEventTap, options: .defaultTap,
                                       eventsOfInterest: CGEventMask(eventMask), callback: myCGEventCallback, userInfo: nil)
    else {
        print("failed to create event tap")
        exit(1)
    }
    print("started")

    if CommandLine.arguments.contains(SwitchTildeArgument) {
        print("switching tilde")
        SwitchTilde = true
    }

    let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
    CGEvent.tapEnable(tap: eventTap, enable: true)
    CFRunLoopRun()
}

func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    let kVK_ANSI_I:Int64                    = 0x22
    let kVK_ANSI_L:Int64                    = 0x25
    let kVK_ANSI_J:Int64                    = 0x26
    let kVK_ANSI_K:Int64                    = 0x28
    let kVK_ANSI_Grave:Int64                = 0x32 // `
    let kVK_ANSI_Section:Int64              = 0x0A // §
    let kVK_LeftArrow:Int64                 = 0x7B
    let kVK_RightArrow:Int64                = 0x7C
    let kVK_DownArrow:Int64                 = 0x7D
    let kVK_UpArrow:Int64                   = 0x7E
    let kVK_PageUp:Int64                    = 0x74
    let kVK_Home:Int64                      = 0x73
    let kVK_PageDown:Int64                  = 0x79
    let kVK_End:Int64                       = 0x77

    let maskLeftCmd = CGEventFlags(rawValue: 0x8)
    let maskRightCmd = CGEventFlags(rawValue: 0x10)
    let maskFn = CGEventFlags(rawValue: 0x800100)

    if [.keyDown , .keyUp, .flagsChanged].contains(type) {
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        let hasFn = event.flags.contains(maskFn)
        // printFlags(event: event, end: "\t->\t")

        if SwitchTilde && keyCode == kVK_ANSI_Grave {
            event.setIntegerValueField(.keyboardEventKeycode, value: kVK_ANSI_Section)
        } else if SwitchTilde && keyCode == kVK_ANSI_Section {
            event.setIntegerValueField(.keyboardEventKeycode, value: kVK_ANSI_Grave)
        }

        if event.flags.contains(maskRightCmd) {
            var changed = false
            if keyCode == kVK_ANSI_I {
                event.setIntegerValueField(.keyboardEventKeycode, value: hasFn ? kVK_PageUp : kVK_UpArrow)
                changed = true
            } else if keyCode == kVK_ANSI_J {
                event.setIntegerValueField(.keyboardEventKeycode, value: hasFn ? kVK_Home : kVK_LeftArrow)
                changed = true
            } else if keyCode == kVK_ANSI_K {
                event.setIntegerValueField(.keyboardEventKeycode, value: hasFn ? kVK_PageDown : kVK_DownArrow)
                changed = true
            } else if keyCode == kVK_ANSI_L {
                event.setIntegerValueField(.keyboardEventKeycode, value: hasFn ? kVK_End : kVK_RightArrow)
                changed = true
            }
            if changed {
                if !event.flags.contains(maskLeftCmd) {
                    event.flags.remove(.maskCommand)
                }
                event.flags.remove(maskRightCmd)
            }
        }
        // printFlags(event: event, end: "\n")
    }
    return Unmanaged.passRetained(event)
}

func printFlags(event: CGEvent, end: String) {
    let r = event.flags.rawValue
    let flags = [ r & 0xf, (r >> 4) & 0xf, (r >> 8) & 0xf, (r >> 12) & 0xf, (r >> 16) & 0xf, (r >> 20) & 0xf, (r >> 24) & 0xf, (r >> 28) & 0xf ]
    let sflags = flags.reversed().map { String($0, radix: 16) }
    let keyCode = String(event.getIntegerValueField(.keyboardEventKeycode), radix: 16)
    print("0x" + keyCode, "    ", sflags.joined(separator: ""), end, terminator: "")
}



//let kVK_ANSI_A:Int64                    = 0x00
//let kVK_ANSI_S:Int64                    = 0x01
//let kVK_ANSI_D:Int64                    = 0x02
//let kVK_ANSI_F:Int64                    = 0x03
//let kVK_ANSI_H:Int64                    = 0x04
//let kVK_ANSI_G:Int64                    = 0x05
//let kVK_ANSI_Z:Int64                    = 0x06
//let kVK_ANSI_X:Int64                    = 0x07
//let kVK_ANSI_C:Int64                    = 0x08
//let kVK_ANSI_V:Int64                    = 0x09
//let kVK_ANSI_B:Int64                    = 0x0B
//let kVK_ANSI_Q:Int64                    = 0x0C
//let kVK_ANSI_W:Int64                    = 0x0D
//let kVK_ANSI_E:Int64                    = 0x0E
//let kVK_ANSI_R:Int64                    = 0x0F
//let kVK_ANSI_Y:Int64                    = 0x10
//let kVK_ANSI_T:Int64                    = 0x11
//let kVK_ANSI_1:Int64                    = 0x12
//let kVK_ANSI_2:Int64                    = 0x13
//let kVK_ANSI_3:Int64                    = 0x14
//let kVK_ANSI_4:Int64                    = 0x15
//let kVK_ANSI_6:Int64                    = 0x16
//let kVK_ANSI_5:Int64                    = 0x17
//let kVK_ANSI_Equal:Int64                = 0x18
//let kVK_ANSI_9:Int64                    = 0x19
//let kVK_ANSI_7:Int64                    = 0x1A
//let kVK_ANSI_Minus:Int64                = 0x1B
//let kVK_ANSI_8:Int64                    = 0x1C
//let kVK_ANSI_0:Int64                    = 0x1D
//let kVK_ANSI_RightBracket:Int64         = 0x1E
//let kVK_ANSI_O:Int64                    = 0x1F
//let kVK_ANSI_U:Int64                    = 0x20
//let kVK_ANSI_LeftBracket:Int64          = 0x21
//let kVK_ANSI_I:Int64                    = 0x22
//let kVK_ANSI_P:Int64                    = 0x23
//let kVK_ANSI_L:Int64                    = 0x25
//let kVK_ANSI_J:Int64                    = 0x26
//let kVK_ANSI_Quote:Int64                = 0x27
//let kVK_ANSI_K:Int64                    = 0x28
//let kVK_ANSI_Semicolon:Int64            = 0x29
//let kVK_ANSI_Backslash:Int64            = 0x2A
//let kVK_ANSI_Comma:Int64                = 0x2B
//let kVK_ANSI_Slash:Int64                = 0x2C
//let kVK_ANSI_N:Int64                    = 0x2D
//let kVK_ANSI_M:Int64                    = 0x2E
//let kVK_ANSI_Period:Int64               = 0x2F
//let kVK_ANSI_KeypadDecimal:Int64        = 0x41
//let kVK_ANSI_KeypadMultiply:Int64       = 0x43
//let kVK_ANSI_KeypadPlus:Int64           = 0x45
//let kVK_ANSI_KeypadClear:Int64          = 0x47
//let kVK_ANSI_KeypadDivide:Int64         = 0x4B
//let kVK_ANSI_KeypadEnter:Int64          = 0x4C
//let kVK_ANSI_KeypadMinus:Int64          = 0x4E
//let kVK_ANSI_KeypadEquals:Int64         = 0x51
//let kVK_ANSI_Keypad0:Int64              = 0x52
//let kVK_ANSI_Keypad1:Int64              = 0x53
//let kVK_ANSI_Keypad2:Int64              = 0x54
//let kVK_ANSI_Keypad3:Int64              = 0x55
//let kVK_ANSI_Keypad4:Int64              = 0x56
//let kVK_ANSI_Keypad5:Int64              = 0x57
//let kVK_ANSI_Keypad6:Int64              = 0x58
//let kVK_ANSI_Keypad7:Int64              = 0x59
//let kVK_ANSI_Keypad8:Int64              = 0x5B
//let kVK_ANSI_Keypad9:Int64              = 0x5C
//let kVK_Return:Int64                    = 0x24
//let kVK_Tab:Int64                       = 0x30
//let kVK_Space:Int64                     = 0x31
//let kVK_Delete:Int64                    = 0x33
//let kVK_Escape:Int64                    = 0x35
//let kVK_Command:Int64                   = 0x37
//let kVK_Shift:Int64                     = 0x38
//let kVK_CapsLock:Int64                  = 0x39
//let kVK_Option:Int64                    = 0x3A
//let kVK_Control:Int64                   = 0x3B
//let kVK_RightShift:Int64                = 0x3C
//let kVK_RightOption:Int64               = 0x3D
//let kVK_RightControl:Int64              = 0x3E
//let kVK_Function:Int64                  = 0x3F
//let kVK_F17:Int64                       = 0x40
//let kVK_VolumeUp:Int64                  = 0x48
//let kVK_VolumeDown:Int64                = 0x49
//let kVK_Mute:Int64                      = 0x4A
//let kVK_F18:Int64                       = 0x4F
//let kVK_F19:Int64                       = 0x50
//let kVK_F20:Int64                       = 0x5A
//let kVK_F5:Int64                        = 0x60
//let kVK_F6:Int64                        = 0x61
//let kVK_F7:Int64                        = 0x62
//let kVK_F3:Int64                        = 0x63
//let kVK_F8:Int64                        = 0x64
//let kVK_F9:Int64                        = 0x65
//let kVK_F11:Int64                       = 0x67
//let kVK_F13:Int64                       = 0x69
//let kVK_F16:Int64                       = 0x6A
//let kVK_F14:Int64                       = 0x6B
//let kVK_F10:Int64                       = 0x6D
//let kVK_F12:Int64                       = 0x6F
//let kVK_F15:Int64                       = 0x71
//let kVK_Help:Int64                      = 0x72
//let kVK_ForwardDelete:Int64             = 0x75
//let kVK_F4:Int64                        = 0x76
//let kVK_F2:Int64                        = 0x78
//let kVK_F1:Int64                        = 0x7A
