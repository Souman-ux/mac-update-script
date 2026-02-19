# macOS Update Scripts

This repository contains **two macOS update scripts**:

1. **Full Upgrade Script** – automatically checks and installs updates, with color-coded output, logging, and optional Homebrew updates.  
2. **Interactive Script** – asks for confirmation before installing macOS updates or Homebrew updates, giving full control to the user.

Both scripts are safe: they do **not restart automatically**, and log all actions to `mac-update.log` on your Desktop.

---

## What I Did in These Scripts 

Here’s exactly what I have been doing in these scripts:

1. **Shebang** (`#!/bin/bash`)  
   - Tells macOS to run the script using the Bash shell.  

2. **Colors**  
   ```bash
   GREEN="\033[0;32m"
   YELLOW="\033[1;33m"
   BLUE="\033[0;34m"
   RED="\033[0;31m"
   NC="\033[0m"
	- It will help user to read the terminal output easier.

3. **Log file**
	LOGFILE="$HOME/Desktop/mac-update.log"
	- It creates a log file on the desktop, so that it can later be chcked what exactly happened during the update.	

4. **Start log sections**
	echo -e "${BLUE}Mac Update Script Started: $(date)${NC}" | tee -a "$LOGFILE"
	- It marks the start of the script in the log.

5. **Check for macOS updates**
	softwareupdate -l | tee -a "$LOGFILE"
	- "softwareupdate -l": It helps to show the list which are all available macOS updates.
	- "tee -a": writes both to terminal and log file.

6. **Install all macOS updates**
	sudo softwareupdate -ia --verbose | tee -a "$LOGFILE"
	- "sudo": administrator permission
	- "i": install
	- "a": all available updates
	- "verbose": show progress in detail

7. **Detect if restart is required
	if softwareupdate -l | grep -qi "restart"; then
    		echo "A restart is required"
	fi
	- It helps to check if any updates require a reboot.
	- It warns the user but does not restart automatically.

8. **Optional Homebrew updates**
	if command -v brew >/dev/null 2>&1; then
	    	brew update
    		brew upgrade
	fi
	- Checks if the homebrew is installed.
	- Updates Homebrew itself and all installed packages.

9. **Finish log**
	echo -e "${GREEN}Update process finished: $(date)${NC}" | tee -a "$LOGFILE"
	- It marks the end of the script in the log with timestamp.


--------------------------------------------------------------------------------------------
Usage:
Here is the full demonstration that how I did it:

1. Open terminal and navigate to the folder that contains the scripts:
	cd ~/Desktop/mac-update-script
2. Make script executable:
	chmod +x update.sh
	chmod +x interactive-update.sh
3. Run the desired scripts:
	./update.sh            	 # Full upgrade version
	./interactive-update.sh	 # Interactive version
4. Check mac-update.log

-------------------------------------------------------------------------------------------
Here are the scripts:
(update.sh)

1.

#!/bin/bash

# =====================================
# Mac Update Script - Full Upgrade
# =====================================

# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"

LOGFILE="$HOME/Desktop/mac-update.log"

# Start log
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}Mac Update Script Started: $(date)${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"

# macOS updates
echo -e "${BLUE}Checking for macOS updates...${NC}" | tee -a "$LOGFILE"
softwareupdate -l | tee -a "$LOGFILE"

echo -e "${BLUE}Installing all available updates...${NC}" | tee -a "$LOGFILE"
sudo softwareupdate -ia --verbose | tee -a "$LOGFILE"

# Manual restart warning
if softwareupdate -l | grep -qi "restart"; then
    echo -e "${YELLOW}⚠️  A restart is required. Please reboot manually.${NC}" | tee -a "$LOGFILE"
else
    echo -e "${GREEN}No restart required.${NC}" | tee -a "$LOGFILE"
fi

# Optional Homebrew updates
if command -v brew >/dev/null 2>&1; then
    echo -e "${BLUE}Updating Homebrew...${NC}" | tee -a "$LOGFILE"
    brew update | tee -a "$LOGFILE"
    brew upgrade | tee -a "$LOGFILE"
else
    echo -e "${YELLOW}Homebrew not installed. Skipping...${NC}" | tee -a "$LOGFILE"
fi

# Finish log
echo -e "${GREEN}Update process finished: $(date)${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"


2. Interactive Script
(interactive-update.sh)

#!/bin/bash

# =====================================
# Mac Update Script - Interactive Version
# =====================================

# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"

LOGFILE="$HOME/Desktop/mac-update.log"

# Start log
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}Interactive Mac Update Script Started: $(date)${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"

# Ask to install macOS updates
read -p "Do you want to check and install macOS updates now? (Y/n) " REPLY
REPLY=${REPLY:-Y}

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Checking for macOS updates...${NC}" | tee -a "$LOGFILE"
    softwareupdate -l | tee -a "$LOGFILE"

    echo -e "${BLUE}Installing all available updates...${NC}" | tee -a "$LOGFILE"
    sudo softwareupdate -ia --verbose | tee -a "$LOGFILE"

    if softwareupdate -l | grep -qi "restart"; then
        echo -e "${YELLOW}⚠️  A restart is required. Please reboot manually.${NC}" | tee -a "$LOGFILE"
    else
        echo -e "${GREEN}No restart required.${NC}" | tee -a "$LOGFILE"
    fi
else
    echo -e "${YELLOW}Skipped macOS updates.${NC}" | tee -a "$LOGFILE"
fi

# Ask to update Homebrew
if command -v brew >/dev/null 2>&1; then
    read -p "Do you want to update Homebrew packages now? (Y/n) " REPLY
    REPLY=${REPLY:-Y}
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Updating Homebrew...${NC}" | tee -a "$LOGFILE"
        brew update | tee -a "$LOGFILE"
        brew upgrade | tee -a "$LOGFILE"
    else
        echo -e "${YELLOW}Skipped Homebrew updates.${NC}" | tee -a "$LOGFILE"
    fi
else
    echo -e "${YELLOW}Homebrew not installed. Skipping...${NC}" | tee -a "$LOGFILE"
fi

# Finish log
echo -e "${GREEN}Interactive update process finished: $(date)${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"



---------------------------------------------------------------------------------------------------
Difference Between Full Update and Interactive Script

Full Upgrade Script (update.sh) – Updates macOS and Homebrew automatically without asking.

Interactive Script (interactive-update.sh) – Asks you for confirmation before updating macOS or Homebrew.
	 

## Usage

chmod +x update.sh
./update.sh


