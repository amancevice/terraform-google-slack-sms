// Config template
data "template_file" "config" {
  template = "${var.config}"

  vars {
    aws_access_key_id     = "${var.aws_access_key_id}"
    aws_secret_access_key = "${var.aws_secret_access_key}"
    color                 = "${var.color}"
    slash_command         = "${var.slash_command}"
    verification_token    = "${var.verification_token}"
  }
}

// Source code module
module "slack_sms" {
  source = "github.com/amancevice/slack-sms" //"?ref=0.0.1"
  config = "${data.template_file.config.rendered}"
}

// Cloud Storage Bucket for storing Cloud Function archives
resource "google_storage_bucket" "slack_sms_bucket" {
  name          = "${var.bucket_name}"
  storage_class = "${var.bucket_storage_class}"
}

// Add service acct as writer to Cloud Storage Bucket
resource "google_storage_bucket_iam_member" "member" {
  bucket = "${google_storage_bucket.slack_sms_bucket.name}"
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${var.service_account}"
}

// Slash Command Cloud Storage archive
resource "google_storage_bucket_object" "slash_command_archive" {
  bucket = "${google_storage_bucket.slack_sms_bucket.name}"
  name   = "${var.bucket_prefix}${var.slash_command_function_name}-${module.slack_sms.version}.zip"
  source = "${module.slack_sms.slash_command_output_path}"
}

// Slash Command Cloud Function
resource "google_cloudfunctions_function" "slash_command" {
  name                  = "${var.slash_command_function_name}"
  description           = "Slack /slash command HTTP handler"
  available_memory_mb   = "${var.slash_command_memory}"
  source_archive_bucket = "${google_storage_bucket.slack_sms_bucket.name}"
  source_archive_object = "${google_storage_bucket_object.slash_command_archive.name}"
  trigger_http          = true
  timeout               = "${var.slash_command_timeout}"
  entry_point           = "slashCommand"

  labels {
    deployment-tool = "terraform"
  }
}
