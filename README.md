# Here in my Fridge
**Here in my Fridge** was created as a technical challenge for Vanderbilt's Change++ Student Organization. 

## Challenge Description
Change++ is working with a non-profit that helps families save time and money on grocery shopping and meal prep. The company is looking for an application that should accomplish the following mission:

Given a list of ingredients that a user has in their fridge, return a list of recipe names for them to make, along with a “shopping list” of ingredients they are missing for each recipe.

## Application Description
Users may enter the contents of their 'fridge,' then search for recipes containing the aforementioned ingredients. The application queries against [Spoonacular](http://spoonacular.com/food-api "Spoonacular")'s API to search for said recipes, then generates a 'Shopping List' based on what ingredients the user already has.

#### Shopping Lists
Shopping lists are generated according to what ingredients the user does not have in their Fridge. In addition, even if the user has an ingredient in their fridge, it will be added to the shopping list if the user does not possess a sufficient amount.

#### Dependencies
Here in my Fridge uses CocoaPods as a dependency manager, plus multiple libraries to manage core features including state preservation and networking. Key dependencies are described below.

[**Moya**](https://github.com/Moya/Moya "**Moya**"): Simple networking abstraction layer, built on top of Alamofire.

[**SwiftyJSON**](https://github.com/SwiftyJSON/SwiftyJSON "**SwiftyJSON**"): Swift native parsing and management of JSON objects.

[**Realm**](https://realm.io "**Realm**"): Local object-oriented database for saving and restoring listed user data.

## Installation
Here in my Fridge requires XCode to run. First clone the project. Next, [install Cocoapods](https://guides.cocoapods.org/using/getting-started.html). Navigate to the project directory then execute `pod install` on the command line. Finally, find the project directory and open the `.xcworkspace` file. **DO NOT OPEN THE `.xcodeproj` FILE. DEPENDENCIES WILL NOT BE PROPERLY INSTALLED.** Build and run on an iOS Device or Simulator using iOS 10.0+
