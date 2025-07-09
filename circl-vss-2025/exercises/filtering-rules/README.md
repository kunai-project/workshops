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

> :warning: **Remember** that kunai rules have **OR** relationship between them. So pay attention to excluded events, always make sure there is no other rule including it.


### Bonus
- Use `kunai-stats` (seen above) to confirm your log filtering works