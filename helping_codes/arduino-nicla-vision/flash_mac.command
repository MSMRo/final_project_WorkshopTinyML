#!/bin/bash
set -e

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
BOARD=arduino:mbed_nicla:nicla_vision
ARDUINO_CLI=$(which arduino-cli || true)
DIRNAME="$(basename "$SCRIPTPATH")"
EXPECTED_CLI_MAJOR=0
EXPECTED_CLI_MINOR=18

if [ ! -x "$ARDUINO_CLI" ]; then
    echo "Cannot find 'arduino-cli' in your PATH. Install the Arduino CLI before you continue."
    echo "Installation instructions: https://arduino.github.io/arduino-cli/latest/"
    exit 1
fi

CLI_MAJOR=$(arduino-cli version | cut -d. -f1 | rev | cut -d ' '  -f1)
CLI_MINOR=$(arduino-cli version | cut -d. -f2)
CLI_REV=$(arduino-cli version | cut -d. -f3 | cut -d ' '  -f1)

if ((CLI_MAJOR <= EXPECTED_CLI_MAJOR && CLI_MINOR < EXPECTED_CLI_MINOR)); then
    echo "You need to upgrade your Arduino CLI version (now: $CLI_MAJOR.$CLI_MINOR.$CLI_REV, but required: $EXPECTED_CLI_MAJOR.$EXPECTED_CLI_MINOR.x or higher)"
    echo "See https://arduino.github.io/arduino-cli/installation/ for upgrade instructions"
    exit 1
fi

if (( CLI_MAJOR != EXPECTED_CLI_MAJOR || CLI_MINOR != EXPECTED_CLI_MINOR )); then
    echo "You're using an untested version of Arduino CLI, this might cause issues (found: $CLI_MAJOR.$CLI_MINOR.$CLI_REV, expected: $EXPECTED_CLI_MAJOR.$EXPECTED_CLI_MINOR.x)"
fi

echo "Finding Arduino Mbed core..."

has_arduino_core() {
    arduino-cli core list | grep "arduino:mbed_nicla" || true
}
HAS_ARDUINO_CORE="$(has_arduino_core)"
if [ -z "$HAS_ARDUINO_CORE" ]; then
    echo "Installing Arduino Mbed core..."
    arduino-cli core update-index
    arduino-cli core install arduino:mbed_nicla@3.2.0
    echo "Installing Arduino Mbed core OK"
else
    ARDUINO_CORE_MAJOR=$(arduino-cli core list | cut -d. -f2)

    echo "Finding Arduino Mbed OK"
fi

echo "Finding Arduino Nicla Vision..."

has_serial_port() {
    (arduino-cli board list | grep "Arduino Nicla Vision" || true) | cut -d ' ' -f1
}
SERIAL_PORT=$(has_serial_port)

if [ -z "$SERIAL_PORT" ]; then
    echo "Cannot find a connected Arduino Nicla Vision development board (via 'arduino-cli board list')."
    echo "If your board is connected, double-tap on the RESET button to bring the board in recovery mode."
    echo "If you see a board connected, but with an unknown FQBN core, then update the Arduino core via:"
    echo "     $ arduino-cli core update-index"
    echo "     $ arduino-cli core install arduino:mbed_nicla@3.2.0"
    exit 1
fi

echo "Finding Arduino Nicla Vision OK"

set +e

echo "Flashing board..."

cd "$SCRIPTPATH"

arduino-cli upload -p $SERIAL_PORT --fqbn $BOARD --input-dir .

FLASH_RETVAL=$?
if [ $FLASH_RETVAL -ne 0 ]; then
    echo ""
    echo "Flashing failed. Here are some options:"
    echo "If your error is 'incorrect FQBN' you'll need to upgrade the Arduino core via:"
    echo "     $ arduino-cli core update-index"
    echo "     $ arduino-cli core install arduino:mbed_nicla@3.2.0"
    echo "Otherwise, double tap the RESET button to load the bootloader and try again"
    exit $FLASH_RETVAL
fi

echo ""
echo "Flashed your Arduino Nicla Vision development board."
echo "To set up your development with Edge Impulse, run 'edge-impulse-daemon'"
echo "To run your impulse on your development board, run 'edge-impulse-run-impulse'"
