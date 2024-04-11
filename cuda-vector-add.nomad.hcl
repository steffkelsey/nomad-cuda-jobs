job "cuda-vector-add" {
  datacenters = ["dc1"]
  type = "batch"

  group "cuda-vector-add" {
    task "cuda-vector-add" {
      driver = "docker"
      config {
        image = "nvcr.io/nvidia/k8s/cuda-sample:vectoradd-cuda11.7.1-ubuntu18.04"
      }

      resources {
        device "nvidia/gpu" {
          count = 1
        }
      }
    }
  }
}
