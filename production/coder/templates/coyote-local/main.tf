
terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "0.6.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.20.2"
    }
  }
}

data "coder_provisioner" "me" {
}

provider "docker" {
}

data "coder_workspace" "me" {
}

data "docker_network" "devenv" {
  name = "devenv"
}

resource "coder_agent" "main" {
  arch           = data.coder_provisioner.me.arch
  os             = "linux"
  startup_script = <<EOT
    #!/bin/bash

    # install and start code-server
    curl -fsSL https://code-server.dev/install.sh | sh  | tee code-server-install.log
    code-server --auth none --port 13337 | tee code-server-install.log &
  EOT
}

resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  slug         = "code-server"
  display_name = "code-server"
  url          = "http://localhost:13337/?folder=/home/coder"
  icon         = "/icon/code.svg"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 3
    threshold = 10
  }

}

variable "docker_image" {
  description = "What Docker image would you like to use for your workspace?"
  default     = "ubuntu"

  validation {
    condition     = contains(["ubuntu"], var.docker_image)
    error_message = "Invalid Docker image!"
  }
}

resource "docker_volume" "home_volume" {
  name = "coder-${data.coder_workspace.me.id}-home"
  # Protect the volume from being deleted due to changes in attributes.
  lifecycle {
    ignore_changes = all
  }
  # Add labels in Docker to keep track of orphan resources.
  labels {
    label = "coder.owner"
    value = data.coder_workspace.me.owner
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace.me.owner_id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name_at_creation"
    value = data.coder_workspace.me.name
  }
}

resource "docker_service" "workspace" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}"
  count = data.coder_workspace.me.start_count
  
  task_spec {
    container_spec {
      image = "ghcr.io/maanex/coder-${var.docker_image}:master"

      command  = ["sh", "-c", replace(coder_agent.main.init_script, "/localhost|127\\.0\\.0\\.1/", "host.docker.internal")]
      hostname = data.coder_workspace.me.name

      env = {
        CODER_AGENT_TOKEN = coder_agent.main.token
      }

      mounts {
        target    = "/home/coder/"
        source    = docker_volume.home_volume.name
        read_only = false
        type      = "volume"
      }

      hosts {
        host = "host.docker.internal"
        ip   = "host-gateway"
      }

      # Add labels in Docker to keep track of orphan resources.
      labels {
        label = "coder.owner"
        value = data.coder_workspace.me.owner
      }
      labels {
        label = "coder.owner_id"
        value = data.coder_workspace.me.owner_id
      }
      labels {
        label = "coder.workspace_id"
        value = data.coder_workspace.me.id
      }
      labels {
        label = "coder.workspace_name"
        value = data.coder_workspace.me.name
      }
    }

    placement {
      constraints = [ "node.hostname == co2" ]
    }

    networks = [ data.docker_network.devenv.id ]
  }

  # Add labels in Docker to keep track of orphan resources.
  labels {
    label = "coder.owner"
    value = data.coder_workspace.me.owner
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace.me.owner_id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.me.name
  }
}

resource "coder_metadata" "container_info" {
  count       = data.coder_workspace.me.start_count
  resource_id = docker_service.workspace[0].id

  item {
    key   = "image"
    value = var.docker_image
  }
}
