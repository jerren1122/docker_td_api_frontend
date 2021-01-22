**Input**

There are two levels of input that are necessary to discuss for the front end

*Go Layer* 

The API constructed from the Go code receives a Movie value and a Method value in JSON

{
"Movie": "sdhsdfhdfsh" 
"Method": "return_article"
}

*building the go project*

This link is very helpful: https://medium.com/the-andela-way/build-a-restful-json-api-with-golang-85a83420c9da
Additionally if you have go installed 
within the api directory utilizing 'go build' and './api' (as this is the name of the executable that go generates) will locate the main package and execute accordingly. 

*Ruby Layer* 

There is some conditioning in both the Go File to the JSON as well as in the Ruby file to the received JSON in order to get a
formatted hash that Ruby can manipulate. 

Additionally the method arg passed to the ruby script determines what method executes. 

The method that executes actually interacts with the other API's that are hosted locally or within a docker network. 

This additional API's have their own git Repo's: https://github.com/jerren1122/go_ny_times_api.git and https://github.com/jerren1122/omdb_go_database_hidden.git

In the compilation.rb script there are dynamic methods that pickup environment variables to determine if the endpoints are hosted on localhost(windows setup) or within the docker container. 

**Docker**

*Dockerfiles* 

This repo houses the Dockerfiles for the front end image, the ny_times image, the omdb image and
the docker_ruby_go image

The docker_ruby_go image is the from image for all of the others constructed therefore it must exist locally or at whatever docker registry is constructed.  

*Docker Compose*

The Docker Compose file is dependent on all images that are listed existing locally or in the docker registry you are utilizing

Need to utilize docker-compose up --force-recreate as these images wont function otherwise. They build a go executable and if we don't get fresh containers that executable will 
already exist. 

Within this compose file we set hostnames for both the omdb and ny times containers that way we can reach out via <hostname>:<port> within the other containers in order to interact accordingly

Additionally for the front end service we pass the hostnames as environment variables that are picked up by the ruby script and utilized to interact with the omdb and ny_times endpoints. 

We additionally publish only the front end api so that it is reachable on the machine running the compose file. 