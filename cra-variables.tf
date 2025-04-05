variable "project_name" {
  description = "Cra-Lesson"
  type        = string
  default     = "cra-vpc-project"
}

variable "environment" {
  description = "The deployment environment"
  type        = string
  default     = "dev"
}

variable "team" {
  description = "The team responsible for the infrastructure"
  type        = string
  default     = "cloud-engineering"
}
