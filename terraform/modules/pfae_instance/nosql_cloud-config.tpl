#cloud-config

packages:
 - python

write_files:
  - content: |
      {
        "role": "mongodb"
      }
    path: /etc/ansible/facts.d/pfae.fact
