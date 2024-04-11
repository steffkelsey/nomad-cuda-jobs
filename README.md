# Running CUDA Jobs with Hashicorp Nomad

The purpose is to run code that depends on CUDA hardware from Nomad both locally
and in the cloud. The code in this repository will NOT demonstrate best practices
for uptime and security of Nomad clusters and should not be taken as an example
of that kind. The focus has been narrowed intentionally for speed.

## Prerequisites

1. Install Docker Desktop
2. Install the nvidia-container-toolkit
3. Edit the Docker Engine Config to make it aware of the nvidia container toolkit
```json
{
  "runtimes": {
    "nvidia": {
      "path": "/usr/bin/nvidia-container-runtime",
      "runtimeArgs": []
    }
  }
}
```

## Steps

### 1. Install Nomad  
I use ansible to manage my Ubuntu (both WSL2 and native) packages. Code can be found [here](https://github.com/steffkelsey/linux-laptop/blob/main/tasks/hashicorp.yml).  
OR  
Follow the Nomad install instructions for your OS [here](https://developer.hashicorp.com/nomad/docs/install).  

### 2. Download and install the nomad-device-nvidia plugin
Hashicorp has developed the nomad-device-nvidia plugin, but the release has not been updated. 
Urus Graphics forked the repo and created a release on the latest (as of 4/10/2024) tagged v1.1.0.
The binary can be found [here](https://github.com/urusgraphics/nomad-device-nvidia/releases/download/v1.1.0/nomad-device-nvidia_1.1.0_linux_amd64.zip).  

Download and unzip into `/opt/nomad/plugins` to match the config in the commands below.

### 2. Create a local development cluster

```bash
sudo "$(which nomad)" agent -dev \
  -bind 0.0.0.0 \
  -network-interface='{{ GetDefaultInterfaces | attr "name" }}' \
  -config='./dev-config.hcl' \
  -plugin-dir='/opt/nomad/plugins'
```
*NOTE - you NEED `sudo`. 
My PATH was messed up because I put the nomad binary in `/usr/local/hashicorp/nomad` 
and it is not in my secure_path for sudoers. That is why I used `sudo "$(which nomad) ..."`
If I had the hashicorp binaries installed differently, the `sudo $(which nomad)` would not be needed.

### 3. Run the job
```bash
nomad run cuda-vector-add.nomad.hcl
```

You can check the job status by looking at the Jobs Dashboard via http://localhost:4646/ui/
