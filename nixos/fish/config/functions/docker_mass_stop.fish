function docker_mass_stop
       docker ps | tail -n +2 | grep "$argv[1]" | awk '{ print $1 }' | xargs -L 1000 -P 100 docker stop -t 3
end
