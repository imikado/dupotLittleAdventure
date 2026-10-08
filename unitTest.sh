#!/bin/bash
# Lance les tests unitaires GUT (configuration dans .gutconfig.json)
godot --headless --path "$PWD" -s addons/gut/gut_cmdln.gd "$@"
