/** RIGHT networks **/

resource google_compute_network "dut" {
  for_each      = toset(local.network_names)

  name          = "${var.prefix}-vpc-${each.value}"
  auto_create_subnetworks = false
  mtu = var.mtu
}

resource google_compute_subnetwork "dut" {
  for_each      = toset(local.network_names)

  name          = "${var.prefix}-sb-${each.value}-${local.regions_short["dut"]}"
  region        = var.region_dut
  network       = google_compute_network.dut[ each.value ].self_link
  ip_cidr_range = local.cidrs[ each.value ]
}

resource google_compute_firewall "allow_all_dut" {
    for_each = toset(local.network_names)

    name = "${var.prefix}-dut${each.key}-allowall"
    network = google_compute_network.dut[each.key].name
    source_ranges = ["0.0.0.0/0"]
    allow {
        protocol = "all"
    }
}


/** RIGHT fortigate **/

resource "google_compute_address" "vpn_dut" {
  for_each = local.tunnel_indx_set

  region = var.region_dut
  name = "${var.prefix}-vpn${each.key}-dut-${local.regions_short["dut"]}"
}

resource "google_compute_address" "dut_port1" {
    // need this statically assigned for FGT interface config
    name = "${var.prefix}-addr-dut-port1"
    region = var.region_dut
    address_type = "INTERNAL"
    subnetwork = google_compute_subnetwork.dut["ext"].self_link
}

resource "google_compute_instance" "dut_fgt" {
    name = "${var.prefix}-fgt-dut-${local.regions_short["dut"]}"
    zone = "${var.region_dut}-b"
    machine_type = var.machine_type
    can_ip_forward = true

    boot_disk {
        initialize_params {
            image = local.fgt_image_uri
        }
    }

    network_interface {
        network       = google_compute_network.dut["ext"].self_link
        subnetwork    = google_compute_subnetwork.dut["ext"].name
        network_ip    = google_compute_address.dut_port1.address
        nic_type = var.nic_type
        access_config {}
    }
    network_interface {
        network       = google_compute_network.dut["int"].self_link
        subnetwork    = google_compute_subnetwork.dut["int"].name
        nic_type = var.nic_type
    }
    network_interface {
        network       = google_compute_network.dut["hamgmt"].self_link
        subnetwork    = google_compute_subnetwork.dut["hamgmt"].name
        nic_type = var.nic_type
        access_config {}
        queue_count = var.opt_queues == true ? 1 : null
    }
    service_account {
        email  = data.google_compute_default_service_account.default.email
        scopes = [
            "https://www.googleapis.com/auth/compute.readonly",
        ]
    }
    scheduling {
      provisioning_model = "SPOT"
      preemptible = true
      automatic_restart = false      
    }

    metadata = {
        serial-port-enable = "true"
        user-data = <<EOT
Content-Type: multipart/mixed; boundary="12345"
MIME-Version: 1.0

--12345
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="license"

LICENSE-TOKEN: ${try(module.flex[0].tokens[0], "")}

--12345
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="config"

  config sys global
    set hostname dut
  end
  config sys interface
    edit port1
        set mode static
        set ip ${google_compute_address.dut_port1.address}/32
        set secondary-IP enable
        config secondaryip
        %{ for eip in google_compute_address.vpn_dut ~}
            edit 0
                set ip ${eip.address}/32
                set allowaccess probe-response
            next
        %{ endfor ~}
        end
    next
    edit port2
      set dhcp-classless-route-addition enable
    next
    edit port3
      set allowaccess https ssh ping
    next
  end
  config router static
    edit 0
        set dst 0.0.0.0/0
        set device port1
        set gateway ${google_compute_subnetwork.dut["ext"].gateway_address}
    next
  end
  config system probe-response
    set mode http-probe
    set http-probe-value OK
    set port 8008
  end
  config vpn ipsec phase1-interface
  %{ for i in range(var.tunnel_count) ~}
    edit "vpn${i}"
        set interface "port1"
        set ike-version 2
        set local-gw ${google_compute_address.vpn_dut[i].address}
        set peertype any
        set net-device disable
        set aggregate-member enable
        set proposal aes128-sha256 aes256-sha256 aes128gcm-prfsha256 aes256gcm-prfsha384 chacha20poly1305-prfsha256
        set remote-gw ${google_compute_address.vpn_dc[i].address}
        set psksecret ${random_string.psksecret.result}
    next
  %{ endfor ~}
  end
  config vpn ipsec phase2-interface
  %{ for i in range(var.tunnel_count) ~}
    edit "vpn${i}"
        set phase1name "vpn${i}"
        set proposal ${var.phase2_enc}
        set pfs disable
        set auto-negotiate enable
    next
  %{ endfor ~}
  end
  config sys interface
    edit "agg"
        set vdom "root"
        set type tunnel
    next
  end
  config system ipsec-aggregate
    edit "agg"
        set member %{ for i in range(var.tunnel_count)} "vpn${i}" %{ endfor }
        set algorithm weighted-round-robin
    next
  end
  config router static
    edit 0
      set dst 10.100.0.0/24
      set device "agg"
    next
  end

config firewall vip
    edit "iperf3-to-port2"
        set mappedip "172.20.1.100"
        set extintf "port1"
        set portforward enable
        set extport 5201
        set mappedport 5201
    next
end
config firewall policy
    edit 1
        set name "allow-vpn"
        set srcintf "agg"
        set dstintf "port2"
        set action accept
        set srcaddr "all"
        set dstaddr "all"
        set schedule "always"
        set service "ALL"
    next
    edit 2
        set name "iperf3-direct"
        set srcintf "port1"
        set dstintf "port2"
        set action accept
        set srcaddr "all"
        set dstaddr "iperf3-to-port2"
        set schedule "always"
        set service "ALL"
        set nat enable
    next
end



config system ha
    set group-name "dummy"
    set mode a-p
    set hbdev "port3" 1 
    set ha-mgmt-status enable
    config ha-mgmt-interfaces
        edit 1
            set interface "port3"
            set gateway ${google_compute_subnetwork.dut["hamgmt"].gateway_address}
        next
    end
    set override disable
    set unicast-hb enable
    set unicast-hb-peerip 172.20.3.22
    set unicast-hb-netmask 255.255.255.0
end

%{ if var.opt_affinity }
config system affinity-interrupt
%{for indx in range(2*local.queue_per_nic + 1)}
  edit ${indx+1}
    set interrupt virtio${floor(indx/local.queue_per_nic)+1}-input.${indx%local.queue_per_nic}
    set affinity-cpumask ${local.cpumasks[indx+1]}
  next
%{endfor}
end
%{ endif }

%{ if var.opt_ipsec-soft-dec-async == true }
config system global
  set ipsec-soft-dec-async enable
end
%{ endif }

--12345--

        EOT
    }
}

resource "google_compute_region_health_check" "health_check" {
  name               = "${var.prefix}healthcheck-http8008"
  region             = var.region_dut
  timeout_sec        = 2
  check_interval_sec = 2

  http_health_check {
    port = 8008
  }
}

resource "google_compute_instance_group" "dut" {
  name = "${var.prefix}umig-dut"
  zone = "${var.region_dut}-b"
  instances = [
    google_compute_instance.dut_fgt.self_link
  ]
}

/** RIGHT ILB **/

resource "google_compute_region_backend_service" "dut_int" {
  provider               = google-beta
  name                   = "${var.prefix}bes-dut-ilb"
  region                 = var.region_dut
  network                = google_compute_subnetwork.dut["int"].network

  backend {
    group                = google_compute_instance_group.dut.self_link
  }

  health_checks          = [google_compute_region_health_check.health_check.self_link]
  connection_tracking_policy {
    connection_persistence_on_unhealthy_backends = "NEVER_PERSIST"
  }
}

resource "google_compute_forwarding_rule" "dut_int" {
  name                   = "${var.prefix}fwdrule-dut-ilb"
  region                 = var.region_dut
  network                = google_compute_subnetwork.dut["int"].network
  subnetwork             = google_compute_subnetwork.dut["int"].id
  all_ports              = true
  load_balancing_scheme  = "INTERNAL"
  backend_service        = google_compute_region_backend_service.dut_int.self_link
  allow_global_access    = true
}

resource "google_compute_route" "ilb_dev" {
  name                   = "${var.prefix}rt-via-dutfgt"
  dest_range             = "10.100.0.0/16"
  network                = google_compute_subnetwork.dut["int"].network
  next_hop_ilb           = google_compute_forwarding_rule.dut_int.self_link
  priority               = 100
}

/** RIGHT ELB **/

resource "google_compute_forwarding_rule" "frontends_dut" {
  for_each              = {for eip in google_compute_address.vpn_dut: trimprefix(eip.name, "${var.prefix}-")=>eip.address}

  name                  = "${var.prefix}fr-${each.key}"
  region                = var.region_dut
  ip_address            = each.value
  ip_protocol           = "L3_DEFAULT"
  all_ports             = true
  load_balancing_scheme = "EXTERNAL"
  backend_service       = google_compute_region_backend_service.elb_bes_dut.self_link
  labels                = {
    owner : "bmoczulski"
    knock   : "51776"
  }
}

resource "google_compute_region_backend_service" "elb_bes_dut" {
  provider               = google-beta
  name                   = "${var.prefix}bes-elb-dut"
  region                 = var.region_dut
  load_balancing_scheme  = "EXTERNAL"
  protocol               = "UNSPECIFIED"

  backend {
    group                = google_compute_instance_group.dut.self_link
  }

  health_checks          = [google_compute_region_health_check.health_check.self_link]
  connection_tracking_policy {
    connection_persistence_on_unhealthy_backends = "NEVER_PERSIST"
  }
}