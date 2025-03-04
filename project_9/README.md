# Ansible

- [Ansible](#ansible)
  - [Fundamentals](#fundamentals)
    - [IaC vs Configuration Management](#iac-vs-configuration-management)
    - [Provisioning Infrastructure with CM tools](#provisioning-infrastructure-with-cm-tools)
    - [What is Ansible and how does it work?](#what-is-ansible-and-how-does-it-work)
    - [Alternatives to Ansible](#alternatives-to-ansible)
      - [Puppet](#puppet)
        - [Overview](#overview)
        - [Features](#features)
        - [Pros \& Cons](#pros--cons)
        - [Use Case](#use-case)
      - [Chef](#chef)
        - [Overview](#overview-1)
        - [Features](#features-1)
        - [Pros \& Cons](#pros--cons-1)
        - [Use Case](#use-case-1)
      - [SaltStack (Salt)](#saltstack-salt)
        - [Overview](#overview-2)
        - [Features](#features-2)
        - [Pros \& Cons](#pros--cons-2)
        - [Use Case](#use-case-2)
      - [Terraform](#terraform)
        - [Overview](#overview-3)
        - [Features](#features-3)
        - [Pros \& Cons](#pros--cons-3)
        - [Use Case](#use-case-3)
      - [Rudder](#rudder)
        - [Overview](#overview-4)
        - [Features](#features-4)
        - [Pros \& Cons](#pros--cons-4)
        - [Use Case](#use-case-4)
      - [Choosing the Right Tool](#choosing-the-right-tool)
        - [Key Takeaways](#key-takeaways)
    - [Major industry leaders using IaC and CM tools](#major-industry-leaders-using-iac-and-cm-tools)
  - [Architecture](#architecture)
  - [Setup on Ubuntu](#setup-on-ubuntu)
    - [Installation](#installation)
    - [Configure SSH access for Ansible](#configure-ssh-access-for-ansible)
  - [Ansible Inventory](#ansible-inventory)
    - [Variable Assignment to Groups](#variable-assignment-to-groups)
  - [Configuration](#configuration)
  - [Ad Hoc Commands](#ad-hoc-commands)
    - [Ping Module](#ping-module)
    - [Command Module](#command-module)
    - [Copy Module](#copy-module)
    - [File Module](#file-module)
    - [Setup Module](#setup-module)
  - [Task: Deploy two-tier app with Ansible](#task-deploy-two-tier-app-with-ansible)
    - [Target Architecture](#target-architecture)

## Fundamentals

### IaC vs Configuration Management

- Ansible falls under configuration management (CM) tool
- IaC is the practise of managing and provisioning infrastructure using code and automation instead of manual processes e.g. Terraform.
- CM focuses on installing, configuring and managing software and system settings on existing infrastructure.
- Whilst infrastructure can be provisioned with CM tools, it is not their primary purpose.

### Provisioning Infrastructure with CM tools

- possible with some CM tools e.g. Ansible using `cloud modules`, but not as powerful as terraform for complex infrastructure provisioning. Lacks built-in state management.

### What is Ansible and how does it work?

- Open-source automation tool
- Can run anywhere
- Automate virtually any task
- Built on Python
- Uses human-readable scripts called playbooks (yaml) to automate the task
- Define declarative state in the playbook i.e. what you want the system to look like. Ansible ensures it remains in that state.

- principles:
  - **agent-less architecture**: no need to install ansible on managed nodes
  - **simplicity**: simple yaml syntax for playbooks. Decentralised, can use SSH with existing keys for authentication.
  - **scalability and flexibility**: modular design allows easy and quick scaling. Support range of operating systems, cloud platforms and network devices.
  - **idempotency and predictability**: can run playbook many times, ansible maintains desired state.

### Alternatives to Ansible

#### Puppet

##### Overview

- Developed by **Puppet, Inc.**, Puppet is a declarative configuration management tool.
- Uses a client-server (agent-master) model.
- Written in **Ruby** and uses its own domain-specific language (**Puppet DSL**).

##### Features

- **State enforcement**: Ensures system configuration is maintained.
- **Centralised control**: Uses a **Puppet Master** to manage multiple nodes.
- **Idempotent**: Runs only required changes, similar to Ansible.
- **Strong reporting & compliance management**.

##### Pros & Cons

✅ **Scalable**, best suited for large enterprises.  
✅ **Mature ecosystem** with a large number of modules.  
❌ **Steeper learning curve** due to Puppet DSL.  
❌ **Requires an agent** installed on managed nodes.  

##### Use Case

- Large-scale infrastructure automation and compliance enforcement.

---

#### Chef

##### Overview

- A configuration management tool written in **Ruby**.
- Uses a procedural approach with **Chef Recipes & Cookbooks**.
- Follows a client-server architecture.

##### Features

- **Uses Ruby-based DSL** for writing configurations.
- **Knife CLI** for managing servers.
- **Chef Server, Chef Client, and Chef Workstation** architecture.
- **Test-driven infrastructure development**.

##### Pros & Cons

✅ **Highly flexible** and customisable.  
✅ **Strong community and support**.  
❌ **More complex syntax** compared to YAML (Ansible).  
❌ **Requires an agent** to be installed.  

##### Use Case

- Best for DevOps teams requiring a **highly customisable** configuration tool.

---

#### SaltStack (Salt)

##### Overview

- Open-source configuration management and orchestration tool.
- Uses a client-server model but also supports agentless mode.
- Written in **Python**.

##### Features

- **Event-driven automation**.
- **Faster than Ansible** due to ZeroMQ messaging.
- Uses **YAML-based state files**.
- Can be **agent-based or agentless**.

##### Pros & Cons

✅ **High-speed remote execution** (faster than Ansible).  
✅ **Scales well** for large environments.  
❌ **More complex setup** than Ansible.  
❌ **Requires Salt Master and Minions (for agent mode)**.  

##### Use Case

- Large-scale infrastructure requiring **fast** automation and execution.

---

#### Terraform

##### Overview

- An **Infrastructure as Code (IaC)** tool developed by **HashiCorp**.
- Manages cloud infrastructure provisioning (e.g., AWS, Azure, GCP).
- Uses **HCL (HashiCorp Configuration Language)**.

##### Features

- **Declarative configuration** (similar to Ansible).
- **Works best with cloud providers**.
- **State management** with a Terraform state file.
- **Modular infrastructure deployment**.

##### Pros & Cons

✅ **Best for provisioning and infrastructure automation**.  
✅ **Strong support for cloud services**.  
❌ **Not a full configuration management tool** (unlike Ansible).  
❌ **No built-in agent for continuous enforcement**.  

##### Use Case

- Ideal for **cloud automation, infrastructure provisioning, and scaling**.

---

#### Rudder

##### Overview

- Open-source **continuous configuration and compliance** management tool.
- Uses an agent-based model.
- Web-based interface for easy management.

##### Features

- **GUI-driven configuration**.
- **Policy-based enforcement**.
- Supports **real-time monitoring**.

##### Pros & Cons

✅ **Easier learning curve** compared to Puppet or Chef.  
✅ **Built-in compliance and reporting**.  
❌ **Less popular and smaller community**.  
❌ **Requires an agent**.  

##### Use Case

- Ideal for organisations needing **compliance enforcement** and easy-to-use interfaces.

---

#### Choosing the Right Tool

| Feature          | Ansible | Puppet | Chef  | SaltStack | Terraform |
|-----------------|---------|--------|-------|-----------|-----------|
| **Agentless**   | ✅      | ❌     | ❌    | ✅ (optional) | ✅       |
| **Declarative** | ✅      | ✅     | ❌    | ✅         | ✅       |
| **Procedural**  | ❌      | ❌     | ✅    | ❌         | ❌       |
| **Cloud Support** | ✅    | ✅     | ✅    | ✅         | ✅ (Best) |
| **Ease of Use** | ✅ (YAML) | ❌ (Puppet DSL) | ❌ (Ruby DSL) | ❌ | ✅ (HCL) |
| **Speed**       | ⚡ (Fast) | Medium | Medium | ⚡⚡ (Very Fast) | Medium |

##### Key Takeaways

- **Choose Ansible** if you want **agentless, easy YAML-based automation**.
- **Choose Puppet/Chef** for **complex enterprise configurations**.
- **Choose SaltStack** if you need **speed and event-driven automation**.
- **Choose Terraform** if your focus is **cloud infrastructure provisioning**.
- **Choose Rudder** for **compliance-driven automation**.

### Major industry leaders using IaC and CM tools

## Architecture

![architecture](images/architecture.svg)

## Setup on Ubuntu

### Installation

- Update ubuntu package lists

```bash
sudo apt update
```

- ubuntu's default repositories include ansible, so installation is simple.

```bash
sudo apt install ansible -y
```

- check ansible installation.

```bash
ansible --version
```

---

- Note, ansible is written in Python and the tasks ran on managed nodes are python scripts. In fact, installing Ansible using PIP simply installs various Python modules.
- So Python is a dependency for Ansible. On the control node, Ansible needs to be installed but on a managed node, only Python is needed as the interpreter is used to run the scripts and output results back to the control node.

---

### Configure SSH access for Ansible

- need SSH access for control node to communicate with managed nodes
- will setup SSH key-based authentication for ease and security

- generate SSH key pair

```bash
ssh-keygen -t rsa -b 4096 -C "email@example.com"
```

- then need to move public key to your managed node.

```bash
ssh-copy-id username@<managed_node_ip>
```

- enter user's password when prompted.
- this will move the public key to the authorised keys directory on the system so the ansible controller can authenticate with it via SSH.

- confirm ssh access into the managed node. No need to specify private key, will automatically pick it up if in default location.

```bash
ssh username@<managed_node_ip>
```

## Ansible Inventory

- this file defines the hosts and groups of hosts upon which commands, modules and tasks in a playbook operate.
- tells ansible what machines it can connect to.
- this `hosts` file should be created in `/etc/ansible/` directory.
- example setup below where both control node and managed node are on the same local machine.

```ansible
[local]
localhost ansible_connection=local

[webservers]
web1 ansible_host=localhost ansible_connection=ssh ansible_user=<username>
```

- defines two groups, `local` and `webservers`
- `localhost ansible_connection=local` tells ansible to connect to the local machine directly, without using SSH.
- `web1 ansible_host=localhost ansible_connection=ssh ansible_user=<username>` defines host called web1, also connecting to localhost but using ssh and logging in as user specified.

- test connectivity to hosts.

```bash
ansible all -m ping
```

- run on `all` hosts
- `-m ping`, use ansible ping module

- should see success for both hosts. It means ansible can reach both hosts successfully.

- can use default ansible command module to check system uptime.

```bash
ansible all -a "uptime"
```

- `CHANGED` means the uptime command ran successfully on the host. Can see output as shown.

### Variable Assignment to Groups

- Can assign variables to groups in inventory file. Can use these variables in playbooks and templates, making the ansible code flexible and reusable.

- example:

```ansible
[webservers]
localhost ansible_connection=local

[production:children]
webservers

[webservers:vars]
http_port=80
```

- assigns variable http_port with value 80 to all hosts in webservers group.
- `:vars` suffix is used to define variables for a group.
- can reference this variable in e.g. a yml playbook using the `{{ http_port }}` syntax.

## Configuration

- check if any system wide config file

```bash
cat /etc/ansible/ansible.cfg
```

- check ansible default configuration values.

```bash
ansible-config dump
```

- create custom `ansible.cfg` config file e.g.

```ansible
[defaults]
inventory = <full_inventory_file_path>
remote_user = <username>
host_key_checking = False
stdout_callback = yaml

[privilege_escalation]
become = True
become_method = sudo
become_user = <privilege_username>
become_ask_pass = False
```

- check if ansible is using new custom config

```bash
ansible-config dump --only-changed
```

- should see the config as defined in `ansible.cfg`.

## Ad Hoc Commands

- quick one-off tasks you can run without the need for a full playbook
- e.g. check system status, manage files, execute quick commands across multiple servers.

- general structure:

```bash
ansible <pattern> -m <module> -a "<module options>"
```

- `pattern` is the host or group of hosts from your inventory that you want to target.
- `-m module` specifies which ansible module to use
- `-a "<module optiona>"` provides arguments to the module.

### Ping Module

- ping is an example of an ad hoc command.
- ping all hosts in the `inventory` file

```bash
ansible all -i inventory -m ping
```

### Command Module

- common module used to run arbitrary commands on target hosts
- e.g. check disk space for all hosts

```bash
ansible all -i inventory -m command -a "df -h"
```

- e.g. check uptime for webservers group

```bash
ansible webservers -i inventory -m command -a "uptime"
```

- if you don't specify a module, will use default command module.
- so can omit the -m command.
- e.g. show memory usage for dbservers group

```bash
ansible dbservers -i inventory -a "free -m"
```

- note, command module doesn't support shell variables or operations like `|, <, >, &` etc. Need to use shell module for that.

### Copy Module

- used to copy files from the local machine to the remote hosts
- e.g. create a simple file and copy it to all hosts (/tmp directory)

```bash
echo "Hello from Ansible" > hello.txt
ansible all -i inventory -m copy -a "src=hello.txt dest=/tmp/hello.txt"
```

### File Module

- used to manage files and directories
- e.g. create a directory on all webservers

```bash
ansible webservers -i inventory -m file -a "path=/tmp/test_dir state=directory mode=0755"
```

- creates a directory named test_dir in the /tmp directory on all webservers, with permissions set to 0755.

### Setup Module

- used to gather facts about the remote hosts
- automatically run at the beginning of playbooks, but can also be used in ad-hoc commands

```bash
ansible dbservers -i inventory -m setup
```

- will display a large amount of information about the hosts in dbservers group.
- can use filters to limit the output

```bash
ansible dbservers -i inventory -m setup -a "filter=ansible_distribution*"
```

- will only show facts related to the OS distribution.

## Task: Deploy two-tier app with Ansible

### Target Architecture

