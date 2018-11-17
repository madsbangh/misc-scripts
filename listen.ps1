start-job {
	cd $args[0]
	while ($true) {
		sleep 30
		git fetch
	}
} -ArgumentList (gl) -Name ListenAndFetch
