# Workflows

## Some Tips Related to Workflows

### Disabling Workflows

There is no built-in way to disable workflows. But GitHub only recognises configuration files in this directory as workflow if their filenames match `*.y{,a}ml`!

### "Run Core Task" Subjob

Although it is a bit boilerplate, it is recommended to write:

``` yaml
- name: Run Core Task
  env:
    SCRIPT_URL: <script-url>
    <further env variables>
  run: |
    curl -fslL "${SCRIPT_URL}" -o tmp_script
    chmod +x tmp_script
    ./tmp_script
```
