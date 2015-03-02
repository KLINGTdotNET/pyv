# pyv - a wrapper for virtualenv that doesn't mess around with your shell

**pyv** is an alternative to [virtualenvwrapper](https://virtualenvwrapper.readthedocs.org/en/latest/) written in bash. It works like [vex](https://pypi.python.org/pypi/vex) by starting a subshell for your virtual environment. The advantage is, that you *don't* have to *deactivate* your virtual envrionment, instead you only have leave your subshell (`Ctrl+D`) to get back where you left off.

I've tested it with `bash` and `zsh`, but it should work with other shells too.

## Dependencies

**pyv**s only dependency is [virtualenv](https://virtualenv.pypa.io/en/latest/), because it uses it to create virtual envrionments ( in the following only *pyenvs*).

## Installation

- clone the repository
- make sure you have `virtualenv` installed, if not: `pip install --user virtualenv`
- set the `WORKON_HOME` environment variable with the path to the folder where your pyenvs should be stored, g.e. `~/.virtualenvs`
    - instead of `WORKON_HOME` you can set `PYENVS`
- source the `pyv.sh` in your `bash.rc` or `zsh.rc`
- done

## Features

- **pyv** supports *virtualenvwrappers* `PROJECT_HOME`, this means `pyv -c foo` will create the project directory `foo` under `$PROJECT_HOME` as well as the *pyenv* `foo`
- **startup hook**: if there is a file called `startup.sh` in your `$WORKON_HOME/pyenv_name` directory, then `pyv` will execute it when you run the *pyenv* `name`
- you can use `pyv -e name "command1 ..."` to run commands directly in a *pyenv*
    - note that `pyv -e` won't cd in the project directory nor execute the `startup.sh` hook

## Demo

![pyv demo](demo.gif)
recorded with [tty2gif](http://z24.github.io/tty2gif/)

## Help

- run `pyv -h`

## todo

...
