Glynn
=====

Glynn offers you a bin to easily send a jekyll powered blog to your host through FTP.  
[![Build Status](https://travis-ci.org/dmathieu/glynn.png)](https://travis-ci.org/dmathieu/glynn)

Installation
------------

Glynn comes as a gem. It has no dependencies other than the ruby default libraries.
Install it with gem install.

    gem install glynn --source http://gemcutter.org

That's it! You now have the Glynn executable on your machine.
Go to your jekyll project, configure the host and distant directory where the files will be sent.
For example, below is my **_config.yml** file. You can also store these options and FTP credentials in a file called **_glynn.yml** in the root of your project directory instead of **_config.yml** if you prefer. 

    markdown: rdiscount
    pygments: true
    auto: true

    ftp_host: 'dmathieu.com'
    ftp_dir: '/web/site/root'
    ftp_passive: false

    # optional
    ftp_port: 21                  # default 21
    ftp_username: 'your_user'     # default read from stdin
    ftp_password: 'your_ftp_pass' # default read from stdin
    ftp_secure: true              # default false

Glynn will connect itself to the host "dmathieu.com" and send every file to the FTP directory /web/portfolio.
To do so, you just need to be at the top of your jekyll project. And in a console, enter the following :

    glynn

Quite simple again. It'll connect to the remote host, ask you for login and password and send the files :)

Contributing
------------

If you think Glynn is great but can be improved, feel free to contribute.
To do so, you can :

* [Fork](http://help.github.com/forking/) the project
* Do your changes and commit them to your repository
* Test your changes. We won't accept any untested contributions (except if they're not testable).
* Create an [issue](http://github.com/dmathieu/glynn/issues) with a link to your commits.

And that's it! I'll soon take a look at your issue and review your changes.

Author
------------------

Damien MATHIEU :: 42 (AT|CHEZ) dmathieu.com
