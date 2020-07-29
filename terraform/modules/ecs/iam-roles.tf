resource aws_iam_role "ecs" {
  name = "${var.project_name}-ecs-role"
  assume_role_policy = jsonencode(
    {
      Version = "2008-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "ecs.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_policy" "ecrpolicy" {
  name        = "ecrpolicy"
  path        = "/"
  description = "Policy to access ECR"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "ecs1" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role_policy_attachment" "ecs2" {
  role       = aws_iam_role.ecs.name
  policy_arn = "${aws_iam_policy.ecrpolicy.arn}"
}

