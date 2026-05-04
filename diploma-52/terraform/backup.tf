locals {
  all_boot_disk_ids = [
    yandex_compute_instance.neto_bastion.boot_disk[0].disk_id,
    yandex_compute_instance.neto_web_a.boot_disk[0].disk_id,
    yandex_compute_instance.neto_web_b.boot_disk[0].disk_id,
    yandex_compute_instance.neto_zabbix.boot_disk[0].disk_id,
    yandex_compute_instance.neto_elasticsearch.boot_disk[0].disk_id,
    yandex_compute_instance.neto_kibana.boot_disk[0].disk_id
  ]
}

resource "yandex_compute_snapshot_schedule" "neto_daily_snapshots" {
  name        = "neto-daily-snapshots"
  description = "Ежедневное резервное копирование всех дисков"

  schedule_policy {
    expression = "0 4 * * *"
  }
  
  retention_period = "168h"

  disk_ids = local.all_boot_disk_ids

  snapshot_spec {
    description = "Ежедневный снапшот дипломного проекта"
  }
}