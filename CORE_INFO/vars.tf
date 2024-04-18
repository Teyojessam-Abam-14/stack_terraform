variable "required_tags" {
    description="Tags required to be specified on all resources"
    type=object({
      instance_name=string
      environment=string
      OwnerEmail=string
    })

    validation {
      condition = var.required_tags.instance_name != "" 
      error_message = "Instance name must be a non-empty value"
    }
    
    validation {
      condition = var.required_tags.environment != "" && var.required_tags.environment == lower(var.required_tags.environment) && contains(["dev", "test", "prod", "uat"], var.required_tags.environment)
      error_message = "Environment must be a non-empty value, must be in lowercase, and must be one of -dev,test,uat,prod" 
    }

    validation {
      condition = var.required_tags.OwnerEmail != "" && var.required_tags.OwnerEmail == lower(var.required_tags.OwnerEmail) 
      error_message = "OwnerEmail must be a non-empty value and must be in lowercase" 
    }
}