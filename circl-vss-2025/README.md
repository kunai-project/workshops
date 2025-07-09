# CIRCL Virtual Summer School: Kunai Workshop
## Roadmap
| Time | Duration | Topic | Description | Hands-On |
| - | - | - | - | - |
| 2:00 PM | 15 min | Introduction | Welcome and introduction to the workshop. Overview of the agenda and objectives. | |
| 2:15 PM | 20 min | Kunai Overview | Introduction to Kunai: background, purpose, and key features. | |
| 2:35 PM | 30 min | [Basic Feature Discovery](#Basic-Feature-Discovery) | Hands-on exercises to explore what logs can be obtained using Kunai. | ✓ |
| 3:05 PM | 30 min | [Using Kunai Tools](#Using-Kunai-Tools) | Introduction and hands-on exercises with the Python tools provided by Kunai. | ✓ |
| 3:35 PM | 15 min | Break | Short break to rest and recharge. | |
| 3:50 PM | 30 min | [Configuration with IoCs](#Configuration-with-IoCs) | Step-by-step guide on how to configure Kunai with a MISP server. | ✓ |
| 4:20 PM | 30 min | [Advanced Configuration: Detection Rules](#Advanced-Configuration-Detection-Rules) | Hands-on session on setting up and managing detection rules. | ✓ |
| 4:50 PM | 30 min | [Advanced Configuration: Log Filtering](#Advanced-Configuration-Log-Filtering) | Hands-on session on advanced configuration focusing on log filtering. | ✓ |
| 5:20 PM | 30 min | [Configuring Kunai with Yara Rules](#Configuring-Kunai-with-Yara-Rules) | Practical exercises on configuring Kunai with Yara rules for malware detection. | ✓ |
| 5:50 PM | 10 min | Q&A Session and Feedback | Open floor for participants to ask questions, provide feedback, and discuss their experiences. | |
:::info
During hands-on times, participants are **highly encouraged** to do exercises at the same time as the presenter so that they can notice any pain points and ask questions.
:::
## Pre-requisites
:::warning
Anything in this section will not be covered during the workshop. We expect the students to have **ready to use environments**.
:::
### System Requirements
**Virtual Machine or Physical Machine**: Ensure you have access to a virtual machine or a physical machine running:
- a **Linux kernel** above **v5.4**
- **x86_64 or aarch64 architectures**
**Using a virtual machine is recommended for ease of setup and isolation.**
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
2. Download the signature file (i.e., the one ending with `.asc`) corresponding to the binary you previously downloaded.
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
# Hands-On
## Basic Feature Discovery
### Learning Objectives
- Learn how to run basic kunai command lines to start monitoring system activities
- Learn and understand kunai event's structure
- Get familiar with all the events available in kunai

### Instructions
1. Run **kunai**
    ```bash
    # kunai always needs to run as root
    sudo kunai | jq '.' | tee /tmp/kunai.json
    ```
2. Let it run for a few seconds and inspect the output file
    ```bash
    vim /tmp/kunai.json
    ```
3. Get familiar with event's structure: [https://why.kunai.rocks/docs/events/generalities](https://why.kunai.rocks/docs/events/generalities)
4. Explore all available **events**: [https://why.kunai.rocks/docs/events/](https://why.kunai.rocks/docs/events/)

### Optional Bonus
1. Some kunai events are not enabled by default, run the following command to see them all
    ```bash
    sudo kunai run --include=all | jq '.'
    ```
## Using Kunai Tools
### Learning Objectives
- Get basic knowledge about external tools to make your life easier

### Instructions
1. Use `kunai-search` to ease log recursive search
    - Recursive search by task UUID
    - Recursive search by hash
2. Use `kunai-stats` to stats event throughput.

### Optional Bonus
1. Explore additional command-line options for `kunai-search` and `kunai-stats`.
2. Combine these tools with other Unix utilities like `grep`, `awk`, or `sed` for more complex queries.
## Configuration with IoCs
### Learning Objectives
- Learn how to configure Kunai to match IoCs
- Learn how quickly build Kunai compatible IoCs lists from any IoC list
- Learn how to pull IoCs from a MISP instance/feed
### Related Documentation
- [https://github.com/kunai-project/pykunai#tools](https://github.com/kunai-project/pykunai#tools)
- [https://why.kunai.rocks/docs/advanced/ioc_configuration](https://why.kunai.rocks/docs/advanced/ioc_configuration)
### Instructions
#### How to match IoCs
1. Create a file containing this JSON object
    ```json
    {"uuid": "ad3b743b-12f3-4433-8a90-8abccfb47080", "source": "circl-vss", "value": "circl.lu", "severity": 10}
    ```
2. What do you observe? No logs anymore ...
    :::info
    This is normal you don't see **logs flowing** anymore. When Kunai is configured with **IoCs** or **filtering/detection rules** (c.f. next exercise) **only matching events** are displayed
    :::
3. Run kunai configured with IoC list
    ```bash
    sudo kunai run -i $IOC_FILE
    ```
4. In a **separate terminal** run
    ```bash
    curl https://circl.lu
    ```
#### How to create IoCs from any IoC source
1. Use another kunai tool to add an IoC
    ```bash
    kunai-iocgen circl-vss why.kunai.rocks 10 >> $IOC_FILE
    ```
2. In a **separate terminal** run
    ```bash
    curl https://why.kunai.rocks
    ```
#### Bonus
* Write a small script capable of processing a CSV file and generating IoCs ready for kunai
    ```csv
    source,type,value
    mandiant,domain,circl.lu
    eset,ip,8.8.4.4
    ```
#### How to use MISP's IoCs
1. Prepare **misp-to-kunai** configuration file in `/tmp/m2k-config.toml`
    ```toml
    [misp]
    # MISP Server Name
    name = "My MISP Server"
    # MISP server URL
    url = "https://your.misp.server:8443"
    # API key to access MISP server
    key = "ChangeMe"
    # TLS verification
    ssl = true
    # It is disabled
    enable = false

    # Support feeds in MISP format
    [[misp-feeds]]
    name = "CIRCL OSINT Feed"
    url = "https://www.circl.lu/doc/misp/feed-osint"
    enable = true
    ```
2. Run `misp-to-kunai` to get IoCs from the last **90 days**
    ```bash
    misp-to-kunai -c $CONFIG -l 90 | tee /tmp/iocs-l90.json
    ```
3. Run kunai with those
    ```bash
    # and there we go
    sudo kunai run -i /tmp/iocs-l90.json
    ```
4. Find an IoC to verify everything works
    ```bash
    grep 'domain' /tmp/iocs-l90.json | tail -n 1
    ```
5. Test kunai detects it
    ```bash
    dig $DOMAIN_YOU_FOUND
    ```
#### Bonus
* Run `misp-to-kunai` in a loop with `--service`
    ```bash
    misp-to-kunai -c $CONFIG --service -l 30 -o $IOC_FILE
    ```
## Advanced Configuration: Detection Rules
### Learning Objectives
- Learn how to create very specific kunai detection rules to spot complex techniques
- Learn how to load kunai engine with several detection rules
### Related Documentation
- [https://why.kunai.rocks/docs/advanced/rule_configuration/#detection-rules](https://why.kunai.rocks/docs/advanced/rule_configuration/#detection-rules)
- [https://why.kunai.rocks/docs/advanced/rule_configuration/#memo-about-kunai-rules](https://why.kunai.rocks/docs/advanced/rule_configuration/#memo-about-kunai-rules)
### Instructions
1. Create a directory to store detection rules
    ```bash
    mkdir -p /tmp/rules/detections
    ```
2. Edit a file `/tmp/rules/detections/vim.kun` and copy the following content
    ```yaml
    # name of the rule
    name: vim.suspicious.child
    # default type is detection so the following line is not mandatory
    type: detection
    # metadata information
    meta:
        # tags of the rule
        tags: [ 'os:linux' ]
        # MITRE ATT&CK ids
        attack: [ T4242 ]
        # authors of the rule
        authors: [ your_name ]
        # comments about the rule
        comments:
            - catches a text editor spawning a command line with http URL
    # acts as a pre-filter to speed up engine
    match-on:
        events:
            # we match on kunai execve and execve_script events
            kunai: [execve, execve_script]
    matches:
        $vi_parent: .data.ancestors ~= '/usr/bin/vim?'
        $http_in_cli: .data.command_line ~= 'https?://'
    condition: all of them
    # severity is bounded to 10
    severity: 7
    ```
3. Run kunai configured with detection rule(s)
    :::info
    Rule files must have `.kun` extension so that kunai can load it from a directory
    :::
    ```bash
    sudo kunai run -r /tmp/rules/detections | jq '.'
    ```
4. Start `vim` or `vi` (in another terminal) and run a curl command
    ```bash
    # hit CTRL+C in vi/vim then write
    !curl https://why.kunai.rocks
    ```
5. Observe kunai output
### Bonus
1. Create another rule file with the following content
    ```yaml
    name: run.tmpfs
    meta:
        tags: [ 'os:linux' ]
        attack: [ T1027.011 ]
        authors: [ your_name ]
        comments:
            - if something is running in tmpfs it is suspicious and we should stack up
    matches:
        $a: .data.ancestors ~= '\|(/tmp/|/dev/shm/|/run/|/var/(run|lock)/)\|?'
        $p: .data.exe.path ~= '^(/tmp/|/dev/shm/|/run/|/var/(run|lock)/)'
    # $a is the slowest so run last
    condition: $p or $a
    severity: 2
    ```
2. Run kunai
    ```bash
    sudo kunai run -r /tmp/rules/detections | jq '.'
    ```
3. Copy curl in `/tmp`
    ```bash
    cp /usr/bin/curl /tmp/c
    ```
4. Start `vim` or `vi` (in another terminal) and run a curl command with the curl copy in `/tmp`
    ```bash
    # hit CTRL+C in vi/vim then write
    !/tmp/c https://why.kunai.rocks
    ```
5. Observe kunai output
## Advanced Configuration: Log Filtering
### Learning Objectives
- Learn how to add context to your detections by logging some very specific activity
- Learn how to shrink kunai log volume by creating selective filters
### Related Documentation
- [https://why.kunai.rocks/docs/advanced/rule_configuration/#filtering-rules](https://why.kunai.rocks/docs/advanced/rule_configuration/#filtering-rules)
- [https://why.kunai.rocks/docs/advanced/rule_configuration/#memo-about-kunai-rules](https://why.kunai.rocks/docs/advanced/rule_configuration/#memo-about-kunai-rules)
### Instructions
1. Create a directory to store detection rules
    ```bash
    mkdir -p /tmp/rules/filters
    ```
2. Edit a file `/tmp/rules/filters/all.kun` and copy the following content
    ```yaml
    name: include.all.but.noisy
    type: filter
    meta:
        # not mandatory
        tags: [ 'some:tag' ]
    match-on:
      events:
          # we can put - in front of the events we don't want this rule
          # to apply on. The following means, everything except
          # mprotect_exec and prctl
          kunai: [ '-mprotect_exec', '-prctl' ]
    # rule with no condition always returns true
    ```
3. Run kunai with filter configured
    ```yaml
    sudo kunai run -r /tmp/rules/filters | jq '.'
    ```
4. Observe kunai logs
:::warning
**Remember** that kunai rules have **OR** relationship between them. So pay attention to excluded events, always make sure there is no other rule including it.
:::
### Bonus
- Use `kunai-stats` (seen above) to confirm your log filtering works
## Configuring Kunai with Yara Rules
### Learning Objectives
- **Use Kunai configured with Yara rules:** Integrate Kunai and Yara rules to monitor system events and scan system files with Yara.
- **Configure Kunai Actions:** Set up actions in Kunai to automatically react to specific events or detections.
### Instructions
1. Define a **Kunai** rule into a file of your choice
    ```yaml
    # we define here a dependency rule
    # NB: if this rule is used in several others it will
    # be evaluated only once per event scanned.
    name: dep.run.tmpfs
    # rule type to make the rule a dependency
    type: dependency
    matches:
        $a: .data.ancestors ~= '\|(/tmp/|/dev/shm/|/run/|/var/(run|lock)/)\|?'
        $p: .data.exe.path ~= '^(/tmp/|/dev/shm/|/run/|/var/(run|lock)/)'
    # $a is the slowest so run last
    condition: $p or $a
    ---
    # this rule scans any execution from tmpfs
    name: scan.tmpfs.run
    type: filter
    match-on:
        events:
            kunai: [ execve, execve_script ]
    matches:
        $bash_ext: rule(dep.run.tmpfs)
    condition: all of them
    actions: [ scan-files ]
    ```
2. Define a **Yara** rule into a file of your choice
    ```
    rule bin_ls {
        meta:
            description = "Detects /bin/ls"
        strings:
            $elf_magic = { 7F 45 4C 46 } // ELF magic number
            $ls_string = "List information about the FILEs (the current directory by default)."
        condition:
            $elf_magic at 0 and $ls_string
    }
    ```
3. Verify the Yara rule is working
    ```sh
    yara -r $YARA_RULE /bin/ls
    ```
4. Run kunai with both the rules configured
    ```sh
    sudo kunai run -y $YARA_RULE -r $KUNAI_RULE | jq '.'
    ```
5. In a separate terminal, run
    ```sh
    cp /bin/ls /tmp/blip && timeout 3s /tmp/blip -R /
    ```
6. Observe kunai output
### Bonus
1. Add this rule to your **Kunai** rule file
    ```yaml
    # this rule kill any file with a positive file scan
    name: positive.scan
    type: detection
    match-on:
        events:
            kunai: [ file_scan ]
    matches:
        $positive: .data.positives > '0'
    condition: all of them
    actions: [ kill ]
    ```
2. Restart kunai
3. In a separate terminal, run
    ```sh
    cp /bin/ls /tmp/blip && timeout 3s /tmp/blip -R /
    ```
4. What happens?