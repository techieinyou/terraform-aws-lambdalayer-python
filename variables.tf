variable "library_name" {
  type        = string
  description = "Name of the Python library to create Lambda Layer"
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z\\-\\_0-9]{1,64}$", var.library_name))
    error_message = "Provide a valid library name. Library name must start with letter, only contain letters, numbers, dashes, or underscores and must be between 1 and 64 characters."
  }
}

variable "layer_name" {
  type        = string
  description = "Name of Lambda layer"
  default     = "null"
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z\\-\\_0-9]{1,64}$", var.layer_name))
    error_message = "Lambda Layer name must start with letter, only contain letters, numbers, dashes, or underscores and must be between 1 and 64 characters."
  }
}

variable "python_runtime" {
  type        = string
  description = "Runtime version of Python, eg. python3.12, python3.11, python3.10, python3.9, python3.8"
  default     = "python3.12"
  validation {
    condition     = contains(["python3.12", "python3.11", "python3.10", "python3.9", "python3.8", null], var.python_runtime)
    error_message = "Unsupported runtime <${var.python_runtime}>"
  }
}
