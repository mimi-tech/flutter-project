# Sparks
Create friendships with peers just like you, learn from the knowledgeable, and much more.

### Setting up the various types of registrations
Sparks as a super app is designed to have different features that point to different services a user can enjoy. These services are tried to their various registration. When a user comes into Sparks for the first time, the user is presented with a choice of choosing what kind of account they want. In Sparks, we have four (4) kinds of accounts: 
* Personal account
* School account
* Company account
* Market account

**NB** Please be informed that a user can have all the accounts so that they can enjoy all the benefits that come with having those accounts.

**The code snippets for implementing the various account setup:**
Inside the file called **__personal_reg_1.dart__**, you shall find these code snippets.

**Personal account**
```Dart
//TODO: Go to the second page (Personal Account)
widget.pageController
    .animateToPage(
    widget.currentPage.floor(),
        duration: Duration(
            milliseconds: 500),
    curve: Curves.easeInOut,
);
```

**School account**

Locate this line of code and add your route after it.
```Dart
//TODO: For the school registration, this is your entry point.
///Add your route here
```

**Company account**

Locate this line of code and add your route after it.
```Dart
//TODO: For the company registration, this is your entry point.
///Add your route here
```

**Market account**

Locate this line of code and add your route after it.
```Dart
//TODO: For the market registration, this is your entry point.
///Add your route here
```

**Displaying the home screen after a successful registration.**

To achieve this, we need to go into the file called **__sparks_landing_screen.dart__**.

```Dart
//TODO: Displaying the corresponding screen based on the default account type of the user.
if((sparksUser != null) && (sparksUser.emv == true)) {
    switch (accPrefs.getString("def")) {
    case "Personal":
        numberOfDeviceUsedSoFar(numberOfDevice);
        screen = CreateSparksProfile(accountName: "Personal",);
        break;
    case "School":
        numberOfDeviceUsedSoFar(numberOfDevice);
        //TODO: Initialize screen widget with the right widget
        //screen = Add your home screen for school here.
        break;
    case "Company":
        numberOfDeviceUsedSoFar(numberOfDevice);
        //TODO: Initialize screen widget with the right widget
        //screen = Add your home screen for company here.
        break;
    case "Market":
        numberOfDeviceUsedSoFar(numberOfDevice);
        //TODO: Initialize screen widget with the right widget
        //screen = Add your home screen for market here.
    }
}
```

### Setting up Firebase cloud messaging for Sparks
To handle/implement cloud messaging in Sparks, please go to the dart file **sparks_landing_screen.dart**
```Dart
@override
  void initState() {
    super.initState();

    getDeviceID();

    _firebaseMessaging.configure(
      onBackgroundMessage: myBackgroundHandler,
      onMessage: _firebaseMessagingForegroundHandler,
      onResume: _firebaseMessagingBackgroundHandler,
      onLaunch: _firebaseMessagingBackgroundHandler,
    );
  }
```
The configuration for cloud message is initialized in the **initState** method as shown in the code above.

**_firebaseMessagingForegroundHandler:**

This is the method responsible for handling cloud messages when the app is in the foreground `(i.e. currently being used by the user)`\
**NOTE:** Ensure to add a field of "acct" `(account type)` to your message data payload. This field help identity/delegate the responsibility of handling said message as received **onMessage**
```Dart
Future<dynamic> _firebaseMessagingForegroundHandler(
      Map<String, dynamic> message) async {
    /// NOTE: Add a field "acct" to "data" payload to identify which account the
    /// notification belongs to
    String account = message["data"]["acct"];

    switch (account) {
      case "market":
        MarketMessaging.marketForegroundHandler(message: message);
        break;

      /// Add your different cases here to handle cloud messaging data
    }
  }
```
In the above snippet, the "account" String variable stores the "acct" available in the message payload. A switch statement is used on "account" to switch between the different Sparks account types which are `(Personal, Company, Market and School)`. According to each switch case, the cloud message is handled in their corresponding class.

**_firebaseMessagingBackgroundHandler:**

This is the method responsible for handling cloud messages when the app is in the background and when the app has been terminated.\
**NOTE:** Ensure to add a field of "acct" `(account type)` to your message data payload. This field help identity/delegate the responsibility of handling said message as received **onResume** && **onLaunch**
```Dart
    /// This method is called in the [onResume, & onLaunch] functions of FCM config.
    /// This is the method called when the app is running on the background
    Future<dynamic> _firebaseMessagingBackgroundHandler(
        Map<String, dynamic> message) async {
        String account = message["data"]["acct"];

        switch (account) {
        case "market":
            MarketMessaging.marketBackgroundHandler(message: message);
            break;
        case "Personal":
            HomeMessagingService.homeBackgroundHandler(message);

        /// Add your different cases here to handle cloud messaging data
        }
    }
```
In the above snippet, the "account" String variable stores the "acct" available in the message payload. A switch statement is used on "account" to switch between the different Sparks account types which are `(Personal, Company, Market and School)`. According to each switch case, the cloud message is handled in their corresponding class.\
**Important!:** A Navigation Service is registered as a lazy singleton in a locator service that is set-up using the [getIt package](https://pub.dev/packages/get_it) `(./lib/service_locator.dart)` which is used for navigation in the different Sparks account classes handling the cloud messages
```
