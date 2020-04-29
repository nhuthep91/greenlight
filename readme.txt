/*********************************/
Using root account for all process
Git branch is: feature/20200414_TrinhNX#HandlingLoginCodeFromATM
/*********************************/
1. Change directory to ~/greenlight
2. Check docker_images_access.sh and docker_images_build.sh file enables execution mode (chmod 700)?
3. Run script: ./docker_images_build.sh, the process will be following
a. Pull out latest source code from git
b. Stop docker image
c. Invoke Greenlight build script 
d. Start docker image
4. You can access docker image using ./docker_images_access.sh

NOTE: I had modified Greenlight build script in this branch so if you switch to other branch,
check carefully about the image in docker-compose.yml file
