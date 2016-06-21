FROM ubuntu:14.04
RUN apt-get install -y openjdk-7-jdk build-essential git
RUN git clone https://github.com/lucidsoftware/closure-typescript-example.git
RUN cd closure-typescript-example
RUN make deps
CMD /bin/bash 
