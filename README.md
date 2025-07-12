# 📋 Task Manager App (Flutter)

A simple and modern task management app built using Flutter. Easily create, view, and store your tasks locally using `SharedPreferences`.

---

## 🚀 Features

- Create and save tasks
- Dark and light theme support
- Local data storage (no backend required)
- Fast and responsive UI

- tate Management Explanation (Bloc & Cubit)
  This project uses flutter_bloc for state management. It is built on top of the Stream and Provider package, offering a simple and powerful way to manage app states using both Cubit and Bloc.

🔷 What is Bloc & Cubit?
Cubit: A lightweight way to manage state using emit() with a single state.
Bloc: More structured, uses Events and States separately — great for complex flows.
In this app, we are using Cubit to manage the app theme (dark/light mode).

---

## 🛠 Setup Instructions

### 1. Clone the Repo

git clone https://github.com/akashkumar7313/Task-Manager-App-Flutter.git
cd Task-Manager-App-Flutter


### 2. Install Packages

flutter pub get


### 3. Run the App

flutter run


## 🛠 Section 2

[!] CocoaPods could not find compatible versions for pod "XYZ"

The error "CocoaPods could not find compatible versions for pod "XYZ"" usually means there's a conflict between the versions of the pod you're trying to use and other dependencies in your project. To resolve this, you can try updating CocoaPods, updating the pod itself, or adjusting the iOS deployment target in your Podfile.
Here's a breakdown of potential solutions:
1. Update CocoaPods:
   Ensure you have the latest version of CocoaPods installed. You can update it using sudo gem install cocoapods. If you're on an Apple Silicon Mac, you might need to run it with Rosetta: sudo arch -x86_64 gem install cocoapods.
2. Update the Pod:
   If the issue is with a specific pod, try updating it individually. In your Podfile, change the version specification (e.g., from 1.2.3 to ~> 1.2.3 or ^1.2.3) to allow for a wider range of compatible versions.
   Run pod update [PODNAME] to update the specific pod, or pod update to update all pods.
3. Adjust iOS Deployment Target:
   Sometimes, the iOS deployment target specified in your Podfile might be too low. Try increasing the target version. For example, change platform :ios, '9.0' to platform :ios, '11.0' in your Podfile.
   After making changes to the Podfile, run pod install.
4. Clean and Reinstall:
   Delete the Pods directory and Podfile.lock file from your project's ios directory.
   Run pod install again to reinstall dependencies with the updated settings.
   If pod install fails, try pod install --repo-update to update the CocoaPods repository and then try again.
5. Check for Corrupted Files:
   If you suspect the Podfile.lock or the Pods directory is corrupted, deleting them and reinstalling can help.
6. Check Ruby Version:
   Ensure that the Ruby version being used by CocoaPods is compatible. If you are using rbenv, verify that it's using the system version, not a specific version set by rbenv.
7. Invalidate Caches:
   If you are using Android Studio, try invalidating caches and restarting it, as caches can sometimes cause issues. 


## 🛠 Explain:

## Q1: What are the common causes of CocoaPods errors during a Flutter iOS build?
CocoaPods errors are commonly caused by:

🔷Incompatible Pod Versions
– Conflicts between a plugin’s required pod version and your current dependencies or iOS deployment target.
– Example: A plugin requires iOS 12.0, but your project is set to iOS 9.0.

🔷Outdated CocoaPods or Pod Repos
– An outdated CocoaPods installation or stale repo cache can fail to resolve pods correctly.

🔷Missing or Corrupted Podfile / Podfile.lock
– If the Podfile.lock is corrupted or out of sync, the iOS build may break.

🔷Incorrect Ruby Environment
– CocoaPods depends on Ruby. Version mismatches, especially on M1/M2 Macs, can cause problems.

🔷Unsupported/Deprecated Plugins
– Using Flutter plugins that no longer support the current Flutter or iOS SDK version.

🔷Invalid or Misconfigured Podfile
– Syntax errors, missing platform line, or incorrect use of targets.


## Q2: What steps would you take to diagnose and fix such issues?
Step 1: Check the Error Message Carefully
Identify the pod that’s causing the issue.

Note whether it’s a version conflict, missing spec, or repo issue.

Step 2: Update CocoaPods and Repos
sudo gem install cocoapods
pod repo update
(M1/M2 Mac: use arch -x86_64 if needed)

Step 3: Adjust Podfile
Open ios/Podfile

Update platform:
platform :ios, '12.0'
Make sure there are no syntax errors or unnecessary constraints.

Step 4: Clean and Reinstall Pods
cd ios
rm -rf Pods Podfile.lock
pod install


Step 5: Update or Relax Pod Version
In Podfile, change strict versioning:

pod 'XYZ', '~> 1.2'  # instead of '1.2.3'
Then:

pod update XYZ


Step 6: Flutter Clean and Rebuild
flutter clean
flutter pub get
cd ios
pod install
flutter run


Step 7: Check Ruby Version (if needed)
ruby -v
which ruby
Use system Ruby or a properly configured version via rbenv.


## Q3: How can you ensure your Flutter iOS environment remains stable and clean?
1. Keep CocoaPods Updated
sudo gem install cocoapods

2. Keep Flutter & Plugins Up-to-Date
flutter upgrade
flutter pub outdated

3. Avoid Locking Pod Versions Too Strictly
Let CocoaPods resolve the latest compatible versions.

4. Use a Compatible iOS Deployment Target
Keep platform :ios, '12.0' or higher (depending on plugins used).

5. Use flutter clean before critical changes
flutter clean
flutter pub get

6. Version Control Podfile/Podfile.lock Properly
Especially if you're collaborating on a team.

7. Maintain Ruby Environment
Use rbenv or asdf to manage Ruby versions.

Avoid broken or partial installations.


## Q4. Correct usage of pod install, pod repo update, flutter clean

## ✅ flutter clean
Purpose:
Removes the build directory and cached files to resolve build issues or clean the project.

🔷When to use:
After adding/removing plugins.
When you're getting unexpected build errors.
Before generating a release build.

🔷Usage:
flutter clean
This deletes:
buld/
.dart_tool/
.packages

iOS Pods (ios/Pods) if run before a new pod install

## ✅ pod install
Purpose:
Installs the CocoaPods dependencies listed in your Podfile.

🔷When to use:
After running flutter clean.
After modifying the Podfile.
After adding new iOS-specific Flutter plugins.

🔷Usage:
cd ios
pod install
Always run this inside the ios/ directory.

## ✅ pod repo update
Purpose:
Updates the local CocoaPods specs repository to get the latest versions of available pods.

🔷When to use:
If pod install gives errors like "Unable to find a specification" or when podspec versions are outdated.
When using a plugin or library that depends on an updated podspec.

🔷Usage:
pod repo update
Then re-run:

pod install


## Q5. Fixes involving Podfile, platform version issues, or Ruby environment conflicts
✅ 1. Fixing Podfile Issues
🔹 Problem: No platform specified / Deployment target too low

Error Example:
[!] CocoaPods could not find compatible versions for pod...
✅ Solution: Set platform version in Podfile
Edit the ios/Podfile:
platform :ios, '12.0'  # Or '13.0', depending on your requirement
Tip: Flutter 3+ often requires 12.0 or higher.

Then run:
cd ios
pod install


✅ 2. Fixing Platform Version Mismatch in Xcode
🔹 Problem: Xcode project target < Podfile target

Error Example:
The iOS deployment target '10.0' is lower than the minimum required by the SDK '12.0'

✅ Solution:
Open ios/Runner.xcworkspace in Xcode.
Select Runner project > Runner target > General tab.
Set Deployment Target to match or exceed the version in your Podfile (e.g., iOS 12.0).


✅ 3. Fixing Ruby Environment Conflicts
🔹 Problem: CocoaPods not working / Ruby version mismatch
Error Example:
zsh: command not found: pod
Your Ruby version is x.x.x, but your Gemfile specifies x.x.x


✅ Solutions:
✅ Install or repair CocoaPods:
sudo gem install cocoapods
⚠️ Use sudo only if using system Ruby. Prefer rbenv or rvm for user-managed Ruby.

✅ If using rbenv (recommended):
brew install rbenv
rbenv install 3.1.2          # or required version
rbenv global 3.1.2
gem install cocoapods


✅ If using rvm:
rvm install ruby-3.1.2
rvm use ruby-3.1.2 --default
gem install cocoapods


✅ 4. Podfile.lock Conflicts / Broken Cache
🔹 Problem: Conflicts or old pod data causing issues


✅ Solution: Clean everything and reinstall pods
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod deintegrate
pod install


✅ 5. M1 / M2 Mac Issues (Apple Silicon)
🔹 Problem: Arch mismatch when running pod install

Error Example:
ffi_c.bundle: mach-o file, but is an incompatible architecture


✅ Solution: Run Terminal in Rosetta (for Intel compatibility):
Find Terminal in Finder → Applications → Utilities.

Right-click > Get Info.

Check "Open using Rosetta".

Then try:
arch -x86_64 sudo gem install ffi
arch -x86_64 pod install
Or install native Apple Silicon pods using native Ruby and proper Homebrew setup.

✅ Recap Script (Safe Recovery Flow)
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod deintegrate
pod install

If errors persist:
pod repo update
pod install


## Q6. Use of M1/M2 Mac-specific fixes if applicable

When encountering issues on an M1 or M2 Mac, it's crucial to apply fixes specific to Apple silicon, as traditional Intel-based solutions may not be effective. These fixes often involve utilizing Rosetta 2 for compatibility with older apps and addressing performance bottlenecks related to unified memory and GPU utilization.
Specific Fixes for M1/M2 Macs:

🔷Rosetta 2:
If you encounter issues with applications not optimized for Apple silicon, Rosetta 2 enables those apps to run on M1/M2 Macs. It translates Intel-based code for the Apple silicon architecture.

🔷Optimizing for Unified Memory:
M1/M2 Macs use unified memory, which can impact performance if applications are not optimized. Ensure your apps are taking advantage of this architecture.

🔷GPU Performance:
The M2 chip offers a faster GPU than the M1. If you're experiencing performance issues with graphically intensive tasks, consider upgrading to an M2 model or optimizing your workflow for the M1's GPU.

🔷External Monitor Issues:
Some users report flickering or other issues with external monitors on M1/M2 Macs. Check for updated drivers or settings adjustments to resolve these problems.

🔷Power Issues:
A known issue with some M2 Mac mini models involves a "no power" problem. Apple has a free repair program for affected devices manufactured within a specific timeframe.

🔷Troubleshooting Hardware Issues:
For hardware-related problems like keyboard malfunctions, Touch ID issues, or trackpad problems, refer to the official Apple Support documentation for troubleshooting steps or consider professional repair services.

🔷Repair Programs:
Apple may offer repair programs for specific M1/M2 Mac models with identified manufacturing defects, such as the aforementioned power issue with some M2 Mac minis. 
