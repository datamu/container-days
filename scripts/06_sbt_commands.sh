# Run Models
spark-submit --class "com.zoi.xgb.DemoTest" xgboost_2.11-1.0.jar /home/krishna/zoi/ci_cd_repo/data/proc.csv
spark-submit --class "com.zoi.xgb.DemoDT" xgboost_2.11-1.0.jar /home/krishna/zoi/ci_cd_repo/data/proc.csv
spark-submit --class "com.zoi.xgb.DemoLR" xgboost_2.11-1.0.jar /home/krishna/zoi/ci_cd_repo/data/proc.csv

# SBT Console Commands
sbt
# Check out Library Deps
libraryDependencies
# Compile
compile
# Run
run

# SBT Build JAR
sbt clean package