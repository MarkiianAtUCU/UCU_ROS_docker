# MIT License

# Copyright (c) 2016 TomÃ¡Å¡ BÃ¡Äa

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

export TMUX_BIN=/usr/bin/tmux  

# is the shell running interactively
case "$-" in
  *i*) INTERACTIVE_SHELL=1
esac

# running new tmux (or attaching) with session name derived from parent bash pid
runTmux() {

  SESSION_NAME="T$BASHPID"
  
  # try to find session with the correct session id (based on the bashs PID)
  EXISTING_SESSION=`$TMUX_BIN ls 2> /dev/null | grep "$SESSION_NAME" | wc -l` 

  if [ "$EXISTING_SESSION" -gt "0" ]; then
  
    # if such session exists, attach to it
    $TMUX_BIN -2 attach-session -t "$SESSION_NAME"
  
  else
  
    # if such session does not exist, create it
    $TMUX_BIN new-session -s "$SESSION_NAME"
  
  fi 

  # hook after exitting the session
  # when the session exists, find a file in /tmp with the name of the session
  # and extract a path from it. Then cd to it.
  FILENAME="/tmp/tmux_restore_path.txt"
  if [ -f $FILENAME ]; then

    MY_PATH=$(tail -n 1 $FILENAME)

    rm /tmp/tmux_restore_path.txt

    cd $MY_PATH

  fi
}

if [ ! -z "$INTERACTIVE_SHELL" ]; then # when loaded interactively
  _trap_exit() { $TMUX_BIN kill-session -t "T$BASHPID"; }                                                       
  trap _trap_exit EXIT                                                                                  
fi


# load tmux automatically                                                                             
if [ ! -z "$INTERACTIVE_SHELL" ]; then # when loaded interactively, run tmux
  if command -v $TMUX_BIN>/dev/null; then                                                                    
    if [ "$RUN_TMUX" = "true" ]; then
      [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && runTmux                                                  
    fi                                                                                                  
  fi
fi