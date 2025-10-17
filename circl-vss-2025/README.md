# CIRCL Virtual Summer School: Kunai Workshop

## Roadmap

| Time | Duration | Topic | Description | Hands-On |
| - | - | - | - | - |
| 2:00 PM | 15 min | Introduction | Welcome and introduction to the workshop. Overview of the agenda and objectives. | |
| 2:15 PM | 20 min | Kunai Overview | Introduction to Kunai: background, purpose, and key features. | |
| 2:35 PM | 30 min | [Basic Feature Discovery](./exercises/basics/README.md) | Hands-on exercises to explore what logs can be obtained using Kunai. | ✓ |
| 3:05 PM | 30 min | [Using Kunai Tools](./exercises/kunai-tools/README.md) | Introduction and hands-on exercises with the Python tools provided by Kunai. | ✓ |
| 3:35 PM | 15 min | Break | Short break to rest and recharge. | |
| 3:50 PM | 30 min | [Configuration with IoCs](./exercises/ioc-config/README.md) | Step-by-step guide on how to configure Kunai with a MISP server. | ✓ |
| 4:20 PM | 30 min | [Advanced Configuration: Detection Rules](./exercises/detection-rules/README.md) | Hands-on session on setting up and managing detection rules. | ✓ |
| 4:50 PM | 30 min | [Advanced Configuration: Log Filtering](./exercises/filtering-rules/README.md) | Hands-on session on advanced configuration focusing on log filtering. | ✓ |
| 5:20 PM | 30 min | [Configuring Kunai with Yara Rules](./exercises/yara-config/README.md) | Practical exercises on configuring Kunai with Yara rules for malware detection. | ✓ |
| 5:50 PM | 10 min | Q&A Session and Feedback | Open floor for participants to ask questions, provide feedback, and discuss their experiences. | |

#### :information_source: During hands-on times, participants are **highly encouraged** to do exercises at the same time as the presenter so that they can notice any pain points and ask questions.

## Pre-requisites

### :warning: **IMPORTANT**
   * Anything in this section will not be covered during the workshop. We expect the students to have **ready to use environments**.
   * There is a **ready-made x86_64** VM available for [download](https://cra.circl.lu/circl-vss-2025/circl-vss-vm.ova)
   * All the people **running an ARM based laptop** will have to **setup a VM before the workshop**.

### System Requirements
**Virtual Machine or Physical Machine**: Ensure you have access to a virtual machine or a physical machine running:
- a **Linux kernel** above **v5.4**
- **x86_64 or aarch64 architectures**
> :information_source: **Using a virtual machine is recommended for ease of setup and isolation.**

### VM Setup
We recommend setting up a **Virtual Machine (VM)** for this workshop to isolate the environment and avoid conflicts with your existing setup. You can use software like VirtualBox or VMware to create a VM with the following (indicative) specifications:
- **OS**: Ubuntu 24.04 LTS
- **CPU**: 2 cores
- **RAM**: 4 GB
- **Storage**: 50 GB

### Software Installation
Run the following command to install all necessary tools and utilities:
```bash
sudo apt update
sudo apt install -y jq curl wget python3 pip pipx yara
pipx install pykunai
pipx ensurepath
```
Verify kunai tools get installed, in a **new terminal** run
```bash
which kunai-search
```

### Getting Kunai Ready
1. Download **Kunai** from GitHub on the [release page](https://github.com/kunai-project/kunai/releases).
2. Download the signature file (i.e., the one ending with `.asc`) **corresponding** to the binary you previously downloaded.
3. Add the signature key:
   ```bash
   gpg --keyserver pgp.circl.lu --recv-keys C0F6E8F2C1AB2799A31F416C0548A778D21D10AD
   ```
4. Verify your download. For example, if you downloaded the `x86_64` version of Kunai, use the following command:
   ```bash
   # example for kunai-amd64 download
   gpg --verify kunai-amd64.asc kunai-amd64
   ```
5. **Optional:** install kunai binary
    ```bash
    # example for kunai-amd64 download
    sudo kunai-amd64 install
    ```
