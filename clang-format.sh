if which clang-format >/dev/null; then
  for folder in Samples SamplesTests SamplesUITests Sources
  do
    for ext in h c cpp m mm
    do
      find ./$folder -iname *.$ext | xargs clang-format --style=Chromium -i
    done
  done
else
  echo "warning: ClangFormat not installed, download from http://clang.llvm.org/docs/ClangFormat.html or brew install clang-format"
fi
