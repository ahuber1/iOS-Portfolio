# Section 4
**Foundational iOS**

This directory contains code that was written during Section 4 "Foundational iOS" of the [iOS 10 and Swift 3 course](https://www.udemy.com/devslopes-ios10/) I am currently taking. In this directory are seven subdirectories, each of which are explained in detail below.

## Table of Contents

1. [`HelloWorld`](## `HelloWorld)
2. [`MiraclePill`](## `MiraclePill`)
3. [`PageTheScroll`](## `PageTheScroll`)
4. [`RetroCalculator`](## `RetroCalculator`)
5. [`PartyRock`](## `PartyRock`)
6. [`AutoLayout`](## `AutoLayout`)

## `HelloWorld`

In this directory is the source code for a very simple application that introduced us to Xcode's Interface Builder, `IBOutlet`s, and `IBAction`s. First, it displays a blue screen with a button in the center that says "Welcome".

![HelloWorld_iPhone7_Before.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/HelloWorld/HelloWorld_iPhone7_Before.png?raw=true "Before the welcome button was pressed")

After this button is pressed, the button and blue background disappears, and the following is displayed.

![HelloWorld_iPhone7_After.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/HelloWorld/HelloWorld_iPhone7_After.png?raw=true "After the welcome button was pressed")

## `MiraclePill`

In this directory is the source code for a slightly more complex application that introduced us to `UITextField`s and `UIPickerField`s. This application displays an order form for the "Miracle Pill", a pill that will cure all ailments that one may have.

![1_MiraclePill_Empty.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/MiraclePill/1_MiraclePill_Empty.png?raw=true "The empty form")

A key change that I made in this app was embedding all of these views in a `UIScrollView` in order to better space all the views and not have views go off the screen.

After tapping the button that says "Tap to select state", a `UIPickerView` displays  all the states and some U.S. territories, and the button that stated "Tap to select state" changes to "Tap here when you are done selecting the state".

Instead of creating an array of states, and then having those states appear in the `UIPickerView`, I made a [`.txt`](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/MiraclePill/MiraclePill/states.txt) file containing all the states and their two-letter abbreviations. This file is then read, and an array of states is created and displayed in the `UIPickerView`. Look at

`static func constructStatesList() -> [(abbreviation: String, fullName: String)]`

in [`ViewController.swift`](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/MiraclePill/MiraclePill/ViewController.swift) for more information.

![2_MiraclePill_Selecting_State.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/MiraclePill/2_MiraclePill_Selecting_State.png?raw=true "Selecting a state with a UIPickerView")

After tapping "Tap here when you are done selecting the state", the `UIPickerView` disappears and the button's text changes to the selection that was made. The user can press the button again and the `UIPickerView` will appear again.

![3_MiraclePill_After_Selecting_State.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/MiraclePill/3_MiraclePill_After_Selecting_State.png?raw=true "After selecting a state with a UIPickerView")

Another key change that I made was pushing up the content on the screen so that the keyboard does not cover up the the `UITextField` that the user is editing.

![4_MiraclePill_Keyboard_Would_Cover_Bottom_Text_Fields.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/MiraclePill/4_MiraclePill_Keyboard_Would_Cover_Bottom_Text_Fields.png?raw=true "The text fields on the bottom")

This was especially problematic for the "ZIP CODE" and "QUANTITY" fields, but I added code in the following functions in [`ViewController.swift`](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/MiraclePill/MiraclePill/ViewController.swift) in order to move the content out of the way:

1. Last two lines of `override func viewDidLoad()`
2. `func keyboardWillShow(_ notification: NSNotification)`
3. `func keyboardWillBeHidden(_ notification: NSNotification)`
4. `@IBAction func editingDidBegin(_ sender: UITextField)`

![5_MiraclePill_But_Bottom_Content_Is_Moved.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/MiraclePill/5_MiraclePill_But_Bottom_Content_Is_Moved.png?raw=true "Bottom content moved in order for the keyboard to fit on the screen.")

Lastly, after _all_ the `UITextField`s are filled out, and after some minor error checking, which is done in `@IBAction func buyNowButtonPressed(_ sender: UIButton)` in [`ViewController.swift`](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/MiraclePill/MiraclePill/ViewController.swift), all the components on the screen disappear, and the success indicator is displayed _so long as_ all the error checks passed. Note that this error checking is something I added; it was not something that was covered in the course's videos.

![6_MiraclePill_Success_Indicator.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/MiraclePill/6_MiraclePill_Success_Indicator.png?raw=true "Success indicator shown")

### Summary of differences between the course's version and _my_ version of the Miracle Pill app.

- All of the views are embedded inside a `UIScrollView`.

- Instead of creating an array of states, and then having those states appear in the `UIPickerView`, I made a [`.txt`](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/MiraclePill/MiraclePill/states.txt) file containing all the states and their two-letter abbreviations. This file is then read, and an array of states is created and displayed in the `UIPickerView`.

- I pushed up the content on the screen so that the keyboard does not cover up the the `UITextField` that the user is editing. This was especially problematic for the "ZIP CODE" and "QUANTITY" fields at the bottom of the `UIScrollView`.

- After _all_ the `UITextField`s are filled out, and after some minor error checking, all the components on the screen disappear, and the success indicator is displayed _so long as_ all the error checks passed.

## `PageTheScroll`

In this directory is the source code for the application that officially introduced us to `UIScrollView`s. In this app, we display three different courses that you can take in a _horizontal_ `UIScrollView` (although, tapping on any of the icons does nothing).

![1_PageTheScroll_iOS_Option.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/PageTheScroll/1_PageTheScroll_iOS_Option.png?raw=true)
![2_PageTheScroll_Android_Option.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/PageTheScroll/2_PageTheScroll_Android_Option.png?raw=true)
![3_PageTheScroll_Angular_Option.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/PageTheScroll/3_PageTheScroll_Angular_Option.png?raw=true)

## `RetroCalculator`

In this directory is the source code for another application that introduced us to Stack Views, how to play sounds, and how to add a launch screen. Because this app launches very quickly, the screenshot I have of the launch screen is one from Xcode's Interface Builder, and not from the iPhone Simulator or my iPhone.

![RetroCalculator_Splash_Screen.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/RetroCalculator/RetroCalculator_Splash_Screen.png?raw=true "Retro Calculator's splash screen shown in Xcode's Interface Builder.")

When the app launches, this is displayed.

![RetroCalculator.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/RetroCalculator/RetroCalculator.png?raw=true "The Retro Calculator")

The buttons are embedded inside of Stack Views, and each time a button is pressed, [a sound is played](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/RetroCalculator/RetroCalculator/btn.wav).

A key difference between the course's version of this app and my version of this app is that my version of the app contains [`CalculatorBrain.swift`](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/RetroCalculator/RetroCalculator/CalculatorBrain.swift) and their version of the app does not. The idea of using a "`CalculatorBrain`" was taken from [Stanford University's iOS 9 course videos taught by Paul Hegarty](https://www.youtube.com/watch?v=j50mPzDMWVQ), and was implemented here in order to follow the Model-View-Controller design paradigm. In this instance, following the Model-View-Controller design paradigm is to separate the controller ([`ViewController.swift`](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/RetroCalculator/RetroCalculator/ViewController.swift)) and the model ([`CalculatorBrain.swift`](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/RetroCalculator/RetroCalculator/CalculatorBrain.swift)), not to combine them in [`ViewController.swift`](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/RetroCalculator/RetroCalculator/ViewController.swift) like the [iOS 10 and Swift 3 course](https://www.udemy.com/devslopes-ios10/) did.

## `PartyRock`

In this directory is the source code for an application that introduced us to table views, table cells, segues, and how to embed YouTube videos in an iOS app through a web view. This app was originally a fan app for the band Party Rock, but I decided to change it to an app that promoted one of my favorite bands, ONE OK ROCK. The "TOP VIDEOS" section of the app is the only section of the app that functions, but it displays some my favorite music videos from ONE OK ROCK.

![PartyRock_Main_Screen.PNG](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/PartyRock/PartyRock_Main_Screen.PNG?raw=true "Party Rock app's main screen")

After selecting a music video, a segue takes the user to a screen displaying an embedded YouTube video in a web view. Pressing the "BACK" button will take the user back to the previous screen.

One of the things that was not mentioned in the course's videos was how to make the iframe of the embedded video fit on the iPhone's screen. After some research, I was able to perform this. For more information on how this was performed, see [`videoEmbed.html`](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/PartyRock/PartyRock/videoEmbed.html),the `videoURL` computed property in  [`VideoInformation.swift`](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/PartyRock/PartyRock/VideoInformation.swift), and the last two lines of the `viewDidLoad()` function in  [`VideoVC.swift`](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/PartyRock/PartyRock/VideoVC.swift).

![PartyRock_Video_Screen.PNG](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/PartyRock/PartyRock_Video_Screen.PNG?raw=true "Party Rock app's video screen")

## `AutoLayout`

This was the last application developed in Section 4 of the course. This was a simple exercise to get us used to various size classes in Xcode's Interface Builder. As shown in the screenshots of Interface Builder below, there is a blue rectangle, a yellow square, and a red square. The position and whether or not the shapes appear depends on the device (i.e., the size class) in question. I set up the views so that they follow the following rules.

| Device | Orientation | Shape          | Is shown? | Position     |
| ------ | ----------- | -------------- | --------- | -------------|
| iPhone | Portrait    | Blue Rectangle | Yes       | Top          |
| iPhone | Portrait    | Red Square     | Yes       | Bottom Right |
| iPhone | Portrait    | Yellow Square  | Yes       | Bottom Left  |
| iPhone | Landscape   | Blue Rectangle | Yes       | Top          |
| iPhone | Landscape   | Red Square     | Yes       | Bottom Left  |
| iPhone | Landscape   | Yellow Square  | Yes       | Bottom Right |
| iPad   | Portrait    | Blue Rectangle | No        | N/A          |
| iPad   | Portrait    | Red Square     | Yes       | Bottom Right |
| iPad   | Portrait    | Yellow Square  | Yes       | Bottom Left  |
| iPad   | Landscape   | Blue Rectangle | No        | N/A          |
| iPad   | Landscape   | Red Square     | Yes       | Bottom Right |
| iPad   | Landscape   | Yellow Square  | Yes       | Bottom Left  |

Let us break this down. In the screenshot below of an iPhone in portrait mode, there is a blue rectangle on the top, a red square on the bottom right, and a yellow square on the bottom left.

![AutoLayout_iPhone_Portrait.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/AutoLayout/AutoLayout_iPhone_Portrait.png?raw=true "iPhone Portrait")

<center>_The app on an iPhone in portrait in Interface Builder._</center><newline/>

However, when an iPhone is in landscape mode, the positions of the yellow and red squares are swapped.

![AutoLayout_iPhone_Landscape.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/AutoLayout/AutoLayout_iPhone_Landscape.png?raw=true "iPhone Landscape")

<center>_The app on an iPhone in landscape in Interface Builder._</center><newline/>

For iPads _in portrait and in landscape mode_, the blue rectangle is not shown, the yellow square is on the bottom left, and the red square is on the bottom right.

![AutoLayout_iPhone_Portrait.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/AutoLayout/AutoLayout_iPad_Portrait.png?raw=true "iPad Portrait")

<center>_The app on an iPad in portrait in Interface Builder._</center><newline/>

![AutoLayout_iPhone_Landscape.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_4/screenshots/AutoLayout/AutoLayout_iPad_Landscape.png?raw=true "iPad Landscape")

<center>_The app on an iPad in landscape in Interface Builder._</center><newline/>
