# Deploy to a cloud

fleetkit runs on any Linux server with Docker. Pick a provider, create an Ubuntu 24.04 server with **4 GB RAM** and 2 vCPUs, then either:

- paste [`cloud-init.yaml`](../cloud-init.yaml) into the "user data" box when you create it, or
- SSH in and run the installer:

  ```bash
  curl -fsSL https://raw.githubusercontent.com/Ani-HQ/fleetkit/main/install.sh | bash
  ```

Then:

```bash
cd ~/fleetkit
./fleet setup
./fleet up
./fleet login claude    # and/or chatgpt
```

You do not need to open any inbound ports besides SSH. Discord, Telegram and WhatsApp connect outbound.

## Providers

| Provider | Size that fits | Roughly |
| --- | --- | --- |
| Hetzner Cloud | CX32 / CAX21 (4 GB) | €7/mo |
| DigitalOcean | Basic 4 GB | $24/mo |
| Vultr | Regular 4 GB | $20/mo |
| Linode (Akamai) | Shared 4 GB | $24/mo |
| AWS Lightsail | 4 GB | $24/mo |
| AWS EC2 | t4g.medium (arm64) | ~$25/mo |
| Google Cloud | e2-medium | ~$25/mo |
| Oracle Cloud | Ampere A1, 4 OCPU / 24 GB | free tier |

Both amd64 and arm64 work.

### Hetzner

Create server → Ubuntu 24.04 → CAX21 → add your SSH key → **Cloud config**: paste `cloud-init.yaml` → Create. SSH in as `root`.

### DigitalOcean

Create → Droplets → Ubuntu 24.04 → Basic, 4 GB → **Advanced options → Add initialization scripts**: paste `cloud-init.yaml`.

### AWS (EC2 or Lightsail)

Launch an Ubuntu 24.04 instance. Under **Advanced details → User data**, paste `cloud-init.yaml`. The security group only needs SSH (22) inbound. SSH in as `ubuntu`.

### Google Cloud

```bash
gcloud compute instances create fleet \
  --machine-type=e2-medium --image-family=ubuntu-2404-lts-amd64 \
  --image-project=ubuntu-os-cloud --boot-disk-size=30GB \
  --metadata-from-file=user-data=cloud-init.yaml
gcloud compute ssh fleet
```

### Oracle Cloud free tier

Create instance → Ubuntu 24.04 → shape VM.Standard.A1.Flex (4 OCPU, 24 GB) → **Show advanced options → Management → cloud-init script**: paste `cloud-init.yaml`. SSH in as `ubuntu`.

### Your own machine

Any Mac or Linux box with Docker works too: `git clone https://github.com/Ani-HQ/fleetkit && cd fleetkit && ./fleet setup && ./fleet up`. Agents only run while it's on.

## Not supported

- **Vercel, Netlify, Cloudflare Pages and other serverless hosts.** The fleet needs long-running processes, a persistent disk and scheduled jobs.
- **Railway** is planned as a one-click template.

## Disk and memory

The full fleet idles at about 1.4 GB RAM and climbs while agents work, which is why 4 GB is the minimum. Leave 20 GB of disk for images, sessions and backups.
