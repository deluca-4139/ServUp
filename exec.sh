#!/bin/bash

while read d;
do
	/servup/test_ssh.sh $d
done < /servup/servup-ssh.cfg

while read e;
do
	/servup/test_web.sh $e
done < /servup/servup-web.cfg
