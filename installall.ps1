$myargs = $args

devices | foreach {
    iex "adb -s $_ install $myargs"
}
