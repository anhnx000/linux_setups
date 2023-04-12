1. git clone https://github.com/NVIDIA/apex.git
2. pip install -v --disable-pip-version-check --no-cache-dir ./apex

ERROR:

"""

cwd: /home/anhnx5/work/xa_msleison/data/apex/

  Preparing metadata (setup.py) ... error

error: metadata-generation-failed

× Encountered error while generating package metadata.

╰─> See above for output.

**note: This is an issue with the package mentioned above, not pip.**

hint: See above for details

"""

# ==> should fix packet, NOT PIP

==> you should add CUDA PATH


[](https://stackoverflow.com/posts/74899520/timeline)

If using anaconda to install, the following would apply:

```python
export CUDA_HOME=$CONDA_PREFIX
```

You can add this to `~/.bashrc` or `~/.bash_profile` to have this environment variable persist between sessions. To apply this change in the bash file to your current session run: `source ~/.bashrc` or `source ~/.bash_profile`

Verify this by issuing an `echo $CUDA_HOME` command.
