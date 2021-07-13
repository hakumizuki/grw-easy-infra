# 既に AWS VPC で 20.20.0.0/16 の範囲を使っている方は他の数値に変更してください (30.30 など)
variable "vpc_cidr_network" {
  default = "20.20"
}

# ご自身で作ったS3 Bucketの名前を入力してください
variable "s3_bucket_name" {
  default = "ここは必ず入力"
}

# ご自身で作ったDynamoDB Tableの名前を入力してください
variable "dynamodb_table_name" {
  default = "ここは必ず入力"
}

# ssh接続したい場合は、 ec2.tf の 27行目をコメントアウトしてください
variable "access_key_name" {
  default = "ec2インスタンスにssh接続したい人のみ入力"
}
