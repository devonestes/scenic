#!/bin/bash
# This script allows a user to bump the version number for this library.
# It provides helpful prompts, and will even commit your changes for you with a
# helpful message if possible!

# This tells the script to fail immediately if any command fails. That's good
# and safe!
set -e

# Things introduced in this script
# Assigning variables
# Pipelines
# Caputring the STDOUT of a pipeline and assigning that to a variable
# cat
# grep
# echo
# exit
# read
# sed
# case
# if
# test
# wc
# algabraic expansion (aka math)
# There are no types! It's all based on context!!??

echo "Let's bump the version number for this library, shall we?"
echo "Should it be a major, minor, or patch version?"
echo "Enter 1 for major, 2 for minor, and 3 for patch"
echo -n "> "
read version

numbers="[0-9][0-9]*"
current_version=$(cat lib/scenic/version.rb | grep -o "$numbers\.$numbers\.$numbers")
major=$(echo $current_version | grep -o "^$numbers")
minor=$(echo $current_version | grep -o "\.$numbers\." | grep -o "$numbers")
patch=$(echo $current_version | grep -o "$numbers$")

case $version in
  1)
    new_version="$((major + 1)).0.0"
    ;;
  2)
    new_version="$major.$((minor + 1)).0"
    ;;
  3)
    new_version="$major.$minor.$((patch + 1))"
    ;;
esac

# Actually make the change to the file.
#
# -i makes the change in place, and it takes an ending for a backup version of
# the file. If you pass nothing, then it doesn't make a backup version.
sed -i "" "s/$current_version/$new_version/" lib/scenic/version.rb

# If the only file in the git diff is our updated version file, then we can add
# it and commit!
if test $(git status -s | wc -l) = 1; then
  git add lib/scenic/version.rb
  git commit -m "Bumped version to $new_version from $current_version"
else
  echo "Multiple files have changed. I can't automate here - I'll need a human"
  echo "to look at this and make a human decision."
fi

exit 0

# 31 actual lines of code
# 24 minus UI stuff
# 11 of which is that case statement
# so, let's actually call this about 13 lines of code!
