#!/bin/bash
pgstop.sh; docker volume rm telluride-app_data; pgstart.sh; mix setup
