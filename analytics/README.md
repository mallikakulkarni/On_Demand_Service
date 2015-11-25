Analytics app
==============================

Step 0: Prerequisite
--------------------
This tutorial assumes that you have a (*)nix machine or any distro of Unix, including MacOSX. We have also assumed that you have installed mongodb and it is currently running on its default port.


Step 1: Installation
--------------------
Run the following commands when you are in the current directory.
You can create virtualenv if you want (suggested). More information on creating the virtualenv [here](http://docs.python-guide.org/en/latest/dev/virtualenvs/)
<p>`pip install -r requirements.txt`</p>
This will install all the necessary libraries to run the server.

Step 2: Run Server
------------------
Run this line on your terminal
<p>`python manage.py runserver`</p>


Using the API
=============

Admin data
----------
###Total Number of users on the site till date can be obtained by the URL:
<p>`/admin/total_visitors`</p>
>We are counting the number of unique ip_addresses and showing the result.

###Total Number of registered users on the site till date:
<p>`/admin/total_registered_visitors`</p>
>We are counting the number of unique user_id and showing the result.

###Visits per IP
<p>`/admin/visits_by_users`</p>
>We are counting the number of visits by ip_address and showing the result.

###Visits per user_id
<p>`/admin/visits_by_registered_users`</p>
>We are counting the number of visits by unique user_id and showing the result.
