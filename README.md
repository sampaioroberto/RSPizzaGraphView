# RSPizzaGraphView

This library provides a nice pizza graph view. it was made for developers who wants a better UI for their apps!

# Installation

## From CocoaPods
RSPizzaGraphView is available through [CocoaPods](https://cocoapods.org/). To install
it, simply add the following line to your Podfile:

    pod "RSPizzaGraphView"
    
## Manually
Copy the source file RSPizzaGraphView into your project.

# Usage

RSPizzaGraphView is a UIView. So, you can create a UIView in the InterfaceBuilder and use it as an @IBOutlet,
or you can create it manually. If you wanna use as an @IBOutlet, does not forget to set RSPizzaGraphView as the Custom Class 
of your UIView in the Interface Builder.

You need to have some values and colors in order to configure your graph. You will use the RSPizzaGraph class.
You can configure the values of graph like this code, for example: 

```swift
     let graphs = [RSPizzaGraph(value: 50, color: UIColor.red),
                  RSPizzaGraph(value: 15, color: UIColor.blue),
                  RSPizzaGraph(value: 23, color: UIColor.yellow),
                  RSPizzaGraph(value: 30, color: UIColor.black),
                  RSPizzaGraph(value: 20, color: UIColor.darkGray)]
```

The size of each slice will be calculated according the value. You can choose any color you want. Choose the nice ones! :)

You just need to call one function to configure the RSPizzaGraphView. This function have three required parameters. 
The others are optionals. Assuming you already have a initialized RSPizzaGraphView, 
you can call the function like this code below:

```swift
    pizzaGraphView.configureGraph(borderWidth: 150, 
    graphs: graphs, 
    animation: .circular, 
    shouldShowText: true, 
    font: UIFont.systemFont(ofSize: 15), 
    textColor: UIColor.white, 
    unityText: "pt")
```

* **borderWidth**: While the width of the view is the width of all RSPizzaGraphView, 
the border width is the width of the colored border.
* **graphs**: The array of RSPizzaGraph, like explained above.
* **animation**: The type of the animation. It is a enum called RSPizzaGraphAnimation. Can be *.circular* or *.sliceFading*.
* **shouldShowText**: It is a boolean that defines if the pizza graph should show the number values over the graph.
The default value is *false*.
* **font**: The font used in the texts. If shouldShowText is false, it will be useless. 
The default value is *UIFont.systemFont(ofSize: 12)*
* **textColor**: The text color of texts. If shouldShowText is false, it will be useless. 
The default value is *UIColor.black*.
* **unityText**: This text will be showed together the values, in order to define its unity, if necessary. 
The default is *""*.

The parameters **borderWidth**, **graphs** and **animation** are *required*. The other ones are *optionals*.

# Screenshots

Circular animation | SliceFading animation
:-------------------------:|:-------------------------:
<img src="Screenshots/RSPizzaGraphViewCircular.gif" width="400"> | <img src="Screenshots/RSPizzaGraphViewSliceFading.gif" width="400">
