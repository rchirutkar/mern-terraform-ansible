
- aws region: ap-south-1
- user: **terraform-user**
- group: TerraformAdmiins
- Policies: AmazonVPCFullAccess, AmazonEC2FullAccess, PowerUserAccess, AdministratorAccess, AmazonSSMManagedInstanceCore
- tag: Key(**project**) = Value(mern_terraform)
- tag: Key(**AKIAXDM6FVEX47H5X2EP**) = Value(terraform user created to handle mern stack)
- terraform-user tag description : terraform user created to handle mern stack
-  aws sts get-caller-identity --profile terraform-user :

`{                                            
    "UserId": "AIDAXDM6FVEXWXQ2XYCXY",
    "Account": "488347380015",
    "Arn": "arn:aws:iam::488347380015:user/terraform-user"
}`
- S3 Bucket name: `travelmemory-terraform-state-rchirutkar-ap-south-1`


- Elastic IP: http://3.7.133.46/