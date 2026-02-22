#!/bin/bash

# =====================================
# Mac Update Script - update.sh
# =====================================

# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"

START_TIME=$(date +%s)

LOGFILE="$HOME/Desktop/mac-update.log"
SUMMARY="$HOME/Desktop/mac-update-summary.txt"

# Start log
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}Mac Update Script Started: $(date)${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"

# Clear previous summary
> "$SUMMARY"

# macOS updates
echo -e "${BLUE}Checking for macOS updates...${NC}" | tee -a "$LOGFILE"

UPDATES=$(softwareupdate -l)
MAC_COUNT=$(echo "$UPDATES" | grep -c "\*")

echo "$UPDATES" | tee -a "$LOGFILE"

if [[ -z "$UPDATES" || "$UPDATES" == *"No new software available"* ]]; then
    echo -e "${GREEN}No macOS updates available.${NC}" | tee -a "$LOGFILE"
    echo "No macOS updates installed." >> "$SUMMARY"
else
    echo -e "${BLUE}Installing all available updates...${NC}" | tee -a "$LOGFILE"
    sudo softwareupdate -ia --verbose | tee -a "$LOGFILE"

    echo "macOS updates installed: $MAC_COUNT" >> "$SUMMARY"

    if softwareupdate -l | grep -qi "restart"; then
        echo -e "${YELLOW}⚠️  A restart is required. Please reboot manually.${NC}" | tee -a "$LOGFILE"
        echo "Restart required: Yes" >> "$SUMMARY"
    else
        echo -e "${GREEN}No restart required.${NC}" | tee -a "$LOGFILE"
        echo "Restart required: No" >> "$SUMMARY"
    fi
fi

# Homebrew updates
if command -v brew >/dev/null 2>&1; then
    BREW_COUNT=$(brew outdated | wc -l)

    if [[ "$BREW_COUNT" -eq 0 ]]; then
        echo -e "${GREEN}No Homebrew packages need updating.${NC}" | tee -a "$LOGFILE"
        echo "Homebrew packages updated: 0" >> "$SUMMARY"
    else
        echo -e "${BLUE}Updating Homebrew...${NC}" | tee -a "$LOGFILE"
        brew update | tee -a "$LOGFILE"
        brew upgrade | tee -a "$LOGFILE"

        echo "Homebrew packages updated: $BREW_COUNT" >> "$SUMMARY"
    fi
else
    echo -e "${YELLOW}Homebrew not installed. Skipping...${NC}" | tee -a "$LOGFILE"
    echo "Homebrew not installed." >> "$SUMMARY"
fi

# Calculate duration
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo "Total update duration: $DURATION seconds" >> "$SUMMARY"

# Finish log
echo -e "${GREEN}Update process finished: $(date)${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"
