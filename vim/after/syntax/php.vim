if php_folding
  call AppendToSynRule("phpRegion", "region", "fold")
  " syn region foo start="\v%(function)@<= \ze\S.*\(.*\)\n\s*\{" end="}" fold transparent containedin=phpRegion
endif
