/** LEFT networks **/

resource google_compute_network "dc" {
  name          = "${var.prefix}-vpc-cli"
  auto_create_subnetworks = false
  mtu = var.mtu
}

resource google_compute_subnetwork "dc" {
  name          = "${var.prefix}-sb-cli-${local.regions_short["cli"]}"
  region        = var.region_cli
  network       = google_compute_network.dc.self_link
  ip_cidr_range = "10.100.0.0/24"
}

resource google_compute_address "dc" {
    name = "${var.prefix}-cli-pip"
    address_type = "EXTERNAL"
    region = google_compute_subnetwork.dc.region
}



/** LEFT fortigate **/

resource "google_compute_address" "vpn_dc" {
  for_each = local.tunnel_indx_set

  region = var.region_cli
  name = "${var.prefix}-vpn${each.key}-cli-${local.regions_short["cli"]}"
}

resource "google_compute_address" "dc_port1" {
    name = "${var.prefix}-addr-cli-port1"
    region = var.region_cli
    address_type = "INTERNAL"
    subnetwork = google_compute_subnetwork.dc.self_link
}


resource "google_compute_instance" "dc_fgt" {
    name = "${var.prefix}-fgt-cli-${local.regions_short["cli"]}"
    zone = "${google_compute_subnetwork.dc.region}-c"
    machine_type = "c2-standard-16"
    can_ip_forward = true

    boot_disk {
        initialize_params {
            image = local.fgt_image_uri
        }
    }

    network_interface {
        network       = google_compute_network.dc.self_link
        subnetwork    = google_compute_subnetwork.dc.name
        network_ip    = google_compute_address.dc_port1.address
        nic_type = var.nic_type
        access_config { 
            nat_ip = google_compute_address.dc.address
        }
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


LICENSE-TOKEN: ${try(module.flex[0].tokens[1], "")}

--12345
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="config"

  config sys interface
    edit port1
        set mode static
        set ip ${google_compute_address.dc_port1.address}/32
        set secondary-IP enable
        config secondaryip
        %{ for eip in google_compute_address.vpn_dc ~}
            edit 0
                set ip ${eip.address}/32
                set allowaccess probe-response
            next
        %{ endfor ~}
        end
    next
  end
  config router static
    edit 0
      set device port1
      set gateway ${google_compute_subnetwork.dc.gateway_address}
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
        set local-gw ${google_compute_address.vpn_dc[i].address}
        set peertype any
        set net-device disable
        set aggregate-member enable
        set proposal aes128-sha256 aes256-sha256 aes128gcm-prfsha256 aes256gcm-prfsha384 chacha20poly1305-prfsha256
        set remote-gw ${google_compute_address.vpn_dut[i].address}
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
      set dst ${local.cidrs["int"]}
      set device "agg"
    next
  end

config firewall policy
    edit 1
        set name "allow-vpn"
        set srcintf "port1"
        set dstintf "agg"
        set action accept
        set srcaddr "all"
        set dstaddr "all"
        set schedule "always"
        set service "ALL"
    next
end

%{ if var.opt_ipsec-soft-dec-async == true }
config system global
  set ipsec-soft-dec-async enable
end
%{ endif }

--12345--

        EOT
    }
}

resource google_compute_route "dc_to_test" {
    name = "${var.prefix}-cli-to-dut"
    dest_range = local.cidrs["int"]
    network = google_compute_network.dc.self_link
    next_hop_instance = google_compute_instance.dc_fgt.self_link
}

resource google_compute_firewall "allow_all_dc" {
    name = "${var.prefix}-cli-allowall"
    network = google_compute_network.dc.name
    source_ranges = ["0.0.0.0/0"]
    allow {
        protocol = "all"
    }
}

## ELB

resource "google_compute_region_health_check" "dc" {
  name                   = "${var.prefix}healthcheck-http${8008}-${local.regions_short["cli"]}"
  region                 = var.region_cli
  timeout_sec            = 2
  check_interval_sec     = 2

  http_health_check {
    port                 = 8008
  }
}

resource "google_compute_instance_group" "dc_umig" {

  name                   = "${var.prefix}fgt-umig-cli"
  zone                   = google_compute_instance.dc_fgt.zone
  instances              = [google_compute_instance.dc_fgt.self_link]
}

resource "google_compute_forwarding_rule" "frontends_dc" {
  for_each              = {for eip in google_compute_address.vpn_dc: trimprefix(eip.name, "${var.prefix}-")=>eip.address}

  name                  = "${var.prefix}fr-${each.key}"
  region                = var.region_cli
  ip_address            = each.value
  ip_protocol           = "L3_DEFAULT"
  all_ports             = true
  load_balancing_scheme = "EXTERNAL"
  backend_service       = google_compute_region_backend_service.elb_bes_dc.self_link
  labels                = {
    owner : "bmoczulski"
    knock   : "51776"
  }
}

resource "google_compute_region_backend_service" "elb_bes_dc" {
  provider               = google-beta
  name                   = "${var.prefix}bes-elb-${local.regions_short["cli"]}"
  region                 = var.region_cli
  load_balancing_scheme  = "EXTERNAL"
  protocol               = "UNSPECIFIED"

  backend {
    group                = google_compute_instance_group.dc_umig.self_link
  }

  health_checks          = [google_compute_region_health_check.dc.self_link]
  connection_tracking_policy {
    connection_persistence_on_unhealthy_backends = "NEVER_PERSIST"
  }
}

