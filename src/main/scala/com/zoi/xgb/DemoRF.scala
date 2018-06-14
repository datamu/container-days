package com.zoi.xgb

import org.apache.spark.ml.feature.{VectorAssembler}
import org.apache.spark.ml.regression.{RandomForestRegressionModel, RandomForestRegressor}
import org.apache.spark.sql.{Dataset, SparkSession}
import org.apache.spark.ml.evaluation.RegressionEvaluator


object  DemoRF {

  def test_eval(data:Dataset[_], model:RandomForestRegressionModel): Unit = {


    val predictions = model.transform(data)
    val evaluator = new RegressionEvaluator()
      .setMetricName("rmse")
      .setLabelCol("label")
      .setPredictionCol("prediction")

    val rmse = evaluator.evaluate(predictions)
    println(s"test rmse: ${rmse}")
  }


  def main(args: Array[String]){

    val DATA_PATH = args(0)

    val spark = SparkSession
      .builder()
      .appName("DT App")
      .getOrCreate()

    val data = spark.read.format("csv")
      .option("header", "true")
      .option("inferSchema", "true")
      .load(DATA_PATH)

    val assembler =  new VectorAssembler()
      .setInputCols(Array("hour", "weekday"))
      .setOutputCol("features")

    val output = assembler.transform(data)

    val prep_data = output.withColumnRenamed("energy", "label")



    val splits = prep_data.randomSplit(Array(0.7, 0.3))
    val (trainingData, testData) = (splits(0), splits(1))
    trainingData.cache()

    val model = new RandomForestRegressor()

    val dtModel = model.fit(trainingData)

    test_eval(testData, dtModel)

    spark.stop()

  }
}