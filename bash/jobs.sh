some_command(){
    sleep 3
    echo "I am done $SECONDS"
}

other_commands(){
    # A list of all the other commands that need to be executed
    sleep 5
    echo "I have finished my tasks $SECONDS"
}

some_command &                      # First command as background job.
SECONDS=0                           # Count from here the seconds.
bg_pid=$!                           # store the background job pid.
echo "one $!"                       # Print that number.
other_commands &                    # Start other commands immediately.
wait $bg_pid && echo "Foo $SECONDS" # Waits for some_command to finish.
wait                                # Wait for all other background jobs.
echo "end of it all $SECONDS"       # all background jobs have ended.
