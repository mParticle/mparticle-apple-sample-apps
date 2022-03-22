<img src="https://static.mparticle.com/sdk/mp_logo_black.svg" width="280"><br>

![Swift](https://badgen.net/badge/Built%20With/Swift/blue)

# The Higgs Shop Sample App

The Higgs Shop is an example app that implements the mParticle Apple SDK to highlight the features and implementation details of mParticle for iOS.

The purpose of the app is to highlight the following features:

-   Creating an instance of the mParticle Apple SDK
-   Setting up an optimal mParticle configuration with debugging enabled
-   Sending Events and Custom Attributes to mParticle

## Getting Started

1. Open `HiggsShopSampleApp.xcodeproj` in Xcode

2. Dependencies will automatically be updated by Swift Package Manager

3. In the `HiggsShopSampleApp` scheme, update the `MPARTICLE_KEY` and `MPARTICLE_SECRET` environment variables from `REPLACEME` to your your mParticle iOS API Key and secret.

-   Visit your [mParticle Workspace](https://app.mparticle.com/setup/inputs/apps) to generate API Credentials

4. Run the project using the `Command-R`

This will spawn a simulator and open the Higgs Shop Sample App.

### API Credentials

**NOTE** These Sample Apps require a mParticle account with an API key and Secret.

While the code might run and build without mParticle credentials, the SDKs will not upload events to our servers and will generate errors.

Please visit https://docs.mparticle.com/ for more details on setting up an API Key.

## Events used in this app

To make things simple yet declarative, this application has been built in such a way to keep event tracking close to the components that might logically trigger them rather than a fully DRY implementation. We've opted to be more repetitive so examples are consise and documented as necessary.

Please feel free to also visit our [Doc Site](https://docs.mparticle.com/) to gain more familiarity with some of the more advanced features of mParticle.

### Screen Views

In cases where it is necessary to track visitors as they navigate your iOS Application, mParticle offers [Screen Tracking](https://docs.mparticle.com/developers/sdk/ios/screen-tracking/).

In this Sample App, screen views each fire a single _Screen View_ when the component is rendered.

For example

```swift
// Renders an initial cart view when the screen loads
MParticle.sharedInstance().logScreen("View My Cart", eventInfo: ["number_of_products": numberOfProducts, "total_product_amounts": subTotal])
```

In some cases, we fire a _Commerce Event_ instead of a _Screen View_ to track more e-Commerce related attributes.

### Custom Events

Most often, you will need to use [Custom Events](https://docs.mparticle.com/developers/sdk/ios/event-tracking/#custom-events) to track events in a way that is unique to your use case. mParticle provides types of _Custom Events_ ranging from Navigation Events to Social Media Engagement and are mostly used to organize your data in a way that makes sense to you.

Many of our views make use of these events, for example, in the `LandingViewController` Component.

```swift
// Logs an event to signify that the user clicked on a button
if let event = MPEvent(name: "Landing Button Click", type: .other) {
    MParticle.sharedInstance().logEvent(event)
}
```

### Commerce Events

This Sample App emulates a simple e-Commerce application and makes heavy use of mParticle's [Commerce Events](https://docs.mparticle.com/developers/sdk/ios/commerce-tracking/).

Some events used in this application:

-   Add To Cart
-   Remove From Cart
-   Product Detail
-   Product Impression
-   Checkout
-   Purchase

Most _Commerce Events_ follow a similar pattern, requiring that you first generate an **mParticle Product** Object, which then gets passed into the `MPCommerceEvent` object.

You should map your own product attributes to be consistent with your [Data Plan](https://docs.mparticle.com/guides/data-master/introduction/) if you are leveraging that feature. Using Data Plans ensures data consistency within an app and across devices.

```swift
let mpProduct = MPProduct(name: name, sku: sku, quantity: quantity, price: price)
mpProduct.setUserDefinedAttributes(productAttributes)

let event = MPCommerceEvent.init(action: .addToCart, product: mpProduct)
MParticle.sharedInstance().logEvent(event)
```

Most Commerce Events are used within the following components:

-   `/HiggsShopSampleApp/ProductDetailViewController.swift`
-   `/HiggsShopSampleApp/CartViewController.swift`
-   `/HiggsShopSampleApp/CheckoutViewController.swift`

## Discovering Events

As a developer, sometimes the best way to learn is to just dig into the code or your debugging tools. To that end, this sample app ships verbose logging turned on, so that you can view details of what our SDK is doing within Xcode's console.

### Live Stream

To verify that your events have arrived at mParticle's servers, or to compare your iOS Events to those of our other SDKs, you can also visit our [Live Stream](https://docs.mparticle.com/guides/platform-guide/live-stream/).

This will not only show your data as it enters mParticle, but also as your data is forwarded to our various partner services and integrations (if enabled).

## Development Notes

This project uses [SnapKit](https://snapkit.io/) to simplify AutoLayout constraints.

We also use [SwiftLint](https://github.com/realm/SwiftLint) to format code automatically using `swiftlint --fix`.

Linting will be run as a build phase during Xcode builds if SwiftLint is installed. It's not required to have swiftlint installed for testing the Sample Apps, but you can install it if desired by running `brew install swiftlint`.

This can be helpful if you want to submit a Pull Request so you are aware of any potential lint issues before they are flagged by CI.

## Support

<support@mparticle.com>

## License

The mParticle Apple SDK is available under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0). See the LICENSE file for more info.
