# NDCalc

## Overview
NDCalc is a simple calculator that will convert shutter speeds for differant strengths of netural density filters. For example using a 2 stop ND filter on a scene that normally needs a 3 second exposure will result in 12 second exposure. The app allows you to start a timer with the chosen exposure time and will alert you when it is finished. The app also support multiple differant ranges of shutter speeds used by differant camera makers.

![exposure select screenshot](https://github.com/TheTrexDev/NDCalc/blob/main/Screenshots/githubScreenshot.png)

## Key technologies used
### SwiftUI
Almost the entire interface of the app was built using SwiftUI(with the exception of the mail view which currently isn't possible). While it was probably overkill given the small size of the application I built it using the MVVM architecture including having all view models and controller objects 

### Local notifications
Often some exposures can end up being quite long, upwards of several minutes and in this case it is likely that a user might lock their phone. So that they are still notifified I use local notifications to schedule a notification to alert the user. I am also supporting the new focus modes introduced in iOS15.

### Combine
Using Combine and MVVM with SwiftUI is a natural fit, as well as this I have found that a good architecture is to have controller have a small number of published varibles that views and viewmodels can subscribe to. An example of this can be seen with how the CountdownController publishes a Countdown object that the home view view model subscirbes to.
