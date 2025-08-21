#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Ghostty Theme
# @raycast.mode compact

# Optional parameters:
# @raycast.packageName Terminal

# Documentation:
# @raycast.description Toggle Ghostty between Gruvbox Dark Hard and Gruvbox Light Hard
# @raycast.author thorsten
# @raycast.authorURL https://github.com/mrnugget

set -euo pipefail

config_file="${GHOSTTY_CONFIG_FILE:-$HOME/.config/ghostty/config}"
dark_theme="${GHOSTTY_DARK_THEME:-Gruvbox Dark Hard}"
light_theme="${GHOSTTY_LIGHT_THEME:-Adwaita}"

normalize_theme() {
  local value="$1"
  local trimmed

  trimmed="$(printf '%s' "$value" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//; s/[[:space:]]+/ /g')"

  case "$trimmed" in
  \"*\")
    trimmed="${trimmed#\"}"
    trimmed="${trimmed%\"}"
    ;;
  esac

  case "$trimmed" in
  \'*\')
    trimmed="${trimmed#\'}"
    trimmed="${trimmed%\'}"
    ;;
  esac

  printf '%s' "$(printf '%s' "$trimmed" | tr '[:upper:]' '[:lower:]')"
}

reload_ghostty_config() {
  if [[ "$(uname)" != "Darwin" ]]; then
    return 0
  fi

  if [[ "$(osascript -e 'if application "Ghostty" is running then return "yes"' 2>/dev/null || true)" != "yes" ]]; then
    return 0
  fi

  # Default Ghostty keybind for reload_config is cmd+shift+comma.
  osascript >/dev/null 2>&1 <<'APPLESCRIPT' || true
tell application "Ghostty" to activate
delay 0.15
tell application "System Events"
  tell process "Ghostty"
    set frontmost to true
  end tell
  keystroke "," using {command down, shift down}
end tell
APPLESCRIPT
}

if [[ ! -f "$config_file" ]]; then
  echo "Ghostty config not found: $config_file"
  exit 1
fi

current_theme_raw="$(sed -nE 's/^[[:space:]]*theme[[:space:]]*=[[:space:]]*([^#]*).*$/\1/p' "$config_file" | head -n1)"
current_theme="$(normalize_theme "$current_theme_raw")"
dark_theme_normalized="$(normalize_theme "$dark_theme")"
light_theme_normalized="$(normalize_theme "$light_theme")"

if [[ "$current_theme" == "$dark_theme_normalized" ]]; then
  next_theme="$light_theme"
elif [[ "$current_theme" == "$light_theme_normalized" ]]; then
  next_theme="$dark_theme"
elif [[ "$current_theme" == *"light"* ]]; then
  next_theme="$dark_theme"
else
  next_theme="$light_theme"
fi

if grep -qE '^[[:space:]]*theme[[:space:]]*=' "$config_file"; then
  sed -i.bak -E "s|^[[:space:]]*theme[[:space:]]*=.*$|theme = $next_theme|" "$config_file"
  rm -f "$config_file.bak"
else
  printf '\ntheme = %s\n' "$next_theme" >>"$config_file"
fi

reload_ghostty_config

if [[ -z "$current_theme_raw" ]]; then
  current_theme_raw="<unset>"
fi

echo "Ghostty theme: $current_theme_raw -> $next_theme"
