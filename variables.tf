/**
 * Required Variables
 */
variable "aws_access_key_id" {
  description = "AWS Access Key ID."
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key."
}

variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "group_sms_topic_display_name" {
  description = "Display name of the AWS SNS topic."
}

variable "group_sms_topic_name" {
  description = "Name of the AWS SNS topic."
}

variable "verification_token" {
  description = "Slack verification token."
}

variable "web_api_token" {
  description = "Slack Web API token."
}

/**
 * Optional Variables
 */
variable "aws_region" {
  description = "AWS Region Name."
  default     = "us-east-1"
}

variable "bucket_storage_class" {
  description = "Bucket storage class."
  default     = "MULTI_REGIONAL"
}

variable "bucket_prefix" {
  description = "Prefix for Cloud Storage bucket."
  default     = ""
}

variable "callback_id" {
  description = "Callback ID of interactive component."
  default     = "group_sms"
}

variable "element" {
  description = "Element name of interactive component containing SMS message."
  default     = "group_sms"
}

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

variable "group_sms_usage_report_s3_bucket" {
  description = "The Amazon S3 bucket to receive daily SMS usage reports. The bucket policy must grant write access to Amazon SNS."
  default     = ""
}

variable "slash_command_function_name" {
  description = "Cloud Function Name."
  default     = "slack-sms-slash-command"
}

variable "slash_command_memory" {
  description = "Memory for Cloud Function."
  default     = 512
}

variable "slash_command_response" {
  description = "Timeout in seconds for Slack event listener."
  type        = "map"
  default {
    callback_id  = "group_sms"
    submit_label = "Send"
    title        = "Group SMS"
    elements     = [
      {
        hint       = "This will send a text to a group."
        label      = "Message"
        max_length = "140"
        name       = "group_sms"
        type       = "textarea"
      }
    ]
  }
}

variable "slash_command_response_type" {
  description = "Response type of command."
  default     = "dialog"
}

variable "slash_command_timeout" {
  description = "Timeout in seconds for Cloud Function."
  default     = 10
}

variable "sms_publisher_function_name" {
  description = "Cloud Function for publishing events from Slack to Pub/Sub."
  default     = "slack-sms-publisher"
}

variable "sms_publisher_memory" {
  description = "Memory for Cloud Function."
  default     = 512
}

variable "sms_publisher_timeout" {
  description = "Timeout in seconds for Cloud Function."
  default     = 60
}
