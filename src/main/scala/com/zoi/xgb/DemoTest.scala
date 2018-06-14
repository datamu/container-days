package com.zoi.xgb

import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.ml.feature.{LabeledPoint, VectorAssembler}
import org.apache.spark.ml.linalg.DenseVector
import org.apache.spark.sql.types.{DoubleType, StructField, StructType}
import org.apache.spark.ml.linalg.SQLDataTypes.VectorType
import org.apache.spark.sql.SparkSession


object DemoTest {
  def main(args: Array[String]){

    //val DATA_PATH = "/home/krishna/zoi/ci_cd_repo/data/proc.csv"
    val DATA_PATH = args(0)

    val spark = SparkSession
      .builder()
      .appName("Test App")
      .getOrCreate()

    val data = spark.read.format("csv")
      .option("header", "true")
      .option("inferSchema", "true")
      .load(DATA_PATH)

    data.cache()
    data.printSchema()

    spark.stop()

  }
}