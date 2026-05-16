# Contribute

All contributions, code, feedback and strategic advice, are welcome.
If you have a question you can open an issue on the repository,

## ⚙️ How to make changes in the code

### 1. Where to begin

Start by looking at the [open issues](https://github.com/aaryanvangari/pi-block/issues/) to contribute code.

Also, take a look at [**Coding Guidelines**](#-coding-guidelines) before making code changes.

### 2. Testing

Make sure that all existing and new tests are passing.

## 📋 Coding Guidelines

- Keep it snimple snupid: [KISS](https://en.wikipedia.org/wiki/KISS_principle)
- No repeating yourself. [Re-use your own code and that of others](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself).
- If you want to help, triaging and keeping up with the issue and TODO list is great.
- Try to follow our coding style and formatting before submitting a patch.
- All merge requests should come from a feature branch created on your Git fork. Your code will be reviewed, and only merged to the master branch if it doesn't break the build.
- When you submit a merge request, try to explain what issue you're fixing, and what you're fixing in detail, so it's easier for us to read your patches.
- Well named methods and code re-usability is preferable to a lot of comments.

## 🛠️ Development

This guide is for Linux environment. This guide might not be complete so please make relevant changes as per your environment

**Note**: Code segments are needed to be added to bashrc or bash_profile

### 1. Get Flutter

* Install the [Flutter framework](https://docs.flutter.dev/install/quick).

* You might want to install these packages in linux environment

```shell
sudo apt install cmake ninja-build clang
```

### 2. Setting up Flutter environment

```shell
############
# Flutter Development setup
############
test -d $HOME/flutter-sdk && export FLUTTER_SDK=$HOME/flutter-sdk
test -d $FLUTTER_SDK/flutter/bin && export PATH=$FLUTTER_SDK/flutter/bin:$PATH
test -d $HOME/.pub-cache/bin && export PATH=$HOME/.pub-cache/bin:$PATH
```

### 3. Pi Block Credentials setup

* `PIHOLE_SERVER_URL` is your Pi-Hole server URL. It might look like `http://192.168.1.2:8053` for local Pi-Hole servers.
* `PIHOLE_API_TOKEN` is the API token which you have setup for your Pi-Hole (`FTLCONF_webserver_api_password`)
* This is secure way of handling credentials and easy way to change servers if needed.

```shell
############
# Pi-Block Credentials
############
export PIHOLE_SERVER_URL=
export PIHOLE_API_TOKEN=
```

### 4. Setting up Android environment

```shell
############
# Android Development setup
############
# Android Virtual Devices Home
# Flatpak installation
# test -d $HOME/.var/app/com.google.AndroidStudio/config/.android/avd/ && export ANDROID_AVD_HOME=$HOME/.var/app/com.google.AndroidStudio/config/.android/avd/
# Snap installation
test -d $HOME/.android/avd/ && export ANDROID_AVD_HOME=$HOME/.android/avd/
test -d $HOME/Android/Sdk/platform-tools/ && export PATH=$HOME/Android/Sdk/platform-tools:$PATH
```

### 5. Setting up Web environment

```shell
# Chroimum browser as default for web
test -f /snap/bin/chromium && export CHROME_EXECUTABLE=/snap/bin/chromium
```

**Note**: I didn't need web environment but if you are testing on web you might want to set this up

### 6. Run the project

* Clone this repository.
* In VSCode -> Debug -> Run and Debug as `pi_block`
* Open `Debug Console` and check the output.
* If everything goes fine you will see app in gtk window

## Flutter commands

### Frequently used commands

```shell
# Gives list of devices
flutter devices

# Connect to specific device
flutter devices -d <DEVICE_ID>

# Show information about the installed tooling.
flutter doctor -v

# Delete the build/ and .dart_tool/ directories.
flutter clean

# Runs a Flutter program.
flutter run

# Gets packages from pub.dev
flutter pub get

```

For full list of commands follow this link [Flutter CLI](<https://docs.flutter.dev/reference/flutter-cli>)

## Troubleshooting

### 1. Cannot authenticate with PiHole' due to API seats exceeded

Reason is that Pi-Hole has 16 sessions as default.

While we are developing with Pi-Block we might definitely cross this limit

If you exceed the sessions limit then run below commands

```shell
docker exec pihole pihole-FTL --config webserver.api.max_sessions 17
```

Above command exceeds sessions limit to 17 so that there would be one session available for login

Then login from web and then remove unnecessary sessions

From next time please look out for increasing sessions

**Note**: This issue will be solved if we save credentials in mobile storage which is one of the action item for future

**Happy developing and thank you for your contributions!**
