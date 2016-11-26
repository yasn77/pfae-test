#cloud-config

packages:
 - python

write_files:
  - content: |
      {
        "role": "jumphost"
      }
    path: /etc/ansible/facts.d/pfae.fact
