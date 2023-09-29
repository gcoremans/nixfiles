function docker_mass_rm
       docker ps -a | tail -n +2 | grep "$argv[1]" | awk '{ print $1 }' | xargs -L 1000 -P 100 docker rm -f
end
