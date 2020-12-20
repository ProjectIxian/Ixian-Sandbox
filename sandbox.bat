@echo off

setlocal
title Ixian Sandbox

set BASENAME=ixian-base:18.04

call :sandbox %*

:createBase
  docker images %BASENAME% -q > tmp
	set /P baseExists=<tmp
  del tmp
	IF "%baseExists%"=="" (
    echo Building Ixian Base
		docker build -t %BASENAME% ./ixian-base
	)
EXIT /B 0


:create
  call :stop
  call :createBase
  docker-compose -p ixian create
EXIT /B 0

:up
  call :stop
  call :createBase
	docker-compose -p ixian up
EXIT /B 0

:down
	docker-compose -p ixian down
EXIT /B 0

:clean
  echo Ixian Sandbox containers will be removed.
  set /p confirmation="Are you sure you want to continue? (y/n): "
  IF "%confirmation%" == "y" (
    call :stop
    docker-compose -p ixian down --remove-orphans
    docker rmi ixian_ixian-pool ixian_ixian-s2 ixian_ixian-dlt --force
  ) ELSE (
    EXIT /B 1
  )
EXIT /B 0

:start
	docker-compose -p ixian start
EXIT /B 0

:stop
	docker-compose -p ixian stop
EXIT /B 0

:build
  call :down
  docker-compose -p ixian build
EXIT /B 0

:execute
  IF "%2%" == "" (
    echo Exec command requires service and command parameters.
    EXIT /B 1
  )
  set service=%1%
  docker-compose -p ixian exec -T %service% "%2%"
EXIT /B 0

:help
  echo Ixian Sandbox Help:
  echo   up       - creates and starts the sandbox environment.
  echo   create   - creates the sandbox environment.
  echo   start    - starts the sandbox environment.
  echo   stop     - stops the sandbox environment.
  echo   down     - stops and destroys the sandbox environment.
  echo   build    - rebuilds the sandbox environment.
  echo   clean    - removes the container and deletes temporary files.
  echo   exec     - executes a shell command for the specified service.
EXIT /B 0

:sandbox
  IF "%1%"=="up" (
    call :up
  ) ELSE IF "%1%"=="down" (
    call :down
  ) ELSE IF "%1%"=="create" (
    call :create
  ) ELSE IF "%1%"=="start" (
    call :start
  ) ELSE IF "%1%"=="stop" (
    call :stop
  ) ELSE IF "%1%"=="exec" (
    call :execute %2 %3
  ) ELSE IF "%1%"=="build" (
    call :build
  ) ELSE IF "%1%"=="clean" (
    call :clean
  ) ELSE IF "%1%"=="help" (
    call :help
  ) ELSE (
    echo Error: Unknown command '%1%'
    call :help
    EXIT /B 1
  )
EXIT /B 0