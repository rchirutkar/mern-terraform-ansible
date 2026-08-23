> Create a Minimal Custom Policy (Least Privilege)
If organization requires strict security boundaries, we can create a custom IAM policy with only the exact permission requested.

Go to IAM -> Policies -> Create policy.

Give the policy a name (e.g., TerraformMinimalVpcPolicy), save it, and attach it to the terraform-user.

Switch to the JSON tab and paste the following policy:

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "TerraformVpcPermissions",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateVpc"
            ],
            "Resource": "*"
        },
        {
            "Sid": "TerraformEC2DescribePermissions",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeImages",
                "ec2:DescribeInstances",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups"
            ],
            "Resource": "*"
        },
        {
            "Sid": "TerraformIamRoleManagement",
            "Effect": "Allow",
            "Action": [
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:GetRole",
                "iam:UpdateRole",
                "iam:PassRole",
                "iam:AttachRolePolicy",
                "iam:DetachRolePolicy",
                "iam:PutRolePolicy",
                "iam:DeleteRolePolicy"
            ],
            "Resource": "arn:aws:iam::488347380015:role/travelmemory-assignment-ec2-role"
        }
    ]
}

