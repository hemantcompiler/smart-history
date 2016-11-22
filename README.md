# smart-history

_smarter history iteration for fish_

smart-history is a [fish](https://fishshell.com/) extension that skips erroneous
entries while iterating through the history. All computer programs (with some
possible exceptions) interact with the file system relative to their
[current working directory](https://en.wikipedia.org/wiki/Working_directory).
This means, a command that has been executed in one directory probably will fail
in another if the resource that has been referred does not exist in the current
working directory. smart-history validates all of the paths in a history entry
during iteration, so that it speeds up the process and reduces inconvenience.

## Remarks
* __smart-history is under heavy development__ and subject to
  backwards-incompatible changes. Use with care!
* Unlike the default history iteration of fish, smart-history iterates through
  the global history. (i.e. Commands that are executed afterwards in another
  shell will show up in the previous shell during iteration.)
  * This might be considered as a bug, since it is not consistent with fish's
    default behaviour. At least, the user should be able to disable this
    _feature_.
* smart-history cannot skip the duplicate entries, although it still validates
  them.
* smart-history does not perform "smart" history search yet; so whatever it is
  in the commandline buffer will be removed as if the buffer was empty.

## Installation
### Requirements
* fish >= 2.4.0
* Python 3

### Instructions
1. Go to the directory that you want to install smart-history.
2. Clone the repository

       ```
       git clone https://github.com/boramalper/smart-history.git
       ```

3. Create a symlink for `smart-history.py` somewhere in the path
   (`/usr/local/bin` is a good choice).

       ```
       ln -s "$PWD/smart-history/smart-history.py" /usr/local/bin/smart-history.py
       ```

4. Edit your `config.fish`

    ```
    # Add the following line before `fish_user_key_bindings` function
    source /path/to/installation/smart-history/smart-history.fish

    function fish_user_key_bindings
        # Add the following lines in fish_user_key_bindings function (if the
        # function doesn't exist, create one as shown here).

        # For emacs style (Ctrl+N for forward and Ctrl+P for backward) key
        # bindings.
        # If you want to use arrow keys, use \e\[A for up arrow (backward) and
        # \e\[B for down arrow (forward).
        # Think "backward" as going backwards in the history, and vice versa.
        bind \cp 'smart-history-backward'
        bind \cn 'smart-history-forward'
    end
    ```
## License
BSD 2-Clause, see [LICENSE](LICENSE) for details.
