# AWS Amplify DataStore - Cash Flow App
A tutorial focused on building an app that allows the user to track their cash flow by adding and subtracting currency amounts from their total balance. **AWS Amplify DataStore** is used to persist the user's account balance between sessions.
![App Screenshot](assets/app-screenshot.png)

### Topics we'll be covering
- Configuring AWS Amplify
- Simple GraphQL data modeling
- Using AWS Amplify DataStore as a persistence layer
  - Cread
  - Read
  - Update

### Configuring the project
Create a new Single View App.
![Single View App](assets/single-view-app.png)

Name the project whatever you would like; I will be using the name `Cash-Flow`.
> **Note**
> It is strongly recommended that your project name does not contain spaces as this could cause complications with **Amplify** as well as any other dependencies you decide to add to the project.
![Project Options](assets/project-options.png)
In this tutorial, we will be using **SwiftUI**.

### Laying out the UI
If we examine the UI that we are trying to build, we can see that it is made up of several `VStack` views (shown in shades of blue) and an `HStack` view (shown in orange). We also have some `Spacer` views (shown in black) that help align our content towards the top of the screen.
![UI Breakdown](assets/app-screenshot-ui-breakdown.png)

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



