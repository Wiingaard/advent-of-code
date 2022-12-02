# Advent of Code 2022

## Hey 👋

I'll attempt to solve the Advent of Code 2022 by using [Swift](https://www.swift.org/)

To get started using Swift is easy. We all have it preinstalled on out mac computers, so no initial setup is needed.

## Run this code

To try out any of the solutions youself, do the following:

1. Checkout this repo
2. Navigate to a certain day, fx. open Day one by running `cd 1`.
3. Run the swift code by specifing the target of that day like this: `swift run CalorieCounting`. The target name is found in `Package.swift` -> exectable target name.

## Initialize a new day

Each day is defined by a Swift Package.

1. Make a new dir for the day: `mkdir 24 && cd 24`
2. Create a new package: `swift package init --name SomePackageName --type executable`
3. Edit the source code found in `Sources/SomePackageName/SomePackageName.swift`
4. Run the code: `swift run SomePackageName`. Or you can run through Xcode by setting _"My Mac"_ and run _Product -> Destination_, and then hitting `Run`
