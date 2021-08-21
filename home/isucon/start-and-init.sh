#!/bin/bash
source /root/isucon/env-export.sh
cd /root/isucon/webapp/go
./isucondition &
curl -X POST http://localhost:3000/initialize