#  **docker_upstream_check**

A simple bash script to compare upstream docker repo to forked repo and update using github actions on ubuntu or debian variants.

## **Requirements**

 - [ ] Ubuntu or debian based OS for dpkg support
 - [ ] JQ package

## How to use

I recomend setting up github actions and hosting your docker repo on github. You can setup a cron job and run this script periodically. If there are any updates to the upstream docker repo it will push a modifcation to your github repo and initiate the rebuild from the docker upstream using github actions.


