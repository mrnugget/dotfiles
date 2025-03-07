# See: https://bsky.app/profile/gordon.bsky.social/post/3ljinnrymus2n

# Array of bird names
BIRD_NAMES=(
  "Albatross" "Avocet" "Blackbird" "Bluejay" "Cardinal" "Chickadee" "Crane"
  "Crow" "Dove" "Duck" "Eagle" "Falcon" "Finch" "Flamingo" "Goose" "Gull"
  "Hawk" "Heron" "Hummingbird" "Ibis" "Jay" "Kingfisher" "Kiwi" "Lark"
  "Macaw" "Magpie" "Nightingale" "Ostrich" "Owl" "Parrot" "Peacock" "Pelican"
  "Penguin" "Pigeon" "Quail" "Raven" "Robin" "Sandpiper" "Seagull" "Sparrow"
  "Starling" "Stork" "Swallow" "Swan" "Swift" "Tanager" "Tern" "Thrush"
  "Toucan" "Turkey" "Vulture" "Warbler" "Woodpecker" "Wren"
)

# Count of used bird names
BIRD_COUNT_FILE="$HOME/.bird_count"

# Initialize count file if it doesn't exist
if [[ ! -f "$BIRD_COUNT_FILE" ]]; then
  echo "0" > "$BIRD_COUNT_FILE"
fi

# Function to create a folder with a bird name
mkbir() {
  local count=$(cat "$BIRD_COUNT_FILE")
  
  # In ZSH, arrays are 1-indexed by default, so we need to handle this properly
  # We use a modulo operation, but we need to make sure we get a value between 1 and array length
  local num_birds=${#BIRD_NAMES[@]}
  local bird_index=$(( (count % num_birds) + 1 ))
  
  local bird_name="${BIRD_NAMES[$bird_index]}"
  
  # Create folder with bird name (adding current directory if no path specified)
  if [[ -z "$1" ]]; then
    mkdir -p "./$bird_name"
    echo "Created folder: $bird_name"
  else
    mkdir -p "$1/$bird_name"
    echo "Created folder: $1/$bird_name"
  fi
  
  # Increment and save count
  count=$((count + 1))
  echo "$count" > "$BIRD_COUNT_FILE"
  
  # Fun messages when running out of bird names
  if [[ $count -gt 30 ]]; then
    case $((RANDOM % 4)) in
      0) echo "I'm running out of bird names!" ;;
      1) echo "So many folders, so few birds..." ;;
      2) echo "Please stop creating folders!" ;;
      3) echo "Birds are becoming endangered due to folder creation." ;;
    esac
  fi
}

# If you want to provide a custom name while still using a bird prefix
mkbir_custom() {
  if [[ -z "$1" ]]; then
    echo "Usage: mkbir_custom [name]"
    return 1
  fi
  
  local count=$(cat "$BIRD_COUNT_FILE")
  local num_birds=${#BIRD_NAMES[@]}
  local bird_index=$(( (count % num_birds) + 1 ))
  local bird_name="${BIRD_NAMES[$bird_index]}"
  local custom_name="$1"
  
  # Create folder with bird name + custom name
  mkdir -p "${bird_name}_${custom_name}"
  
  # Increment and save count
  count=$((count + 1))
  echo "$count" > "$BIRD_COUNT_FILE"
  
  echo "Created folder: ${bird_name}_${custom_name}"
}
