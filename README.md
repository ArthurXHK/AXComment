# AXComment

A better comment command in Xcode. 

It is created with learning Session 414 "Using and Extending the Xcode Source Editor" in WWDC 2016.

Please **`star`** it, if you like it. Or create issues and tell me how to improve it.

Thank you!

## Why?

I hate the native comment command in Xcode!!

Do you meet this situation?

``` swift
class TmpClass: NSObject {
    func tmpFunc() -> Void {
        print("Hello world!")
    }
}
```

when you use the native comment command, it will works like this:

``` swift
class TmpClass: NSObject {
    func tmpFunc() -> Void {
//        print("Hello world!")
    }
}
```

***BUT*** after you use `Re-Indent` command, it will become like this:

``` swift
class TmpClass: NSObject {
    func tmpFunc() -> Void {
        //        print("Hello world!")
    }
}
```

***WTF!!!!!***

## How this better comment command works?

It can work **MUCH BETTER!!**

``` swift
class TmpClass: NSObject {
    func tmpFunc() -> Void {
        // print("Hello world!")
    }
}
```

It also works well in this case!!

``` swift
class TmpClass: NSObject {
    // func tmpFunc() -> Void {
    //     print("Hello world!")
    // }
}
```

You can bind it with the short-cut `Command+/` as you usually use.

## Requirements

-   Xcode 8
-   Swift 3.0

## Author

Arthur XU, arthurk.dev@gmail.com

## License

AXRegex is available under the Apache License 2.0. See the LICENSE file for more info.

