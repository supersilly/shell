#!/bin/bash
curl -L -d "username=jiru&password=123456" http://192.168.23.104:8883/manage/login | grep "您好"
