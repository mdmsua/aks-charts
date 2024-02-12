variable "spec" {
  type = object({
    project = string
    cluster = object({
      id            = number
      pod_cidrs     = list(string)
      service_cidrs = list(string)
    })
    charts = object({
      cilium = object({
        version = string
      })
    })
  })
}
