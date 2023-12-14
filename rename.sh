#!/bin/bash

# Set the base directory to the directory where the script is located
baseDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Loop through all files in the base directory and its subdirectories
find "$baseDir" -type f -name "jlp_*" | while read file; do
    # Extract directory path
    dir=$(dirname "$file")

    # Extract the basename and rename
    baseName=$(basename "$file")
    newBaseName=${baseName/jlp_/flux_}
    mv "$file" "$dir/$newBaseName"
done

echo "Renaming complete."
