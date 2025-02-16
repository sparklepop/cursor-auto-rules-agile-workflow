#!/bin/bash

# Check if target directory is provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide the target project directory"
    echo "Usage: ./apply-rules.sh <target-project-directory>"
    exit 1
fi

TARGET_DIR="$1"

# Check if target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target directory '$TARGET_DIR' does not exist"
    exit 1
fi

# Create .cursor/rules directory if it doesn't exist
mkdir -p "$TARGET_DIR/.cursor/rules"

# Copy all rule files
echo "Copying rule files..."
cp -n .cursor/rules/*.mdc "$TARGET_DIR/.cursor/rules/"

# Create docs directory if it doesn't exist
mkdir -p "$TARGET_DIR/docs"

# Create workflow documentation
cat > "$TARGET_DIR/docs/workflow-rules.md" << 'EOL'
# Cursor Workflow Rules

This project uses the Cursor AI workflow rules template from [cursor-auto-rules-agile-workflow](https://github.com/bmadcode/cursor-auto-rules-agile-workflow).

> **Note**: This script can be safely re-run at any time to update the template rules to their latest versions. It will not impact or overwrite any custom rules you've created. This allows you to receive improvements and updates to the template rules as they become available.

The template provides:
- Automated rule generation
- Agile workflow integration
- Standardized documentation formats
- AI behavior control

For more information, please refer to the template repository.

> **Note**: This documentation file can be safely removed if desired, as it serves only as an informational marker that the template has been applied.
EOL

# Update .gitignore if needed
if [ -f "$TARGET_DIR/.gitignore" ]; then
    if ! grep -q "\.cursor/rules/_\*\.mdc" "$TARGET_DIR/.gitignore"; then
        echo -e "\n# Private individual user cursor rules\n.cursor/rules/_*.mdc" >> "$TARGET_DIR/.gitignore"
    fi
else
    echo -e "# Private individual user cursor rules\n.cursor/rules/_*.mdc" > "$TARGET_DIR/.gitignore"
fi

echo "✅ Successfully transferred rules to $TARGET_DIR"
echo "📁 Rules location: $TARGET_DIR/.cursor/rules/"
echo "📄 Documentation added: $TARGET_DIR/docs/workflow-rules.md"
echo "🔒 Updated .gitignore to protect private rules" 