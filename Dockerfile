FROM ubuntu:trusty

RUN apt-get update && \
    apt-get install -y wget git python-setuptools python-dev libavcodec-dev libavformat-dev libswscale-dev libjpeg62 libjpeg62-dev libfreetype6 libfreetype6-dev apache2 libapache2-mod-wsgi mysql-server-5.5 mysql-client-5.5 libmysqlclient-dev gfortran python-pip

RUN sudo pip install SQLAlchemy==1.0.0 && \
    sudo pip install wsgilog==0.3 && \
    sudo pip install cython==0.20 && \
    sudo pip install mysql-python==1.2.5 && \
    sudo pip install munkres==1.0.7 && \
    sudo pip install parsedatetime==1.4 && \
    sudo pip install argparse && \
    sudo pip install numpy==1.9.2 && \
    sudo easy_install pillow

RUN cd ~/ && \
    git clone https://github.com/cvondrick/turkic.git && \
    git clone https://github.com/cvondrick/pyvision.git && \
    git clone https://github.com/cvondrick/vatic.git && \
    cd turkic && \
    sudo python setup.py install && \
    cd ../pyvision && \
    sudo python setup.py install


COPY server.py /etc/apache2/sites-enabled/000-default.conf

RUN sudo cp /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled && \
    sudo apache2ctl graceful && \
    sudo echo ServerName localhost >> /etc/apache2/apache2.conf
