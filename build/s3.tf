resource "aws_s3_bucket" "bucket" {
  bucket = "mnorman-io-books-bucket"
}

resource "aws_s3_object" "books" {
  for_each = fileset(path.module, "books/*")

  bucket = aws_s3_bucket.bucket.id
  key    = split("/", each.key)[1]
  source = each.key

  etag = filemd5(each.key)
}