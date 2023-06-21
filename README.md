# Description
This repository contains a simple XML parser implemented using Flex (the fast lexical analyzer) and Bison (the GNU parser generator). The parser is designed to parse an XML-like language and perform various validations on the structure and attributes of the XML elements.

# Features
- Parses XML-like language using Flex and Bison.\n
- Validates the structure and attributes of XML elements.
- Handles mandatory and optional attributes.
- Performs checks on numeric attribute values.
- Supports custom error reporting for invalid input.
- Includes a Makefile for building the parser executable.

# Getting Started
1. Clone the repository.
2. Change into the cloned directory.
3. Build the XML parser:

```
make
```
4. Run the parser with an input file:
```
./xml_parser test_file.xml
```
Replace input.xml with the path to your XML input file.
