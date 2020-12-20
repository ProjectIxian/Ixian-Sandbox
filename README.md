# Ixian Sandbox Docker Images
Ixian Sandbox includes Ixian DLT, Ixian S2 and Ixian Pool Docker images.  
Ixian Pool connects to the Ixian DLT service.  
All services in this container are pulled from GitHub and are built from source.  
For more information about specific service, see:  
**Ixian DLT** - https://github.com/ProjectIxian/Ixian-DLT  
**Ixian S2** - https://github.com/ProjectIxian/Ixian-S2  
**Ixian Pool** - https://github.com/ProjectIxian/Ixian-Pool  


## Prerequisites
To run the Ixian Sandbox docker container you will need to install Docker Compose, see: https://docs.docker.com/compose/install/#prerequisites


## How to use
Unix/Bash: To build and start the container, execute the following  
```
./sandbox up
```

Windows: To build and start the container, execute the following  
```
sandbox.bat up
```

Once the sandbox is started, you can access the services using your web browser:  
Ixian DLT: http://localhost:8081/  
Ixian S2: http://localhost:8001/  
Ixian Pool: https://localhost:443/  


## Sandbox commands
| Command     | Description                                         |
| ----------- | --------------------------------------------------- |
| **up**      | Creates and starts the sandbox environment.         |
| **create**  | Creates the sandbox environment.                    |
| **start**   | Starts the sandbox environment.                     |
| **stop**    | Stops the sandbox environment.                      |
| **down**    | Stops and destroys the sandbox environment.         |
| **build**   | Rebuilds the sandbox environment.                   |
| **clean**   | Removes the container and deletes temporary files.  |
| **exec**    | Executes a shell command for the specified service. |


