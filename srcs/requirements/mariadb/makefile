all:
	@docker build . -t mariadb
	@docker run --env-file ./.env -it mariadb bash 

d:
	@docker build . -t mariadb
	@docker run  --env-file ./.env mariadb
dd:
	@docker exec -it mariadb bash

clean: 
	@docker stop $$(docker ps -qa);\
	docker rm $$(docker ps -qa);\
	docker rmi -f $$(docker images -qa);\
	docker volume rm $$(docker volume ls -q);\
	docker network rm $$(docker network ls -q);\

.PHONY: all clean