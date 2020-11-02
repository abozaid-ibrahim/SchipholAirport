# SchipholApp

## Building And Running The Project (Requirements)
* Swift 5.0+
* Xcode 11.5+
* iOS 11.0+

# Getting Started
- If this is your first time encountering swift/ios development, please follow [the instructions](https://developer.apple.com/support/xcode/) to setup Xcode and Swift on your Mac.
- To setup cocoapods for dependency management, make use of [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started)

## Setup Configs
- Checkout master branch to run latest version
- Open the terminal and navigate to the project root directory.
- Make sure you have cocoapods setup, then run: pod install
- Open the project by double clicking the `SchipholApp.xcworkspace` file
- Select the build scheme which can be found right after the stop button on the top left of the IDE
- [Command(cmd)] + R - Run app
```
// App Settings
APP_NAME = SchipholApp
PRODUCT_BUNDLE_IDENTIFIER = abozaid.SchipholApp

#targets:
* SchipholApp
* SchipholAppTests

```

# Build and or run application by doing:
* Select the build scheme which can be found right after the stop button on the top left of the IDE
* [Command(cmd)] + B - Build app
* [Command(cmd)] + R - Run app

## Architecture
This application uses the Model-View-ViewModel (refered to as MVVM) UI architecture,


## Structure

### SupportingFiles
- Group app shared fils, like appDelegate, Assets, Info.plist, ...etc

### Modules
- Include seperate modules, Network, Extensions, ...etc.

### Scenes
- Group of app scenes.

### Points to improve:
- Improve code coverage
- Revisit the UI
- Change langauge switcher button.
- Highlight the two airports on the map that are the furthest away from each other
- Meter / mile button switcher.

#### screen shots:

![Airelines (dark) scene](https://github.com/abuzeid-ibrahim/SchipholAirport/blob/master/SchipholApp/Screenshots/airlines_dark.png?raw=true)
![Airports (dark) scene](https://github.com/abuzeid-ibrahim/SchipholAirport/blob/master/SchipholApp/Screenshots/airports_dark.png?raw=true)
![Map (dark) scene](https://github.com/abuzeid-ibrahim/SchipholAirport/blob/master/SchipholApp/Screenshots/map_dark.png?raw=true)
![Details (dark) scene](https://github.com/abuzeid-ibrahim/SchipholAirport/blob/master/SchipholApp/Screenshots/details_dark.png?raw=true)

![Airports scene](https://github.com/abuzeid-ibrahim/SchipholAirport/blob/master/SchipholApp/Screenshots/airports_light.png?raw=true)
![Map scene](https://github.com/abuzeid-ibrahim/SchipholAirport/blob/master/SchipholApp/Screenshots/map_light.png?raw=true)
![Details scene](https://github.com/abuzeid-ibrahim/SchipholAirport/blob/master/SchipholApp/Screenshots/details_light.png?raw=true)
