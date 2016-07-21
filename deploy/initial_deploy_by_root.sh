#!/bin/bash

cd /opt/build

(
cd buildbot/slave
pip install -e .
)
