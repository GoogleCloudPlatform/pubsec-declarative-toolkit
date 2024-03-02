variable subnet_external {
  type        = string
  description = "Name of external subnet (port1)"
}

variable subnet_internal {
  type        = string
  description = "Name of internal subnet (port2)"
}

variable subnet_hasync {
  type        = string
  description = "Name of heartbeat subnet (port3)"
}

variable subnet_mgmt {
  type        = string
  description = "Name of dedicated management subnet (port4)"
}
