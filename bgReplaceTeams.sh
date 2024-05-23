#!/bin/bash

# Cargar variables de entorno desde el archivo .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

virutal_device=$(v4l2-ctl --list-devices | grep -A 1 "Weffe" | tail -n 1 | awk '{print $1}')
# another way to get the device name
# virutal_device=$(v4l2-ctl --list-devices | awk '/Weffe/ {getline; print}')


if [ -z "$virutal_device" ]; then
    echo "No virtual camera found, Executing weffe -a"
    weffe -a
    device=$(v4l2-ctl --list-devices | grep -A 1 "Weffe" | tail -n 1 | awk '{print $1}')
fi

echo "Using virutal device $virutal_device"

# get the first integrated camera
camera=$(v4l2-ctl --list-devices | grep -A 1 "Integrated" | tail -n 1 | awk '{print $1}')

repo_ssh="git@github.com:ron-rosenko/MS-Teams-background-changer.git"

project_is_cloned=0
venv_exist_before=0
project_dir="MS-Teams-background-changer"

echo camara $camera
echo device $virutal_device
echo repo $repo_ssh
echo project $project_dir

# check if directory project exists and set a flag if it does
if [ -d $project_dir ]; then
    echo "Directory already exists"
    project_is_cloned=1
fi

if [ $project_is_cloned -eq 0 ]; then
    # Clone the project
    echo "Cloning project..."
    git clone $repo_ssh
fi

# Change directory to the project
cd $project_dir

# Check if virtual environment exists and create it if it doesn't
if [ -d venv ]; then
    echo "Virtual environment already exists"
    venv_exist_before=1
else
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate the virtual environment
source venv/bin/activate

# Install the required packages
if [ $venv_exist_before -eq 0 ]; then
    echo "Installing packages..."
    pip install -r requirements.txt
fi

echo "Setting the variables in the config file..."

blur="no"

# chance variables in ./config.yaml
sed -i "s|^\(virtualDeviceID\s*=\s*\).*$|\1$virutal_device|" config.yaml

sed -i "s|^\(cameraID\s*=\s*\).*$|\1$camera|" config.yaml

sed -i "s|^\(blur\s*=\s*\).*$|\1$blur|" config.yaml

echo "Running the script..."

# Run the script
python3 main.py
