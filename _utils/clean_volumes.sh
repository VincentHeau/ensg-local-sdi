#!/bin/bash

# Liste les volumes inutilisés et les nettoye complètement
# -> permet d'éviter de laisser trainer des coquilles persistantes! :-)
for i in `docker volume ls -f dangling=true | awk '{print $2}' | grep -v VOL`
    do echo " >>> rm $i" && docker volume rm $i
done