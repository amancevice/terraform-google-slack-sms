/**
 * Required Variables
 */
variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "config" {
  description = "Rendered Slack Drive `config.tpl` JSON content."
}

variable "service_account" {
  description = "An email address that represents a service account. For example, my-other-app@appspot.gserviceaccount.com."
}

variable "verification_token" {
  description = "Slack verification token."
}

/**
 * Optional Variables
 */
variable "bucket_storage_class" {
  description = "Bucket storage class."
  default     = "MULTI_REGIONAL"
}

variable "bucket_prefix" {
  description = "Prefix for Cloud Storage bucket."
  default     = ""
}

variable "color" {
  description = "Default color for slackbot message attachments."
  default     = "good"
}

variable "slash_command" {
  description = "Name of slash command in Slack"
  default     = "sms"
}

variable "slash_command_function_name" {
  description = "Cloud Function for receiving slash-commands from Slack."
  default     = "slack-sms-slash-command"
}

variable "slash_command_memory" {
  description = "Memory for Slack slash command."
  default     = 128
}

variable "slash_command_timeout" {
  description = "Timeout in seconds for Slack slash command."
  default     = 60
}
