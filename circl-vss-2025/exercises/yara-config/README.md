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