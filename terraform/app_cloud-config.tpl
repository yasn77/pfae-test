#cloud-config

apt_sources:
  - source: "deb https://apt.dockerproject.org/repo ubuntu-xenial main"
    keyid: 58118E89F3A912897C070ADBF76221572C52609D
    filename: docker.list

packages:
 - python
 - docker-engine
 - curl
 - git

write_files:
  - content: |
      {
        "role": "app"
      }
    path: /etc/ansible/facts.d/pfae.fact

runcmd:
 - [ curl, -L, 'https://github.com/docker/compose/releases/download/1.8.1/docker-compose-Linux-x86_64', -o, /usr/local/bin/docker-compose ]
 - [ curl, 'https://amazon-ssm-eu-west-1.s3.amazonaws.com/latest/debian_amd64/amazon-ssm-agent.deb', -o, /tmp/amazon-ssm-agent.deb ]
 - [ chmod, +x, /usr/local/bin/docker-compose ]
 - [ git, clone, 'https://github.com/yasn77/pfae-test.git', /src ]
 - [ touch, /etc/pfae.cfg ]
 - [ /usr/local/bin/docker-compose, -f, /src/app/docker-compose.yml, up, -d ]
 - [ /usr/local/bin/docker-compose, -f, /src/app/docker-compose.yml, scale, pfae=3 ]
 - [ dpkg, -i, /tmp/amazon-ssm-agent.deb ]
 - [ systemctl, enable, amazon-ssm-agent ]
 - [ systemctl, start, amazon-ssm-agent ]

