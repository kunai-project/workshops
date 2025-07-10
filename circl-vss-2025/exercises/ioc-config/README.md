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
    
1. Run kunai configured with IoC list
    ```bash
    sudo kunai run -i $IOC_FILE
    ```

1. What do you observe? No logs anymore ...
    > :information_source: This is normal you don't see **logs flowing** anymore. When Kunai is configured with **IoCs** or **filtering/detection rules** (c.f. next exercise) **only matching events** are displayed
    
1. In a **separate terminal** run
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