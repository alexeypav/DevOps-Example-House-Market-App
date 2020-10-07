variable "name_prefix" {
    type        = "string"
    default     = "alexeypoc"
    description = "unique prefix for resources"
}

variable "location" {
    type        = "string"
    default     = "Southeast Asia"
    description = "Specify a location see: az account list-locations -o table"
}

variable "tags" {
    type        = "map"
    description = "A list of tags associated to all resources"

    default = {
        environment = "PROD"
    }
}


