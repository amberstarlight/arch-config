#!/usr/bin/env bash

BLUE='\033[1;34m'
RED='\033[0;31m'
NC='\033[0m'

if [ ! "$(id -u)" == 0 ]; then
  env echo -e "${RED}This script needs to be run as root.${NC}" >&2
  exit 1
fi

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
PACMAN_CONF_FILE="/etc/pacman.conf"
HOOK_DIR_STRING="HookDir = ${PARENT_DIR}"

env echo -e "${BLUE}Adding hook directory to pacman.conf...${NC}"

case $(grep -F "$HOOK_DIR_STRING" "$PACMAN_CONF_FILE" >/dev/null; echo $?) in
  0)
    env echo -e "${BLUE}Hooks already installed.${NC}"
    exit 0
    ;;
  1)
    env echo "$HOOK_DIR_STRING" >> "$PACMAN_CONF_FILE"
    env echo -e "${BLUE}...Hooks installed!${NC}"
    exit 0
    ;;
  *)
    env echo -e "${RED}An error occured. Exiting.${NC}"
    exit 1
    ;;
esac
