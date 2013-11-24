If you can read this, you're building Water Cooler.  Here are some things you
need to know.

# How to set up a server
Use Heroku.  It'll start the Rails app for you.  That's 90% of what you need.

We use postgres for our database in production.  If you use SQLite locally,
there are occasionally issues with date representation between them.  Tread
carefully.

## Are you sending outbound email from the WC instance?
Then you should do this:

1. If you're not running on the top-level watercoolr.io domain, set the
   ```EMAIL_SUBDOMAIN``` environment variable.  If ```EMAIL_SUBDOMAIN=kuhltank```,
   your emails will be sent from ******@kuhltank.watercoolr.io
2. Set the ```MANDRILL_APIKEY``` environment variable.  You can find our Mandrill API
   keys by logging in to https://mandrillapp.com/settings/index.  If you don't
   have access to that, ask Sean.  Note that some keys are test keys that don't
   actually deliver mail anywhere.  This can be super useful, but if you aren't
   paying attention, can also make you wonder why the hell Mandrill's API
   responses all say your mail is being delivered, but you aren't actually
   sending anything.
3. For better deliverability, configure the DNS on whatever domain you're using
   so that this page https://mandrillapp.com/settings/sending-domains doesn't
   have any errors on it.

## Are you getting inbound email to this WC instance?
Then you should do this:

1. Add the domain you're receiving email from to this page:
   https://mandrillapp.com/inbound.  Configure the DNS settings until there
   aren't any errors.  Pay attention to DNS propagation times if you think you
   have everything set up right but Mandrill is still seeing errors.
2. Make sure you have a server with the /webhooks routes set up that's going
   to process this mail.  Copy it's mandrill route.  It'll looks something like
   ```http://kuhltank.herokuapp.com/webhooks/v0/email/mandrill``` .
3. Add a route to the domain you configured in step 1.  Tell it to match ```*```
   and use the URL from step 2 as the POST To URL.  Hit "send test".  If it
   works, you're good.
