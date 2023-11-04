#!/bin/bash
# Source folder containing the files you want to symlink
source_folder="./src"

# Destination folder (your home directory)
destination_folder="$HOME"

# Function to create symlinks for files in a directory
create_symlinks() {
  local src_dir="$1"
  local dest_dir="$2"

  # Iterate through the files in the source directory and create symlinks
  for file in "$src_dir"/*; do
    if [ -f "$file" ]; then
      # If it's a regular file, create a symlink in the destination directory
      local filename=$(basename "$file")
      ln -s "$file" "$dest_dir/$filename"
      echo "Symlink created: $dest_dir/$filename"
    elif [ -d "$file" ]; then
      # If it's a directory, create a corresponding directory in the destination directory
      local dirname=$(basename "$file")
      mkdir -p "$dest_dir/$dirname"
      echo "Created directory: $dest_dir/$dirname"
      # Recursively call the function to handle files in the subdirectory
      create_symlinks "$file" "$dest_dir/$dirname"
    fi
  done
}

# Check if the source folder exists
if [ ! -d "$source_folder" ]; then
  echo "Source folder does not exist: $source_folder"
  exit 1
fi

# Check if the destination folder exists
if [ ! -d "$destination_folder" ]; then
  echo "Destination folder does not exist: $destination_folder"
  exit 1
fi

# Call the function to create symlinks and handle subdirectories
create_symlinks "$source_folder" "$destination_folder"

echo "All symlinks and directories created successfully."
