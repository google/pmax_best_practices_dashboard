#!/bin/bash
echo "run-docker script triggered"
ads_queries=$1
bq_queries=$2
ads_yaml=$3
gaarf $ads_queries -c=/config.yaml --ads-config=$ads_yaml
gaarf-bq $bq_queries/first/*.sql -c=/config.yaml
gaarf-bq $bq_queries/second/*.sql -c=/config.yaml
gaarf-bq $bq_queries/third/*.sql -c=/config.yaml
gaarf-bq $bq_queries/fourth/*.sql -c=/config.yaml
gaarf-bq $bq_queries/fifth/*.sql -c=/config.yaml