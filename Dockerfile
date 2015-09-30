# chinese_docker 的 Dockerfile

FROM ubuntu:14.04

MAINTAINER  http://www.widuu.com widuu <admin@widuu.com>

# 使用阿里云镜像源

RUN  mv /etc/apt/sources.list /etc/apt/sources.list.backup

ADD ./sources.list /etc/apt/sources.list

# 更新镜像源 

RUN apt-get update

# 安装环境

RUN apt-get  install gcc make libssl-dev curl nginx git -y

# 安装ssh

RUN apt-get install -y openssh-server

RUN mkdir -p /var/run/sshd

RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 下载node

RUN curl -o /opt/node.tar.gz http://oss.npm.taobao.org/dist/node/v4.0.0/node-v4.0.0-linux-x64.tar.gz && \
    tar zxf /opt/node.tar.gz 

# 安装gitbook-cli

RUN	/node-v4.0.0-linux-x64/bin/npm install gitbook-cli -g && \
	cd /usr/local/bin && \
	ln -sf /node-v4.0.0-linux-x64/bin/* . 
# 从github clone chinese_docker 并且build

RUN	cd /usr/share/nginx/html && \
	git clone https://github.com/widuu/chinese_docker.git && \
	cd chinese_docker && \
	gitbook build && \
	mv /usr/share/nginx/html/chinese_docker/_book/* /usr/share/nginx/html && \
	rm -rf /usr/share/nginx/html/chinese_docker/

# 设置root ssh远程登录密码为docker

RUN echo 'root:dgj99349' | chpasswd

# 开放端口

EXPOSE 22 80 443

# 开启服务

COPY start.sh start.sh

CMD ["start.sh"]
