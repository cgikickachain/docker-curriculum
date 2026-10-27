variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS CLI profile to authenticate with"
  type        = string
  default     = "356724906763_StandardUserAccess"
}

variable "owner" {
  description = "Value for the mandatory owner tag"
  type        = string
  default     = "adam.kinnucane@cgi.com"
}

variable "project" {
  description = "Project name, used for tags and resource names"
  type        = string
  default     = "catapp-tf"
}

variable "host_port" {
  description = "Port to expose on the host machine"
  type        = number
  default     = 8888
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 5000
}

variable "instance_type" {
  description = "EC2 instance type to use for the app"
  type        = string
  default     = "t3a.micro"
}

variable "task_cpu" {
  description = "CPU units to allocate to the task (1024 = 1 vCPU)"
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "Memory (in MiB) to allocate to the task"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of tasks to run in the ECS service"
  type        = number
  default     = 1
}