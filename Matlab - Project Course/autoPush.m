function autoPush()

command = 'git add *';
[status,cmdout] = system(command)

command = 'git commit -m "auto push "';
[status,cmdout] = system(command)

command = 'git push';
[status,cmdout] = system(command)


end