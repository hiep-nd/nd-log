if which swiftlint >/dev/null; then
  swiftlint autocorrect
  swiftlint --no-cache
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint or brew install swiftlint"
fi
