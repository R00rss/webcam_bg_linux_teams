# Webcam Background Changer

This project is an automated version of the original MS Teams background changer by [prabhakar-sivanesan](https://github.com/prabhakar-sivanesan/MS-Teams-background-changer) for personal use.

## Before You Start

Ensure you have a webcam connected to your PC and the following packages installed:

- Python 3.x
- v4l2loopback-dkms
- v4l-utils

### Installing Dependencies on Arch Linux

```bash
sudo pacman -Syu
sudo pacman -S python v4l2loopback-dkms v4l-utils
```
## Installation

1. Clone the repository

```bash
git clone https://github.com/ron-m/MS-Teams-background-changer.git
```

2. Give Permissions to the Script
```bash
chmod +x bgReplaceTeams.sh
```
3. Run the Script

```bash
./bgReplaceTeams.sh
```

The script will ask for your sudo password to run the ```weffe -a ```command. If you prefer, you can run the command manually.

## How It Works

For more detailed information, refer to the original repository, but the script performs the following steps:

1. Reads the variables from the .env file.
2. Checks if the virtual webcam device is already set to the background image. If not, it runs ```weffe -a```.
3. Checks if the MS-Teams-background-changer repository is already cloned. If not, it clones the repository.
4. Creates a virtual environment and installs the required packages. If the virtual environment already exists, it skips this step.
5. Modifies the variables in the config.yaml file based on the output of the ```v4l2-ctl --list-devices``` command.
6. Executes the Python script.


## Notes
- If you don't trust the script, running the weffe -a command manually will work as well.
- Ensure you have the required permissions to use your webcam and virtual devices.