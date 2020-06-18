# AWS Amplify DataStore - Cash Flow App
A tutorial focused on building an app that allows the user to track their cash flow by adding and subtracting currency amounts from their total balance. **AWS Amplify DataStore** is used to persist the user's account balance between sessions.
![App Screenshot](assets/app-screenshot.png | height=300)

### Topics we'll be covering
- Configuring AWS Amplify
- Simple GraphQL data modeling
- Using AWS Amplify DataStore as a persistence layer
  - Cread
  - Read
  - Update

### Configuring the project
Create a new Single View App.
<img src="assets/single-view-app.png" alt="Single View App" height=300)>

Name the project whatever you would like; I will be using the name `Cash-Flow`.
> **Note**
> It is strongly recommended that your project name does not contain spaces as this could cause complications with **Amplify** as well as any other dependencies you decide to add to the project.

![Project Options](assets/project-options.png | height=300)
In this tutorial, we will be using **SwiftUI**.

### Laying out the UI
If we examine the UI that we are trying to build, we can see that it is made up of several `VStack` views (shown in shades of blue) and an `HStack` view (shown in orange). We also have some `Spacer` views (shown in black) that help align our content towards the top of the screen.
![UI Breakdown](assets/app-screenshot-ui-breakdown.png | height=300)

Let's start building this out in code, starting with each of the stacks views we will be using. In the `body` property of `ContentView.swift`, add the following:
```swift
var body: some View {
    // 1
    VStack {

        // 2
        Spacer()
            .frame(height: 50)
        
        // 3
        VStack {
            Text("Current Balance")
                .fontWeight(.medium)
            
            Text("$0.00")
                .font(.system(size: 60))
        }
        
        // 4
        Spacer()
    }
}
```
1. The `VStack` that will hold all the content on our screen.
2. A `Spacer` that adds 50px of space from the top of the screen.
3. The `VStack` that groups together the "Current Balance" `Text` view and another `Text` view that will be responsible for displaying the dynamic account balance. We are using "$0.00" as a placeholder for now.
4. Another `Spacer` responsible for pushing the content towards the top of the screen.
![Current Balance](assets/app-screenshot-current-balance.png | height=300)

Next, let's add the `VStack` that is responsible for holding the interactable views (`TextField` and two `Button` views). This will be below the `VStack` holding the Current Balance `Text` view value and above the bottom `Spacer`.
```swift
... // Current balance VStack

// 1
Spacer()
    .frame(height: 150)

// 2
VStack(spacing: 20) {

    // 3
    VStack {
        Text("Transaction Amount")
            .fontWeight(.medium)

        // 4
        TextField("Amount", text: amountFormatterBinding)
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .keyboardType(.decimalPad)
    }

    // 5
    HStack(spacing: 50) {
        Button(action: {}, label: {
            Image(systemName: "plus")
                .padding()
                .background(Color.green)
                .clipShape(Circle())
                .font(.largeTitle)
                .foregroundColor(.white)
        })

        Button(action: {}, label: {
            Image(systemName: "minus")
                .padding()
                .background(Color.red)
                .clipShape(Circle())
                .font(.largeTitle)
                .foregroundColor(.white)
        })
    }
}

... // Bottom Spacer
```
1. Add some padding between the Current Balance `VStack`.
2. We have setup a new `VStack` that is adding 20px of spacing between each of its children. In this case, the `VStack` only has two children, another `VStack` and a `HStack`.
3. This `VStack` will group our `Text` view and `TextField` together.
4. We are creating a `TextField` that will be binding its text to a property called `amountFormatterBinding` which we have not defined yet.
5. The `HStack` will group our two circular buttons together. The green plus button will be used to add the amount to the balance and the red minus button will subtract the amount from the balance. We will provide the actions soon.

In step 3 above, we used a property called `amountFormatterBinding` which hasn't been defined yet. `amountFormatterBinding` will be responsible for setting the entered text to a `Double` as well as getting the `Double` and converting that to a currency formatted `String`. This means we will need to have a stored `@State` property for our `Double` value as well as a `NumberFormatter` to handle the conversion between `String` and `Double`

Add the following at the above the `body` property in `ContentView`:
```swift
... // struct ContentView

// 1
@State var amount: Double = 0.00

// 2
private let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
}()

// 3
var amountFormatterBinding: Binding<String> {
    Binding<String>(
        get: {
            self.currencyFormatter
                .string(from: NSNumber(value: self.amount))
                ?? ""
        },
        set: { newAmount in
            self.amount = self.currencyFormatter.number(from: newAmount)?
                .doubleValue
                ?? 0
        }
    )
}

... // var body
```
1. Our stored `@State` property which will hold the `Double` value of the amount to be applied towards the balance. (Note: This specific value will always be positive)
2. A `NumberFormatter` configured to format numbers as currency.
3. We are creating a `Binding<String>` by reading from `self.amount` (defined in step 1) as a currency formatted `String` and setting the `newAmount` as a number from the currency formatted `String`.

> **Note**
> We are forced to manually create `amountFormatterBinding` because we need `amount` to be updated as the user types, but using something like `TextField(_ title: StringProtocol, value: Binding<T>, formatter: Formatter)` will only update `amount` whenever the user taps the `Return` key on the keyboard, which a `.decimalPad` does not have.

Our UI layout is complete at this point:
![Finished UI](assets/app-screenshot-finished-ui.png | height=300)

Let's finish up the basics by simply creating the `add()` and `subtract()` methods which can be set as the actions for our buttons. Below the `body` property and before the `ContentView` closing brace, add the following:
```swift
... // body closing }

// 1
func resetAmount() {
    amount = 0
}

// 2
func add() {
    resetAmount()
}

func subtract() {
    resetAmount()
}

... // ContentView closing }
```
1. This will be used to zero out the amount after it has been applied to the account balance.
2. We have two very similar functions, one to add to the account balance and the other to subtract from it. After either action, we will need to reset the amount to avoid duplicated transactions.