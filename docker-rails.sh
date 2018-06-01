#!/bin/bash
docker exec -it -u $(id -u):$(id -g) cojt-board-project_rails_1 $@
