
#!/bin/bash

echo "Checking for macOS updates..."
softwareupdate -l

echo "Installing all available updates..."
sudo softwareupdate -ia --verbose

echo "Done!"

