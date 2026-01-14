#!/bin/bash

# Setup script for Agent Skills

echo "Setting up Agent Skills..."

# Windsurf setup
if [ -f ".windsurfrules" ]; then
    echo "Windsurf rules detected."
else
    echo "Creating basic .windsurfrules..."
    cat > .windsurfrules <<EOF
# Windsurf Rules

# Include skills directory as knowledge base.
# Windsurf will index these files to provide context-aware assistance.
/skills/**
EOF
    echo "Created .windsurfrules."
fi

echo "Setup complete! You can now use skills with your agent."
