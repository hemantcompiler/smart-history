# Copyright (C) 2016, Mert Bora ALPER <bora@boramalper.org>
# All rights reserved.


function smart-history-initialize
    if not set --query smart_history_index
        set -g prev_cmdline ""
        set -g smart_history_index (eval smart-history.py)
        if test (count $smart_history_index) -eq 1
            set -g smart_history_initialized 1
        else
            set -g smart_history_initialized 0
        end
    end

    return $smart_history_initialized
end


function smart-history-backward
    # If not initialized, try so.
    if not set --query smart_history_initialized
        smart-history-initialize
    end

    # If initialization failed, stop execution of the function.
    if test $smart_history_initialized -eq 0
        echo "smart-history: error: python3 script was inaccessible, aborting." 1>&2
        return
    end

    # If current commandline is not same with the previous commandline that we
    # set, then it's very probable that user is iterating the history from
    # the beginning (and vice versa; if current commandline is same as the
    # previous commandline, continue iterating without resetting the index).
    set cur_cmdline (commandline)
    if test $cur_cmdline != $prev_cmdline
       set -g smart_history_index (eval smart-history.py)

       # Because at the beginning of the while loop below, we decrease
       # $smart_history_index by one.
       set -g smart_history_index (math "$smart_history_index + 1")
    end

    while test $smart_history_index -ge 0
        set -g smart_history_index (math "$smart_history_index - 1")

        set history_entry (eval smart-history.py $smart_history_index)
        set failed 0

        set i 2;
        while test $i -le (count $history_entry)
            set path $history_entry[$i]

            # If $path does not exist in the current directory...
            if not test -e $path
                set failed 1
                break
            end

            set i (math "$i + 1");
        end

        if test $failed -ne 1
            set -g prev_cmdline $history_entry[1]
            commandline $history_entry[1]
            break
        end
    end
end


function smart-history-forward
    # If not initialized, try so.
    if not set --query smart_history_initialized
        smart-history-initialize
    end

    # If initialization failed, stop execution of the function.
    if test $smart_history_initialized -eq 0
        echo "smart-history: error: python3 script was inaccessible, aborting." 1>&2
        return
    end

    # If current commandline is not same with the previous commandline that we
    # set, then it's very probable that user is iterating the history from
    # the beginning (and vice versa; if current commandline is same as the
    # previous commandline, continue iterating without resetting the index).
    set cur_cmdline (commandline)
    if test $cur_cmdline != $prev_cmdline
       set -g smart_history_index (eval smart-history.py)

       # Because at the beginning of the while loop below, we increase
       # $smart_history_index by one.
       set -g smart_history_index (math "$smart_history_index - 1")
    end

    while test $smart_history_index -lt (eval smart-history.py)
        set -g smart_history_index (math "$smart_history_index + 1")

        set history_entry (eval smart-history.py $smart_history_index)
        set failed 0

        set i 2;
        while test $i -le (count $history_entry)
            set path $history_entry[$i]

            # If $path does not exist in the current directory...
            if not test -e $path
                set failed 1
                break
            end

            set i (math "$i + 1");
        end

        if test $failed -ne 1
            set -g prev_cmdline $history_entry[1]
            commandline $history_entry[1]
            break
        end
    end

    if not test $smart_history_index -lt (eval smart-history.py)
        commandline ""
    end
end
