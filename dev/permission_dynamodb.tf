##################################################################################################################
## --Role-- ######################################################################################################
resource "aws_iam_role" "iam_role" {
    name = "role_assume"
    assume_role_policy = "${data.aws_iam_policy_document.policy_document.json}"
}

data "aws_iam_policy_document" "policy_document" {
    statement {
        actions = [
            "sts:AssumeRole"
        ]

        principals {
            type        = "Service"
            identifiers = [
                "apigateway.amazonaws.com",
                "lambda.amazonaws.com",
                "dynamodb.amazonaws.com"
            ]
        }

        principals {
            type = "AWS"
            identifiers = [
                "arn:aws:iam::385680495520:user/terraform_user"
            ]
        }
    }
}
##################################################################################################################
## --Policy-- ####################################################################################################
resource "aws_iam_policy" "iam_policy" {
    name = "policy_dynamodb"
    policy = "${data.aws_iam_policy_document.policy_document_policy.json}"
}

data "aws_iam_policy_document" "policy_document_policy" {
    statement {
        effect = "Allow"
        actions = [
            "dynamodb:PutItem"
        ]

        resources = [
            "arn:aws:dynamodb:us-east-1:385680495520:table/*"
        ]
    }
}
##################################################################################################################
## --Attachment-- ################################################################################################

resource "aws_iam_role_policy_attachment" "policy_attachment" {
    role        = "${aws_iam_role.iam_role.name}"
    policy_arn  = "${aws_iam_policy.iam_policy.arn}"
}

resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
    user        = "terraform_user"
    policy_arn  = "${aws_iam_policy.iam_policy.arn}"
}
