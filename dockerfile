/*
G20210921010072
构建本地镜像
编写 Dockerfile 将练习 2.2 编写的 httpserver 容器化
将镜像推送至 docker 官方镜像仓库
通过 docker 命令本地启动 httpserver
通过 nsenter 进入容器查看 IP 配置
*/
------------------Makefile---------------------
export tag=v1.0
root:
	export ROOT=github.com/cncamp/golang

build:
	echo "building myserver binary"
	mkdir -p bin/amd64
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o bin/amd64 .

release: build
	echo "building myserver container"
	docker build -t cncamp/myserver:${tag} .

push: release
	echo "pushing cncamp/myserver"
	docker push cncamp/myserver:v1.0


-------------Dockerfile----------------
FROM ubuntu
FROMgolang:1.17-alpine AS build
ENV MY_SERVICE_PORT=80
ENV MY_SERVICE_PORT1=80
ENV MY_SERVICE_PORT2=80
ENV MY_SERVICE_PORT3=80
LABEL multi.label1="value1" multi.label2="value2" other="value3"
ADD bin/amd64/myserver /myserver
EXPOSE 80
ENTRYPOINT /myserver 


-----------------运行服务，查看相应ip配置------
1：make push
2:运行容器
docker run -d myserver
3：查看服务进程
docker ps|grep myserver
4：获取pid
docker inspect 3edb641689f4 |grep -i pid
345428
5：进入容器
nsenter -n -t 345428
6:查看IP配置 
ip addr
