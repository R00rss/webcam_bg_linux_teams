#!/bin/bash

# Get virtual device and integrated camera
virtual_device=$(v4l2-ctl --list-devices | grep -A 1 "Weffe" | tail -n 1 | awk '{print $1}')
camera=$(v4l2-ctl --list-devices | grep -A 1 "Integrated" | tail -n 1 | awk '{print $1}')

# Check if virtual device is found
if [ -z "$virtual_device" ]; then
    echo "No virtual camera found. Executing weffe -a..."
    if ! weffe -a; then
        echo "Error: Failed to execute weffe -a"
        exit 1
    fi
    virtual_device=$(v4l2-ctl --list-devices | grep -A 1 "Weffe" | tail -n 1 | awk '{print $1}')
fi

echo "Using virtual device $virtual_device"

repo_ssh="git@github.com:prabhakar-sivanesan/MS-Teams-background-changer.git"
project_dir="MS-Teams-background-changer"

# Clone the project if not already cloned
if [ ! -d "$project_dir" ]; then
    echo "Cloning project..."
    if ! git clone "$repo_ssh"; then
        echo "Error: Failed to clone the project"
        exit 1
    fi
fi

cd "$project_dir" || exit

# Check if virtual environment exists and create it if not
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv || {
        echo "Error: Failed to create virtual environment"
        exit 1
    }
fi

# Activate virtual environment
source venv/bin/activate || {
    echo "Error: Failed to activate virtual environment"
    exit 1
}

# Install required packages
echo "Installing required packages..."
pip install -r requirements.txt || {
    echo "Error: Failed to install required packages"
    exit 1
}

# Set variables in the config file
sed -i "s|^\(virtualDeviceID\s*=\s*\).*$|\1$virtual_device|" config.yaml
sed -i "s|^\(cameraID\s*=\s*\).*$|\1$camera|" config.yaml
sed -i "s|^\(blur\s*=\s*\).*$|\1no|" config.yaml

# Run the script
echo "Running the script..."
python3 main.py
