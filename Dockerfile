FROM ubuntu:trusty

RUN apt-get update && \
    apt-get install -y wget git python-setuptools python-dev libavcodec-dev libavformat-dev libswscale-dev libjpeg62 libjpeg62-dev libfreetype6 libfreetype6-dev apache2 libapache2-mod-wsgi mysql-server-5.5 mysql-client-5.5 libmysqlclient-dev gfortran python-pip && \
    # the add-apt-repository command isn't included in ubuntu. we'll get it here.
    apt-get -y install software-properties-common python-software-properties && \
    add-apt-repository ppa:mc3man/trusty-media -y && \
    sudo apt-get dist-upgrade && \
    apt-get update && \
    apt-get -y install ffmpeg gstreamer0.10-ffmpeg

RUN sudo pip install SQLAlchemy==1.0.0 && \
    sudo pip install wsgilog==0.3 && \
    sudo pip install cython==0.20 && \
    sudo pip install mysql-python==1.2.5 && \
    sudo pip install munkres==1.0.7 && \
    sudo pip install parsedatetime==1.4 && \
    sudo pip install argparse && \
    sudo pip install numpy==1.9.2 && \
    sudo pip install Pillow


RUN cd /root && \
    git clone https://github.com/cvondrick/turkic.git && \
    git clone https://github.com/cvondrick/pyvision.git && \
    git clone https://github.com/cvondrick/vatic.git && \
    cd /root/turkic && \
    sudo python setup.py install && \
    cd /root/pyvision && \
    sudo python setup.py install


COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY apache2.conf /etc/apache2/apache2.conf

RUN sudo cp /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled && \
    sudo apache2ctl graceful && \

RUN sudo /etc/init.d/mysql start && \
    mysql -u root --execute="CREATE DATABASE vatic;"

COPY config.py /root/vatic/config.py

# We need to adjust some of these guys's import statements...
RUN sed  -i'' "s/import Image/from PIL import Image/" \
    /usr/local/lib/python2.7/dist-packages/pyvision-0.3.1-py2.7-linux-x86_64.egg/vision/frameiterators.py
    /usr/local/lib/python2.7/dist-packages/pyvision-0.3.1-py2.7-linux-x86_64.egg/vision/ffmpeg.py \
    /usr/local/lib/python2.7/dist-packages/pyvision-0.3.1-py2.7-linux-x86_64.egg/vision/visualize.py \
    /root/vatic/models.py \
    /root/vatic/cli.py \
    /usr/local/lib/python2.7/dist-packages/pyvision-0.3.1-py2.7-linux-x86_64.egg/vision/pascal.py

RUN sudo /etc/init.d/mysql start && \
    cd /root/vatic
    turkic setup --database && \
    turkic setup --public-symlink

RUN sudo chown -R 755 /root/vatic/public && \
    sudo apache2ctl restart