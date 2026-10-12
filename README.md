# Kleep
 
## Supported OS & SDK Versions
- Supported build target - iOS 15+


## Installation

This process needs to be followed only once, the first time you need to install the SDK in your project. Please refer to the Update section to see the instructions for subsequent updates.


**Step 1:** Open your existing project.

**Step 2:** Go to your Package Dependencies section

**Step 3:** Click on plus(+) button dialog will be open and Enter below package URL in the search box:

URL: https://github.com/KlipFit/kleep-spm

**Step 4:** Change dependency rule to: up to next major version : 4.3.0

**Step 5:** Make sure Klipflit product is ticked and click on Add Package

## Permissions

Add the following permission to your project on info.plist: **NSCameraUsageDescription**

## Usage

**###  SwiftUI  ###**

*Step 1:*
In your ContentView

```swift
import Klipfit

struct ContentView: View {
    @State var isOpenView = false
        
    var body: some View {
        VStack {
            Spacer()
            Button("Open Kleep") {
                isOpenView = true
            }
            Spacer(minLength: 40)
            
            Button("obtenir la taille") {
                Klipfit.shared.requestSize(productID: String, retailerName: String, trackingID: "", customerID: "") { kleepResult in
                    switch kleepResult {
                    case .notSupported:
                            // Hide CTA
                        print("NotSupported")
                    case .noRecommendationYet:
                            // Display CTA with neutral label
                        print("NoRecommendationYet")
                    case .recommendationFound(let result):
                            // Display CTA with size reco
                        print("RecommendationFound: ", result)
                    }
                }
            }
            Spacer()
        }
        .sheet(isPresented: $isOpenView) {
            KlipFitFindSizeView { result, variantID in 
                 // addToCart(variantID)
            }
        }
    }
}
``` 

*Step 2:*
Create structure to convert to view Representable
```swift
struct KlipFitFindSizeView: UIViewControllerRepresentable {
        
    public var onResult: KleepOnResultCompletion

    func makeUIViewController(context: Context) -> KlipftNavigationController {
        guard let viewController =
        KlipftNavigationController.loadView(
                productID: String,
                retailerName: String,
                language: KleepLanguageCode,
                trackingID: "",
                customerID: "",
                stocks: [String : Bool]?,
                onResult: onResult
        )
        else {
            fatalError("ViewController not implemented in storyboard")
        }
        return viewController
    }
    func updateUIViewController(_ uiViewController: KlipftNavigationController, context: Context) {
    }
    typealias UIViewControllerType = KlipftNavigationController
}

```

### Presentation

Present the size guide the way you like: `.sheet` in SwiftUI, or `.pageSheet`, `.fullScreen` or `.overFullScreen` in UIKit, including on top of another modal. The size guide stays inside the safe area and draws its own navigation bar (back and close), so there is nothing to hide or configure.

### Add to cart

When the user taps "Add to cart", the SDK calls `onResult(size, variantID)` and then closes the size guide. It does not add anything to the cart itself: your app does, in `onResult`.

- `size` is the size label shown to the user, e.g. `"M"` or `"38"`.
- `variantID` is the ID of the selected variant in your catalog, as Kleep imports it. For Shopify stores it is the numeric variant ID: the Storefront API expects `gid://shopify/ProductVariant/<variantID>`. It is an empty string if the variant has no ID in Kleep.
- The size guide is being dismissed when `onResult` is called. Show any cart confirmation once the dismissal is over: presented on top of the size guide it is dismissed with it, and presented from the screen that shows the size guide it fails, because that screen is still presenting.

