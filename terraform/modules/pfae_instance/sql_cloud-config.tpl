#cloud-config

packages:
 - python

write_files:
  - content: |
      {
        "role": "db"
      }
    path: /etc/ansible/facts.d/pfae.fact
