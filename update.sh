#!/bin/bash

# =====================================
# Mac Update Script - Color + Logging
# =====================================

# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"  # No Color

# Log file
LOGFILE="$HOME/Desktop/mac-update.log"

# Start log
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}Mac Update Script Started: $(date)${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"

# Check for macOS updates
echo -e "${BLUE}Checking for macOS updates...${NC}" | tee -a "$LOGFILE"
softwareupdate -l | tee -a "$LOGFILE"

# Install macOS updates
echo -e "${BLUE}Installing all available updates...${NC}" | tee -a "$LOGFILE"
sudo softwareupdate -ia --verbose | tee -a "$LOGFILE"

# Check if restart is required (manual)
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

# End log
echo -e "${GREEN}Update process finished: $(date)${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"


