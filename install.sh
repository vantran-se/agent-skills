#!/bin/bash

# Install/Update Skills to a specific project
# Usage: ./install.sh <path-to-project>

TARGET_DIR="$1"

if [ -z "$TARGET_DIR" ]; then
    echo "Usage: $0 <path-to-project>"
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

echo "Installing skills to '$TARGET_DIR'..."

# Function to copy skills
copy_skills() {
    local dest="$1"
    echo "Copying skills to '$dest'..."
    mkdir -p "$dest"
    
    if command -v rsync >/dev/null 2>&1; then
        rsync -av --exclude 'tests' --exclude '__pycache__' skills/ "$dest/"
    else
        cp -R skills/* "$dest/"
    fi
}

# Interactive IDE Selection
echo ""
echo "Which IDE are you setting up for? (Select number)"
echo "1) Windsurf (.windsurf/skills)"
echo "2) Cursor   (.cursor/skills)"
echo "3) Claude   (.claude/skills)"
echo "4) Antigravity (.agent/skills)"
echo "5) All      (Recommended - installs for all supported IDEs)"
read -p "Selection [5]: " IDE_CHOICE
IDE_CHOICE=${IDE_CHOICE:-5}

case $IDE_CHOICE in
    1)
        # Windsurf
        mkdir -p "$TARGET_DIR/.windsurf"
        copy_skills "$TARGET_DIR/.windsurf/skills"
        
        # Setup Windsurf rules
        if [ ! -f "$TARGET_DIR/.windsurfrules" ]; then
            echo "Creating .windsurfrules..."
            echo "/.windsurf/skills/**" > "$TARGET_DIR/.windsurfrules"
        elif ! grep -q ".windsurf/skills" "$TARGET_DIR/.windsurfrules"; then
            echo "Updating .windsurfrules..."
            echo -e "\n/.windsurf/skills/**" >> "$TARGET_DIR/.windsurfrules"
        fi
        ;;
    2)
        # Cursor
        mkdir -p "$TARGET_DIR/.cursor"
        copy_skills "$TARGET_DIR/.cursor/skills"
        ;;
    3)
        # Claude
        mkdir -p "$TARGET_DIR/.claude"
        copy_skills "$TARGET_DIR/.claude/skills"
        ;;
    4)
        # Antigravity (using .agent as per user update)
        mkdir -p "$TARGET_DIR/.agent"
        copy_skills "$TARGET_DIR/.agent/skills"
        ;;
    *)
        # All
        echo "Installing for ALL IDEs..."
        
        # Windsurf
        mkdir -p "$TARGET_DIR/.windsurf"
        copy_skills "$TARGET_DIR/.windsurf/skills"
        if [ ! -f "$TARGET_DIR/.windsurfrules" ]; then
             echo "/.windsurf/skills/**" > "$TARGET_DIR/.windsurfrules"
        elif ! grep -q ".windsurf/skills" "$TARGET_DIR/.windsurfrules"; then
             echo -e "\n/.windsurf/skills/**" >> "$TARGET_DIR/.windsurfrules"
        fi
        
        # Cursor
        mkdir -p "$TARGET_DIR/.cursor"
        copy_skills "$TARGET_DIR/.cursor/skills"
        
        # Claude
        mkdir -p "$TARGET_DIR/.claude"
        copy_skills "$TARGET_DIR/.claude/skills"

        # Antigravity
        mkdir -p "$TARGET_DIR/.agent"
        copy_skills "$TARGET_DIR/.agent/skills"
        ;;
esac

echo ""
echo "Success! Skills installed to '$TARGET_DIR'."
