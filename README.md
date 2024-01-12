# Swipe Assignment
Written in Flutter with MVVM Architecture using Providers for clean code and Floor for LocalDB and Caching.  
- APK can be found in the [link here](https://drive.google.com/drive/folders/1KknZjZ_KY4oLMdD1pe7f3GoPPzIiDjGu?usp=drive_link)  

## Features
- Uses [Provider](https://pub.dev/packages/provider) & MVVM type structure for State Management 
- Fetches Data from API and creates a Cache of the same using [Floor](https://pub.dev/packages/floor)
- Checks if the user is connected to the internet or not using [connectivity_plus](https://pub.dev/packages/connectivity_plus) and provides real-time feedback.
- Integrates a simple `SearchBar` to search for entries in the Product List.
- Uses [ImagePicker](https://pub.dev/packages/image_picker) and [ImageCropper](https://pub.dev/packages/image_cropper) to pick multiple Images from Gallery and crop them in [1:1] Aspect Ratio
- Uses [HTTP Plugin](https://pub.dev/packages/http) to send different API calls and also to make MultiPath call to upload Files to the backend 
- Uses [Material 3](https://m3.material.io) UI components to provide both Dark/Light Theme capabilities with a click of a button.

## Project Setup
Clone the repo in a suitable folder
> git clone "https://github.com/DGgrx/Swipe_Assignment"

Make sure you have the [Flutter](https://flutter.dev) & [Dart SDK](https://dart.dev/get-dart) installed on your system by running flutter doctor
> flutter doctor

Once flutter is installed correctly run these commands
> flutter pub get

> flutter run

Run these 2 commands on the terminal to launch the app in debug mode on either an AVD(Android Virtual Device) or a physical device of your choice.

For any queries, [mail me @ divyanshgarg.divs@gmail.com](mail-to:divyanshgarg.divs@gmail.com) 

Made with ♥ by Divyansh
