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