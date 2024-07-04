# Using Kunai to Match IoCs

Kunai can be fed with IoCs in order to detect
**known threats**, let's explore this possibility.

The expected format for a **single IoC** is the following.

```json
{"uuid": "ioc_uuid", "source":"Some IoC source", "value":"ioc_value"}
```

To tell kunai to load this file, one need to set a specific command line flag (or configuration setting).

```bash
sudo kunai -i IOC_FILE
```

# Instructions

1. create an **IoC file** to catch events containing `circl.lu`
2. start kunai with the good parameters
3. try to trigger a detection
4. what do you observe

# Using misp-to-kunai.py

[misp-to-kunai.py](https://github.com/kunai-project/tools/blob/main/misp/misp-to-kunai.py) is part of [kunai-tools](https://github.com/kunai-project/tools/) and can be used to pull **IoCs** from a **MISP** instance.

* can be used to pull events from a **MISP** feed (no API key needed)
* can be used to pull events from a **MISP** instance you have an API key

1. use `misp-to-kunai.py` to pull events from **MISP** feed provided by **CIRCL**
2. start kunai with the proper parameters so that it loads the **IoC file** 
3. try to trigger a detection

**BONUS**: run the script as a service so that you always get fresh **IoCs**

# Resources

**IoC configuration**: https://why.kunai.rocks/docs/advanced/ioc_configuration

# Going Further

Export to IoCs of your favorite Threat-Intelligence Provider
and use them with Kunai. 