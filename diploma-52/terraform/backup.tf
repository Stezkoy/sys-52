locals {
  boot_disk_map = {
    "bastion"        = yandex_compute_instance.neto_bastion.boot_disk[0].disk_id,
    "web-a"          = yandex_compute_instance.neto_web_a.boot_disk[0].disk_id,
    "web-b"          = yandex_compute_instance.neto_web_b.boot_disk[0].disk_id,
    "zabbix"         = yandex_compute_instance.neto_zabbix.boot_disk[0].disk_id,
    "elasticsearch"  = yandex_compute_instance.neto_elasticsearch.boot_disk[0].disk_id,
    "kibana"         = yandex_compute_instance.neto_kibana.boot_disk[0].disk_id
  }
}

resource "yandex_compute_snapshot" "neto_initial_snapshots" {
  for_each = local.boot_disk_map

  name           = "initial-snapshot-${each.key}"
  description    = "Первичный снапшот диска ВМ ${each.key}"
  source_disk_id = each.value
}

resource "yandex_compute_snapshot_schedule" "neto_daily_snapshots" {
  name        = "neto-daily-snapshots"
  description = "Ежедневное резервное копирование всех дисков"

  schedule_policy {
    expression = "0 4 * * *"
  }

  retention_period = "168h"

  disk_ids = values(local.boot_disk_map)

  snapshot_spec {
    description = "Ежедневный снапшот дипломного проекта"
  }
}