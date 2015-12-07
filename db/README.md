## After a db:dump task execution:

When updating the base DB structure, remember to *always* update
the dump folder of the generator of the engine with the new contents
generated here by moving the whole "dump" folder over

    lib/generators/install/templates

In this way, the refreshed dump will be treated as a base "template"
structure for a new install of the DB engine.


Remember also to invoke:

    > bundle update scada_db

...In the mounting app root to receive the updated gem version after
pushing the changes into the gem.
