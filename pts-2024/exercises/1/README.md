# Warm up

## Kunai

Lets run the thing for a few minutes and see what info we can get.

```bash
# run kunai as sudo and pipe the output to a file (important)
# NB: jq is used here just to make a pretty json output
sudo kunai | jq '.' | tee /tmp/kunai.json

# execute a command in another terminal
whoami
```

Let's take a quick look at the [events documentation](https://why.kunai.rocks/docs/category/kunai---events)

## kunai-search.py

Helper script to help us searching into kunai-logs. It can be used for instance
to trace recursively all the activity of a task group (i.e. process).

NB: grep cannot be used (in an easy way) to track down processes recursively.
A lookup table needs to be updated along the way.

Let's use it quickly to understand how it works, we will need it in the next
exercise.

## misp-to-kunai.py

Small script to help us searching into kunai-logs. It can be used for instance
to trace recursively all the activity of a task group (i.e. process).

NB: grep cannot be used (in an easy way) to track down processes recursively.
A lookup table needs to be updated along the way.

Let's use it quickly to understand how it works, we will need it in the next
exercise.

