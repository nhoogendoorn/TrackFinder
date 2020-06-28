# TrackFinder

### Introduction
TrackFinder is a simple Spotify track searcher app. It allows users to easily connect to the Spotify API and search and play songs.

For the architecture of the app, I used a pattern similar to MVVM. ViewControllers get their data from ModelControllers, which in their turn can request data from the API through different Services.

All API requests are being send to a special Operation Queue, which can be suspended when there is no active internet connection or the current access token is expired. After both conditions are valid again, the queue will continue to operate.

For this project I didn't use the SwiftUI framework. It was easier to quickly set up a searchbar in UIKit and I didn't want to find out about some surprises while I was building it :). The project I'm currently working on uses SwiftUI from the start, so if you would like to see some of my SwiftUI code, I'm happy to show this to you.

### Used Packages
  - Spotify SDK, used for authorization.
  - SnapKit, for programmatic layout.
  - KingFisher, for retrieving and showing images.
  - SwiftyBeaver, for debug logging.
  - Swinject, for dependency injecting for the Services

### Improvements
  - Fixing the AuthenticationServiceTest, that currently stores a new access and refresh token, making a new build on the same device will make that build unusable.
  - Storing the tokens in the KeyChain instead of UserDefaults.
  - Higher test coverage, this can always be higher :).
  - Making more generic views, for example: standard textlabels.
  - Letting the authentication happen outside of the app environment, so I can remove the secret client id from the project.
