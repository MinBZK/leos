#!/usr/bin/env bash

cd /app/leos/tools/user-repo/web
mvn spring-boot:run &

cd /app/leos/tools/repository/web
mvn spring-boot:run -Dspring-boot.run.directories=/app/leos/tools/repository/config/target/generated-config &

cd /app/leos/modules/web
mvn jetty:run-war &

cd /app/leos/tools/akn4euutil/web
mvn spring-boot:run -Dspring-boot.run.directories=/app/leos/tools/akn4euutil/config/target/generated-config

# cd /app/annotate/web
# mvn spring-boot:run -Dspring-boot.run.profiles=h2 -Dspring-boot.run.directories=/app/annotate/config/target/generated-config