// IAM Role
data "aws_iam_policy_document" "assume_role" {
  policy_id = "${local.name}-lambda"
  version   = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${local.name}-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "logs" {
  policy_id = "${local.name}-lambda-logs"
  version   = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]

    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/lambda/${local.name}*:*"
    ]
  }
}

resource "aws_iam_policy" "logs" {
  name   = "${local.name}-handler-logs"
  policy = data.aws_iam_policy_document.logs.json
}

resource "aws_iam_role_policy_attachment" "logs" {
  depends_on = [aws_iam_role.lambda, aws_iam_policy.logs]
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.logs.arn
}

// Lambda Handler

resource "null_resource" "go_build" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "GOOS=linux GOARCH=amd64 go build -o bin/mnorman-io-handler ../cmd/mnorman-io-handler"
  }
}

data "archive_file" "lambda_zip" {
  depends_on  = [null_resource.go_build]
  type        = "zip"
  source_file = "bin/mnorman-io-handler"
  output_path = "bin/mnorman-io-handler.zip"
}

resource "aws_lambda_function" "func" {
  depends_on       = [data.archive_file.lambda_zip]
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${local.name}-handler"
  role             = aws_iam_role.lambda.arn
  handler          = "${local.name}-handler"
  runtime          = "go1.x"
  memory_size      = 1024
  timeout          = 30
}