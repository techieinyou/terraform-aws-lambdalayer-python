# Lambda Layer for Python Libraries
When your Lambda need to import libraries, packaing all libraries along with your business logic is not recommended.  Instead you can upload libraries as Lambda Layers, so that multiple Lambda functions can access same layer.  

This module will create an AWS Lambda Layer with ANY Python library you like.   This module is published in Terraform as [**TechieInYou/lambdalayer-python/aws**](https://registry.terraform.io/modules/techieinyou/lambdalayer-python/aws/latest). 

## How this module works?
You can assign the name of library you want to install to the variable __library_name__ .  This module will

    1. create a local folder `lambdalayer` 
    2. install the library (using pip3) in the above folder
    3. after succussfull installation, it will package the folder
    4. create a Lambda Layer in AWS and will upload the package
    5. return the ARN of the Lambda Layer with version #


## Other Variables can be assigned 

### Layer Name (Optional)
You can assign the Lambda Layer name by assigning variable __layer_name__.  If not provided, then the layer name will be **lib-python-<library-name>**.  


### Python Runtime (Optional)
This module supports the following Python runtimes.  

| Version       | Identifier |	
|---------------|----------- |
| Python 3.12   | python3.12 |
| Python 3.11   | python3.11 |
| Python 3.10   | python3.10 |
| Python 3.9    | python3.9  |
| Python 3.8    | python3.8  |

You can change the runtime by assigning variable __python_runtime__.  If not provided, Layer will be created with default runtime __python3.12__