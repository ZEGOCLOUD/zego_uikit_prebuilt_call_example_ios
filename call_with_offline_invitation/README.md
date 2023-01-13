# Call Kit (ZegoUIKitPrebuiltCall) offline

- - -

![invitation_calls](https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/Flutter/call/invitation_calls.gif)

## Recommended resources

- I want to get started, Follow the steps to get started swiftly: [Quick Start](https://docs.zegocloud.com/article/14819)

- To configure prebuilt UI for a custom experience: [Custom Prebuilt UI](https://docs.zegocloud.com/article/14765)

- To finest-grained build a call, you may try antoher one: [Video Call SDK](https://docs.zegocloud.com/article/5540)

- If you have any questions regarding bugs and feature requests, visit the [ZEGOCLOUD community](https://discord.gg/EtNRATttyp) or email us at global_support@zegocloud.com.

## Prerequisites

- Go to [ZEGOCLOUD Admin Console](https://console.zegocloud.com), and do the following:
  - Create a project, get the **AppID** and **AppSign**.
  - Activate the **In-app Chat** service (as shown in the following figure).

![ActivateZIMinConsole](https://storage.zego.im/sdk-doc/Pics/InappChat/ActivateZIMinConsole2.png)

## Receive call invitation notifications

- receive call invitation notifications, do the following: 
    [![Watch the video](https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/videos/how_to_enable_offline_call_invitation_ios.png)](https://youtu.be/rzdRY8bDqdo)


## Configure your project
### Open the `Info.plist`, add the following code inside the `dict` part:
```plist
<key>NSCameraUsageDescription</key>
<string>Access permission to camera is required.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Access permission to microphone is required.</string>
```
<image src="https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/iOS/add_mic_camera_permissions.png">

### Get the APNs device token
- In the `AppDelegate.swift` file, implement Apple's register callback for receiving the `deviceToken`:

```swift
  func application(_ application: UIApplication,    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
    /// Required - Set the device token
    ZegoUIKitPrebuiltCallInvitationService.setRemoteNotificationsDeviceToken(deviceToken)
  }
```
<image src="https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/iOS/device_token.png">


## Integrate the SDK

### Add dependencies

Do the following to add the `ZegoUIKitPrebuiltCall` dependencies:

- Open Terminal, navigate to your project's root directory, and run the following to create a `podfile`: 

    ```
    pod init
    ```
- Edit the `Podfile` file to add the basic dependency:

    ```
    pod 'ZegoUIKitPrebuiltCall'
    pod 'ZegoUIKitSignalingPlugin'
    ```

- In Terminal, run the following to download all required dependencies and SDK with Cocoapods:

    ```
    pod install
    ```


## Using the Call Kit
### Set up a button for making a voice call.
```swift
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //notifyWhenAppRunningInBackgroundOrQuit to false if you don't need to receive a call invitation notification while your app running in the background or quit.

        //To publish your app to TestFlight or App Store, set the isSandboxEnvironment to false before starting building. To debug locally, set it to true. Ignore this when the notifyWhenAppRunningInBackgroundOrQuit is false.
        let config = ZegoUIKitPrebuiltCallInvitationConfig([ZegoUIKitSignalingPlugin()], notifyWhenAppRunningInBackgroundOrQuit: true, isSandboxEnvironment: false)
        // Get your AppID and AppSign from ZEGOCLOUD's Console
        // userID can only contain numbers, letters, and '_'.
        ZegoUIKitPrebuiltCallInvitationService.shared.initWithAppID(YOUR_APPID, appSign: YOUR_APP_SIGN, userID:YOUR_USER_ID, userName:YOUR_USER_NAME, config: config)

        // Create Voice Call invitation Button
        let callTargetUser: ZegoUIkitUser = ZegoUIkitUser.init("TargetUserID", "TargetUserName")
        let sendVoiceCallButton: ZegoSendCallInvitationButton = ZegoSendCallInvitationButton(ZegoInvitationType.voiceCall.rawValue)
        sendVoiceCallButton.text = "voice"
        sendVoiceCallButton.setTitleColor(UIColor.blue, for: .normal)
        sendVoiceCallButton.inviteeList.append(callTargetUser)
        ////resourceID can be used to specify the ringtone of an offline call invitation, which must be set to the same value as the Push Resource ID in ZEGOCLOUD Admin Console. This only takes effect when the ZegoUIKitPrebuiltCallInvitationConfig`s notifyWhenAppRunningInBackgroundOrQuit is true
        sendVoiceCallButton.resourceID = "zegouikit_call" 
        sendVoiceCallButton.frame = CGRect.init(x: 100, y: 100, width: 150, height: 40)
        // Add the button to your view
        self.view.addSubview(sendVoiceCallButton)
    }
}
```

### Set up a button for making a video call
```swift
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get your AppID and AppSign from ZEGOCLOUD's Console
        // userID can only contain numbers, letters, and '_'. 
        let config = ZegoUIKitPrebuiltCallInvitationConfig([ZegoUIKitSignalingPlugin()], notifyWhenAppRunningInBackgroundOrQuit: true, isSandboxEnvironment: false)
        ZegoUIKitPrebuiltCallInvitationService.shared.initWithAppID(YOUR_APPID, appSign: YOUR_APP_SIGN, userID:YOUR_USER_ID, userName:YOUR_USER_NAME, config: config)

        // Create Video Call invitation Button
        let callTargetUser: ZegoUIkitUser = ZegoUIkitUser.init("TargetUserID", "TargetUserName")
        let sendVideoCallButton: ZegoSendCallInvitationButton = ZegoSendCallInvitationButton(ZegoInvitationType.videoCall.rawValue)
        sendVideoCallButton.text = "Video"
        sendVideoCallButton.setTitleColor(UIColor.blue, for: .normal)
        sendVideoCallButton.inviteeList.append(callTargetUser)
        //resourceID can be used to specify the ringtone of an offline call invitation, which must be set to the same value as the Push Resource ID in ZEGOCLOUD Admin Console. This only takes effect when the ZegoUIKitPrebuiltCallInvitationConfig`s  notifyWhenAppRunningInBackgroundOrQuit is true
        sendVideoCallButton.resourceID = "zegouikit_call"  call notification
        sendVideoCallButton.frame = CGRect.init(x: 100, y: 100, width: 150, height: 40)
        // Add the button to your view.
        self.view.addSubview(sendVideoCallButton)
    }
}
```

## Run & Test

Now you have finished all the steps!

You can simply click the **Run** in XCode to run and test your App on your device.
