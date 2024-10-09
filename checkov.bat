@echo off

set PROJECT=%1

docker run --rm -v C:\Users\jankovj\Documents\projekty\csob-aws\infra\%PROJECT%:/tf bridgecrew/checkov --quiet --directory /tf