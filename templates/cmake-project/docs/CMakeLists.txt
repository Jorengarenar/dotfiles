find_package(Doxygen)
if(DOXYGEN_FOUND)

  if(NOT ONLY_DOCS)
    set(DOXYGEN_QUIET YES)
  endif()

  set(DOXYGEN_EXCLUDE_PATTERNS
    */build/*
    */extern/*
    */tests/*
    )

  # set(DOXYGEN_IMAGE_PATH            "../res/")
  # set(DOXYGEN_HTML_EXTRA_STYLESHEET custom.css)
  # set(DOXYGEN_LAYOUT_FILE           layout.xml)

  set(DOXYGEN_EXAMPLE_PATH ${PROJECT_SOURCE_DIR}/examples)
  set(DOXYGEN_USE_MDFILE_AS_MAINPAGE README.md)

  set(DOXYGEN_EXTRACT_ALL     YES)
  set(DOXYGEN_EXTRACT_PRIVATE YES)
  set(DOXYGEN_EXTRACT_STATIC  YES)

  set(DOXYGEN_ALPHABETICAL_INDEX     NO)
  set(DOXYGEN_ALWAYS_DETAILED_SEC    NO)
  set(DOXYGEN_GENERATE_TREEVIEW      YES)
  set(DOXYGEN_OPTIMIZE_OUTPUT_FOR_C  NO)
  set(DOXYGEN_REPEAT_BRIEF           NO)
  set(DOXYGEN_SOURCE_BROWSER         YES)
  set(DOXYGEN_STRIP_FROM_PATH        "${CMAKE_SOURCE_DIR}")

  set(DOXYGEN_EXTRACT_ALL    YES)
  set(DOXYGEN_EXTRACT_STATIC YES)

  set(DOXYGEN_PREDEFINED         DOXYGEN)
  set(DOXYGEN_EXCLUDE_SYMBOLS    DOXYGEN_*)
  set(DOXYGEN_EXPAND_AS_DEFINED  DOXYGEN_UNNAMED)
  set(DOXYGEN_MACRO_EXPANSION    YES)

  doxygen_add_docs(docs ${CMAKE_SOURCE_DIR} ALL)

else(DOXYGEN_FOUND)
  message(WARNING "Doxygen needs to be installed to generate documentation")
endif(DOXYGEN_FOUND)
