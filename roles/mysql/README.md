Role Name
=========

This role installs MySQL, creates the eLabFTW database and grants rights to the eLab user.

Additionally, this copies a script to perform SQL dumps onto the node and enters it into
crontab to be run each day at 02:00 o'clock. Dumps are kept for three days.
