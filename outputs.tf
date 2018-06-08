output "sns_topic_arn" {
  description = "AWS Topic ARN."
  value       = "${module.group_sms.topic_arn}"
}

output "sns_topic_subscriptions" {
  description = "AWS Topic ARN."
  value       = "${module.group_sms.topic_subscriptions}"
}

output "slash_command_url" {
  description = "Slack slash command Request URL."
  value       = "${module.slash_command.request_url}"
}
