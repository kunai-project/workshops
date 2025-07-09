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