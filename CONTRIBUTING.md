# Contribute

All contributions, code, feedback and strategic advice, are welcome.
If you have a question you can open an issue on the repository,

## Development

This guide is for Linux environment. This guide might not be complete so please make relevant changes as per your environment

**Note**: Code segments are needed to be added to bashrc or bash_profile

### Get Flutter

* Install the [Flutter framework](https://docs.flutter.dev/install/quick).

* You might want to install these packages in linux environment

```shell
sudo apt install cmake ninja-build clang
```

### Setting up Flutter environment

```shell
############
# Flutter Development setup
############
test -d $HOME/flutter-sdk && export FLUTTER_SDK=$HOME/flutter-sdk
test -d $FLUTTER_SDK/flutter/bin && export PATH=$FLUTTER_SDK/flutter/bin:$PATH
test -d $HOME/.pub-cache/bin && export PATH=$HOME/.pub-cache/bin:$PATH
```

### Pi Block Credentials setup

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

### Setting up Android environment

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

### Setting up Web environment

```shell
# Chroimum browser as default for web
test -f /snap/bin/chromium && export CHROME_EXECUTABLE=/snap/bin/chromium
```

**Note**: I didn't need web environment but if you are testing on web you might want to set this up

### Run the project

* Clone this repository.
* In VSCode -> Debug -> Run and Debug as `pi_block`
* Open `Debug Console` and check the output.
* If everything goes fine you will see app in gtk window

### Flutter commands

#### Frequently used commands

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

### Cannot authenticate with PiHole' due to API seats exceeded

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
