terraform {
}

variable "env" {
  type = list(object({
    name           = string
    value          = optional(string)
    value_from_env = optional(string)
  }))
}

locals {
  from_env = {
    for e in var.env : e.name => e.value_from_env if e.value_from_env != null
  }
  env = {
    for e in var.env : e.name => e.value if e.value != null
  }
  dynamic_env = {
    for k, v in local.from_env : k => data.external.env_value[k].result["value"]
  }
}

data "external" "env_value" {
  for_each = local.from_env
  program     = ["bash", "${path.module}/get_env.sh"]
  query = {
    name = each.value
  }
}

output "appConfig" {
  value = jsonencode(merge(local.env, local.dynamic_env))
}