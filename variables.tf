// AWS
variable "aws_access_key_id" {
  description = "AWS Access Key ID."
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key."
}

variable "aws_region" {
  description = "AWS Region Name."
  default     = "us-east-1"
}

// Google Cloud
variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

// Slack
variable "verification_token" {
  description = "Slack verification token."
}

variable "web_api_token" {
  description = "Slack Web API token."
}

// Group SMS
variable "group_sms_default_sender_id" {
  description = "A custom ID, such as your business brand, displayed as the sender on the receiving device. Support for sender IDs varies by country."
  default     = ""
}

variable "group_sms_default_sms_type" {
  description = "Promotional messages are noncritical, such as marketing messages. Transactional messages are delivered with higher reliability to support customer transactions, such as one-time passcodes."
  default     = "Promotional"
}

variable "group_sms_delivery_status_iam_role_arn" {
  description = "The IAM role that allows Amazon SNS to write logs for SMS deliveries in CloudWatch Logs."
  default     = ""
}

variable "group_sms_delivery_status_success_sampling_rate" {
  description = "Default percentage of success to sample."
  default     = ""
}

variable "group_sms_monthly_spend_limit" {
  description = "The maximum amount to spend on SMS messages each month. If you send a message that exceeds your limit, Amazon SNS stops sending messages within minutes."
  default     = ""
}

variable "group_sms_subscriptions" {
  description = "List of telephone numbers to subscribe to SNS."
  type        = "list"
  default     = []
}

variable "group_sms_topic_display_name" {
  description = "Display name of the AWS SNS topic."
}

variable "group_sms_topic_name" {
  description = "Name of the AWS SNS topic."
}

variable "group_sms_usage_report_s3_bucket" {
  description = "The Amazon S3 bucket to receive daily SMS usage reports. The bucket policy must grant write access to Amazon SNS."
  default     = ""
}

// App
variable "callback_id" {
  description = "Callback ID of interactive component."
  default     = "group_sms"
}

variable "dialog_element_hint" {
  description = "Dialog textarea hint."
  default     = "This will send a text to a group."
}

variable "dialog_element_label" {
  description = "Dialog textarea label."
  default     = "Message"
}

variable "dialog_element_max_length" {
  description = "Dialog textarea max characters."
  default     = 140
}

variable "dialog_title" {
  description = "Dialog title."
  default     = "Group SMS"
}

// Slash Command
variable "slash_command_auth_channels_exclude" {
  description = "Optional list of Slack channel IDs to blacklist."
  type        = "list"
  default     = []
}

variable "slash_command_auth_channels_include" {
  description = "Optional list of Slack channel IDs to whitelist."
  type        = "list"
  default     = []
}

variable "slash_command_auth_channels_permission_denied" {
  description = "Permission denied message for channels."
  type        = "map"

  default {
    text = "Sorry, you can't do that in this channel."
  }
}

variable "slash_command_auth_users_exclude" {
  description = "Optional list of Slack user IDs to blacklist."
  type        = "list"
  default     = []
}

variable "slash_command_auth_users_include" {
  description = "Optional list of Slack user IDs to whitelist."
  type        = "list"
  default     = []
}

variable "slash_command_auth_users_permission_denied" {
  description = "Permission denied message for users."
  type        = "map"

  default {
    text = "Sorry, you don't have permission to do that."
  }
}

variable "slash_command_description" {
  description = "Description of the function."
  default     = "Slack-SMS slash command"
}

variable "slash_command_function_name" {
  description = "Cloud Function Name."
  default     = "slack-sms-slash-command"
}

variable "slash_command_labels" {
  description = "A set of key/value label pairs to assign to the function."
  type        = "map"

  default {
    app             = "slack-sms"
    deployment-tool = "terraform"
  }
}

variable "slash_command_memory" {
  description = "Memory for Cloud Function."
  default     = 512
}

variable "slash_command_timeout" {
  description = "Timeout in seconds for Cloud Function."
  default     = 10
}

// SMS
variable "sms_description" {
  description = "Description of the function."
  default     = "Slack-SMS publisher"
}

variable "sms_function_name" {
  description = "Cloud Function for publishing events from Slack to Pub/Sub."
  default     = "slack-sms"
}

variable "sms_labels" {
  description = "A set of key/value label pairs to assign to the function."
  type        = "map"

  default {
    app             = "slack-sms"
    deployment-tool = "terraform"
  }
}

variable "sms_memory" {
  description = "Memory for Cloud Function."
  default     = 512
}

variable "sms_timeout" {
  description = "Timeout in seconds for Cloud Function."
  default     = 60
}
