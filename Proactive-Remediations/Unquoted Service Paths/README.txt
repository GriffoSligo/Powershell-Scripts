# Fix Unquoted Service Path Vulnerabilities Script

This repository contains a PowerShell script for identifying and fixing unquoted service path vulnerabilities on Windows systems.

## Overview

Unquoted service path vulnerabilities can be a security risk in Windows environments. This script automates the process of identifying these vulnerabilities and provides guidance on how to manually fix them.

## Usage

1. **Finding Unquoted Service Paths**: Run `FixUnquotedServicePaths.ps1` with administrative privileges. This will identify any services with unquoted paths and save the output to `UnquotedServicePaths.txt`.

2. **Fixing the Paths**: Due to the sensitivity of registry edits, this script provides instructions for manual intervention to fix the identified paths.

## Warning

Modifying the Windows Registry can have significant implications. Always backup the registry before making changes and proceed with caution.

## Contributions

Contributions to this script are welcome. Please submit pull requests or issues as needed.
