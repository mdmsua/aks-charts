variable "cluster" {
  type = object({
    id        = number
    name      = string
    host      = string
    pod_cidrs = list(string)
  })
}

variable "cilium" {
  type = object({
    version = string
  })
}
