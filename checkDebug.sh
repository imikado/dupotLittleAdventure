#!/bin/bash
grep "debug(" . -ri | grep gd | grep -v func | grep -v addons |  grep debug --color
