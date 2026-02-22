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

START_TIME=$(date +%s)

LOGFILE="$HOME/Desktop/mac-update.log"
SUMMARY="$HOME/Desktop/mac-update-summary.txt"

# Start log
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}Interactive Mac Update Script Started: $(date)${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"

# Clear previous summary
> "$SUMMARY"

# =========================
# macOS Updates
# =========================

UPDATES=$(softwareupdate -l)
MAC_COUNT=$(echo "$UPDATES" | grep -c "\*")

if [[ -z "$UPDATES" || "$UPDATES" == *"No new software available"* ]]; then
    echo -e "${GREEN}No macOS updates available.${NC}" | tee -a "$LOGFILE"
    echo "macOS updates installed: 0" >> "$SUMMARY"
else
    echo "$UPDATES" | tee -a "$LOGFILE"
    read -p "Do you want to install macOS updates now? (Y/n) " REPLY
    REPLY=${REPLY:-Y}

    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
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
    else
        echo -e "${YELLOW}Skipped macOS updates.${NC}" | tee -a "$LOGFILE"
        echo "macOS updates skipped." >> "$SUMMARY"
    fi
fi

# =========================
# Homebrew Updates
# =========================

if command -v brew >/dev/null 2>&1; then
    BREW_COUNT=$(brew outdated | wc -l)

    if [[ "$BREW_COUNT" -eq 0 ]]; then
        echo -e "${GREEN}No Homebrew packages need updating.${NC}" | tee -a "$LOGFILE"
        echo "Homebrew packages updated: 0" >> "$SUMMARY"
    else
        read -p "Do you want to update Homebrew packages now? (Y/n) " REPLY
        REPLY=${REPLY:-Y}

        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Updating Homebrew...${NC}" | tee -a "$LOGFILE"
            brew update | tee -a "$LOGFILE"
            brew upgrade | tee -a "$LOGFILE"

            echo "Homebrew packages updated: $BREW_COUNT" >> "$SUMMARY"
        else
            echo -e "${YELLOW}Skipped Homebrew updates.${NC}" | tee -a "$LOGFILE"
            echo "Homebrew updates skipped." >> "$SUMMARY"
        fi
    fi
else
    echo -e "${YELLOW}Homebrew not installed. Skipping...${NC}" | tee -a "$LOGFILE"
    echo "Homebrew not installed." >> "$SUMMARY"
fi

# =========================
# Duration Calculation
# =========================

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo "Total update duration: $DURATION seconds" >> "$SUMMARY"

# Finish log
echo -e "${GREEN}Interactive update process finished: $(date)${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}===================================${NC}" | tee -a "$LOGFILE"
