service {
  name    = "expense-db"
  id      = "expense-db"
  address = "10.5.0.3"
  port    = 1433

  tags = ["v1"]
  meta = {
    version = "1"
  }

  connect {
    sidecar_service {
      port = 20000

      check {
        name     = "Connect Envoy Sidecar"
        tcp      = "10.5.0.3:20000"
        interval = "10s"
      }

      proxy {}
    }
  }
}