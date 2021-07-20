# Development/Production Environment

For Ubuntu 18.04 => Ubuntu 21.04

Bash Script For Easy Installing Apache2, Nginx, Openlitespeed, PHP, MariaDB, Nodejs and Python.

Also, It has ** Normal (any php script that not using public directory) and ** Laravel (Using public directory) Selection (For now for apache only)!

To Install => Simply run ``` apt -y install wget && wget https://raw.githubusercontent.com/mrnitr0/Development-Environment/main/installer.sh && bash installer.sh```

# Known Bugs

1- You will have a problem after installing Nginx that you have to run this ```rm -rf /etc/nginx/sites-enabled/dragon-normal.conf && systemctl restart nginx``` if you have chosen it for Laravel. Also, if you have chosen it for normal (for any php script) then you have to run this ```rm -rf /etc/nginx/sites-enabled/dragon-laravel.conf && systemctl restart nginx```

# You can report for any issue
# You can request features