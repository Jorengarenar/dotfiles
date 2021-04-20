finish
syn clear cssDefinition
syn region cssDefinition transparent fold contains=cssTagName,cssAttributeSelector,cssClassName,cssIdentifier,cssAtRule,cssAttrRegion,css.*Prop,cssComment,cssValue.*,cssColor,cssURL,cssImportant,cssCustomProp,cssError,cssStringQ,cssStringQQ,cssFunction,cssUnicodeEscape,cssVendor,cssDefinition,cssHacks,cssNoise
      \ matchgroup=cssBraces
      \ start = '^\s*{'
      \ start = '\v%(,\n.*)@<!\{'
      \ start = '\v%(,\n.*)@<=%(\{\n)@<=.'
      \ end   = '}'
