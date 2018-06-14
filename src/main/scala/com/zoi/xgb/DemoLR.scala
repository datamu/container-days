package com.zoi.xgb

import org.apache.spark.ml.feature.{VectorAssembler}
import org.apache.spark.ml.regression.{LinearRegression, LinearRegressionModel}
import org.apache.spark.sql.{Dataset, SparkSession}
import org.apache.spark.ml.evaluation.RegressionEvaluator
import Console.{RED,RESET}

object  DemoLR {

  def test_eval(data:Dataset[_], model:LinearRegressionModel): Unit = {

    // Model Summary
    val trainingSummary = model.summary
    println(s"model r2: ${trainingSummary.r2}")

    val predictions = model.transform(data)
    val evaluator = new RegressionEvaluator()
                    .setMetricName("rmse")
                    .setLabelCol("label")
                    .setPredictionCol("prediction")

    val rmse = evaluator.evaluate(predictions)
    Console.println(s"${RESET}${RED}test rmse: ${rmse}${RESET}")
  }


  def main(args: Array[String]){

    val DATA_PATH = args(0)

    val spark = SparkSession
      .builder()
      .appName("LR App")
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

    val lr = new LinearRegression()
      .setMaxIter(10)
      .setRegParam(0.3)
      .setElasticNetParam(0.8)

    val lrModel = lr.fit(trainingData)

    test_eval(testData, lrModel)

    spark.stop()

  }
}