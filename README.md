#  **docker_upstream_check**

Two simple bash script to compare upstream docker repo to forked repo. Use docker_upstream_check_push to update a GIT repo that uses github actions.

## **Requirements**

 - [ ] Ubuntu or debian based OS for dpkg support
 - [ ] JQ package
 - [ ] GIT if using docker_upstream_check_push (optional)

## How to use

I recomend setting up github actions and hosting your docker repo on github. You can setup a cron job and run this script periodically. If there are any updates to the upstream docker repo it will push a modifcation to your github repo and initiate the rebuild from the docker upstream using github actions.


