#!/bin/bash

export F=$(ls -t | tail -n +$1 | head -1)
echo $F

