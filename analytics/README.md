Analytics app
==============================

Step 0: Prerequisite
--------------------
This tutorial assumes that you have a (*)nix machine or any distro of Unix, including MacOSX. We have also assumed that you have installed mongodb and it is currently running on its default port.


Step 1: Installation
--------------------
Run the following commands when you are in the current directory.
You can create virtualenv if you want (suggested). More information on creating the virtualenv [here](http://docs.python-guide.org/en/latest/dev/virtualenvs/)
``pip install -r requirements.txt``
This will install all the necessary libraries to run the server.

Step 2: Run Server
------------------
Run this line on your terminal
``python manage.py runserver``


Using the API
=============

Admin data
----------
###Total Number of users on the site till date can be obtained by the URL:
>``/admin/total_visitors``
<p>We are counting the number of unique ip_addresses and showing the result.</p>

###Total Number of registered users on the site till date:
>``/admin/total_registered_visitors``
<p>We are counting the number of unique user_id and showing the result.</p>

###Average visits per IP
>``/admin/visits_by_users``
<p>We are counting the number of visits by ip_address and showing the result.</p>

###Average visits per user_id
>``/admin/visits_by_registered_users``
<p>We are counting the number of visits by unique user_id and showing the result.</p>

###Daily visits
>``/admin/daily_visits``
<p>We are counting the number of users per day.</p>

###Daily Registered Visits
>``/admin/daily_registered_visits``
<p>We are counting the number of registered users visiting the site per day.</p>

Business data
-------------
In addition to the simple site metrics, we can fetch the following data for the admin.

###Total Users who visit any of the business' page
>``/business/total_users_for_business?business_id=<business_id>``
#####Example usage:
>``/business/total_users_for_business?business_id=1``

###Total Registered Users who visit any of the business' page
>``/business/total_registered_users_for_business?business_id=<business_id>``
#####Example Usage:
>``/business/total_registered_users_for_business?business_id=1``

###Total Registered Users who are checking your workers
>``/business/total_registered_users_checking_your_workers?business_id=<business_id>&worker_id=<w1>,<w2>``
#####Example Usage
>``/business/total_registered_users_checking_your_workers?business_id=1&worker_id=1,2``

###Daily visitors for any page of the business
>``/business/daily_registered_visits?business_id=<business_id>``
#####Example Usage
>``/business/daily_registered_visits?business_id=1``


Worker Data
-----------
###Total registered users who looked at your page
>``/worker/total_registered_visits?worker_id=<worker_id>``
#####Example Usage
>``/worker/total_registered_visits?worker_id=1``

###Total clicks on your name
>``/worker/total_registered_clicks?worker_id=<worker_id>``
#####Example Usage
>``/worker/total_registered_clicks?worker_id=1``

###Visitors according to day
>``/worker/daily_registered_visits?worker_id=<worker_id>``
######Example Usage
>``/worker/daily_registered_visits?worker_id=1``