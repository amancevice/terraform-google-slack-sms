provider "archive" {
  version = "~> 1.0"
}

provider "template" {
  version = "~> 1.0"
}

locals {
  version = "0.5.2"

  dialog {
    callback_id  = "${var.callback_id}"
    submit_label = "Send"
    title        = "${var.dialog_title}"
    elements     = [
      {
        hint       = "${var.dialog_element_hint}"
        label      = "${var.dialog_element_label}"
        max_length = "${var.dialog_element_max_length}"
        name       = "${var.callback_id}"
        type       = "textarea"
      }
    ]
  }
}

module "group_sms" {
  source                                = "amancevice/group-sms/aws"
  version                               = "0.1.3"
  default_sender_id                     = "${var.group_sms_default_sender_id}"
  default_sms_type                      = "${var.group_sms_default_sms_type}"
  delivery_status_iam_role_arn          = "${var.group_sms_delivery_status_iam_role_arn}"
  delivery_status_success_sampling_rate = "${var.group_sms_delivery_status_success_sampling_rate}"
  monthly_spend_limit                   = "${var.group_sms_monthly_spend_limit}"
  subscriptions                         = ["${var.group_sms_subscriptions}"]
  topic_display_name                    = "${var.group_sms_topic_display_name}"
  topic_name                            = "${var.group_sms_topic_name}"
  usage_report_s3_bucket                = "${var.group_sms_usage_report_s3_bucket}"
}

data "template_file" "sms_config" {
  template   = "${file("${path.module}/src/config.tpl")}"

  vars {
    access_key_id     = "${var.aws_access_key_id}"
    secret_access_key = "${var.aws_secret_access_key}"
    region            = "${var.aws_region}"
    topic_arn         = "${module.group_sms.topic_arn}"
    callback_id       = "${var.callback_id}"
  }
}

data "template_file" "sms_package" {
  template = "${file("${path.module}/src/package.tpl")}"

  vars {
    version = "${local.version}"
  }
}

data "archive_file" "sms_archive" {
  type        = "zip"
  output_path = "${path.module}/dist/${var.sms_function_name}-${local.version}.zip"

  source {
    content  = "${data.template_file.sms_config.rendered}"
    filename = "config.json"
  }

  source {
    content  = "${file("${path.module}/src/index.js")}"
    filename = "index.js"
  }

  source {
    content  = "${data.template_file.sms_package.rendered}"
    filename = "package.json"
  }
}

resource "google_storage_bucket_object" "sms_archive" {
  bucket = "${var.bucket_name}"
  name   = "${var.sms_function_name}-${local.version}.zip"
  source = "${data.archive_file.sms_archive.output_path}"
}

resource "google_cloudfunctions_function" "sms_function" {
  available_memory_mb   = "${var.sms_memory}"
  description           = "${var.sms_description}"
  entry_point           = "consumeEvent"
  labels                = "${var.sms_labels}"
  name                  = "${var.sms_function_name}"
  source_archive_bucket = "${var.bucket_name}"
  source_archive_object = "${google_storage_bucket_object.sms_archive.name}"
  timeout               = "${var.sms_timeout}"
  trigger_topic         = "${var.callback_id}"
}

module "slash_command" {
  source                          = "amancevice/slack-slash-command/google"
  version                         = "0.5.0"
  auth_channels_exclude           = ["${var.slash_command_auth_channels_exclude}"]
  auth_channels_include           = ["${var.slash_command_auth_channels_include}"]
  auth_channels_permission_denied = "${var.slash_command_auth_channels_permission_denied}"
  auth_users_exclude              = ["${var.slash_command_auth_users_exclude}"]
  auth_users_include              = ["${var.slash_command_auth_users_include}"]
  auth_users_permission_denied    = "${var.slash_command_auth_users_permission_denied}"
  bucket_name                     = "${var.bucket_name}"
  description                     = "${var.slash_command_description}"
  function_name                   = "${var.slash_command_function_name}"
  labels                          = "${var.slash_command_labels}"
  memory                          = "${var.slash_command_memory}"
  response                        = "${local.dialog}"
  response_type                   = "dialog"
  timeout                         = "${var.slash_command_timeout}"
  verification_token              = "${var.verification_token}"
  web_api_token                   = "${var.web_api_token}"
}
