#!/bin/bash

curl -XGET "http://52.35.80.198:9201/usa/_search?q=text:apple&size=10000&pretty=true&jsonp=jQuery1120022374165642402932_1457203831105&_=1457203831106" > apple.txt

curl -XGET "http://52.35.80.198:9201/usa/_search?q=text:google&size=10000&pretty=true&jsonp=jQuery1120022374165642402932_1457203831105&_=1457203831106" > google.txt

curl -XGET "http://52.35.80.198:9201/usa/_search?q=text:happy&size=10000&pretty=true&jsonp=jQuery1120022374165642402932_1457203831105&_=1457203831106" > happy.txt

curl -XGET "http://52.35.80.198:9201/usa/_search?q=text:sad&size=10000&pretty=true&jsonp=jQuery1120022374165642402932_1457203831105&_=1457203831106" > sad.txt

curl -XGET "http://52.35.80.198:9201/usa/_search?q=text:good&size=10000&pretty=true&jsonp=jQuery1120022374165642402932_1457203831105&_=1457203831106" > good.txt

curl -XGET "http://52.35.80.198:9201/usa/_search?q=text:bad&size=10000&pretty=true&jsonp=jQuery1120022374165642402932_1457203831105&_=1457203831106" > bad.txt

curl -XGET "http://52.35.80.198:9201/usa/_search?q=text:iphone&size=10000&pretty=true&jsonp=jQuery1120022374165642402932_1457203831105&_=1457203831106" > iphone.txt

curl -XGET "http://52.35.80.198:9201/usa/_search?q=text:camera&size=10000&pretty=true&jsonp=jQuery1120022374165642402932_1457203831105&_=1457203831106" > camera.txt

curl -XGET "http://52.35.80.198:9201/usa/_search?q=text:music&size=10000&pretty=true&jsonp=jQuery1120022374165642402932_1457203831105&_=1457203831106" > music.txt

curl -XGET "http://52.35.80.198:9201/usa/_search?q=text:coffee&size=10000&pretty=true&jsonp=jQuery1120022374165642402932_1457203831105&_=1457203831106" > coffee.txt

Rscript --vanilla createGeoJSON.R apple google happy sad good bad iphone camera music coffee

aws s3 cp output s3://homework1-json/ --recursive