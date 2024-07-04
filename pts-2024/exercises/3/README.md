# Exploring Rule based Configuration

Kunai generates loads of events, but if you are monitoring
systems you might not want all the logs flowing in your monitoring system.This is where **detection** and **filtering** rules come into play.

To ease rule design and testing, kunai has specific `replay` command one can use to replay logs into the filtering/detection/IoC scanning engine.

```bash
# kunai replay examples
# using kunai replay on a file
kunai replay -i IOC_FILE -r RULE_FILE LOG_FILE

# using kunai replay on stdin
zcat kunai.jsonl.gz | kunai replay -i IOC_FILE -r RULE_FILE -
```

## General Memo :
* **detection rule:** used to **detect** a malicious pattern. Event matching a detection rule will be modified and contain `.detection` section
* **filtering rule:** used to **select** logs to keep context. Keeping context is an important piece as **detection** alone is often useless. The context helps when investigating a **suspicious** event and hopefully allow you to figure out if it is relevant or not. Filtering rules will output event **unmodified**
* **When not to use rule**: to match something that would fit in a **IoC** because **IoC match** is way faster than **rule match**.

## Memo about rules syntax

1. `match-on` section is very important as it allows to quickly filter events
1. every `match` in `matches` must be in the form `$OPERAND: FIELD_PATH OPERATOR 'VALUE'`
    * `FIELD_PATH`: **field's absolute path** starting with `.`, separated by `.`
    * `OPERATOR`: 
        * `==` : **equality operator**
        * `>=`, `<=`, `>`, `<` : **comparison operators** &rarr; `VALUE` must be a **number**
        * `&=` : **flag checking operator** &rarr; `VALUE` must be a **number**
        * `~=` : **regex operator** &rarr; `VALUE` must be a **string** regex following [syntax](https://docs.rs/regex/latest/regex/#syntax)
    * every **field value** found at `FIELD_PATH` is expected to be of the same type than `VALUE`
1. `condition` supports `not`, `and` and `or` keywords

# Instructions

1. run kunai for a little time **with output redirection** to a file
```bash
sudo kunai | tee /tmp/kunai.jsonl
```
2. interact a bit with your system to generate activity
3. stop kunai by hitting `Ctrl+C`
4. find a **toy event** you will try to detect using a **detection rule**
5. define a category of events you want to **filter in** to bring context to your detection
6. build a **detection** rule
7. validate the rule you've created by using kunai `replay` command
8. build a **filtering** rule (tip: don't forget **filter** parameter to set in rule definition)
9. validate the rule you've created by using kunai `replay` command
10. run kunai `replay` with both the rules and observe the results

# Resources

**Rules configuration**: https://why.kunai.rocks/docs/advanced/rule_configuration

# Going Further

Export to IoCs of your favorite Threat-Intelligence Provider
and use them with Kunai. 