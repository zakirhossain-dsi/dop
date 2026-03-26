locals {
  ec2_instances = {
    "red_env" = {
      name = "red-environment"
      team = "Red"
    }
    "green_env" = {
      name = "green-environment"
      team = "Green"
    }
  }
  users = {
    "alice" = {
      name = "Alice"
      team = "Red"
    }
    "bob" = {
      name = "Bob"
      team = "Green"
    }
  }
}