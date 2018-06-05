output "slash_command_url" {
  description = "Endpoint for slash commands to configure in Slack."
  value       = "${google_cloudfunctions_function.slash_command.https_trigger_url}"
}
