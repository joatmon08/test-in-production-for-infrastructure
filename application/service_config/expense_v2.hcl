service {
  name    = "expense"
  id      = "expense-v2"
  address = "10.5.0.6"
  port    = 5001

  tags = ["v2"]
  meta = {
    version = "2"
  }

  connect {
    sidecar_service {
      port = 20000

      check {
        name     = "Connect Envoy Sidecar"
        tcp      = "10.5.0.6:20000"
        interval = "10s"
      }

      proxy {
        upstreams {
          destination_name   = "expense-db"
          local_bind_address = "127.0.0.1"
          local_bind_port    = 1433
        }
      }
    }
  }
}