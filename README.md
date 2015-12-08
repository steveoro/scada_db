# ScadaDb

Engine for basic DB structure used inside the SCADA Supervisor Suite.
The project is developed and released under MIT-LICENSE.


## System dependecies / Requires

Besides the obvious, check-out also ".versions-conf" and "Gemfile" for latest changes.

* Ruby 2.2+

* Rails 4.2+

* MySql/MariaDB 5+


## Install for development

Clone the repo locally and launch:

    > bundle install


## Configuration

Create or edit the database configuration file:

    spec/dummy/config/database.yml


## Testing & Beanchmarks

The project uses Guard [https://github.com/guard/guard] and Zeus [https://github.com/burke/zeus] to smooth the TDD flow.
Guard is declared as a development dependancy. Works flawlessy on Linux.
Zeus should be installed locally with:

    > gem i zeus

Zeus is inovked by Guard after launching the "runguard" script. The Guardfile can be edited to avoid Zeus usage at all, if it's the case.

To start TDD'ing, simply open two shells at once and type in the first one:

    > zeus start

...Followed, in the second one, by:

    > ./runguard

Guard will run any modified spec file as soon as they are saved.


The benchmarks for the Engine usage, whenever they are defined, are kept and stored under the specs of the dummy app.
You can found them at:

    /spec/dummy/spec/performance

There's a shortcut under guard to launch them. On the Pry console when running Guard
with the above command, to launch all the specs tagged as "performance" simply enter:

    > performance


Keep in mind that some editing may be required on the spec files themselves to avoid
or to enable excessively long-running tests. Just comment or uncomment where
indicated on the source files to limit the number of loops.


As a default, in the Guardfile all performance-tagged tests are skipped.


## Engine usage & mounting

Mount the engine in the application routes as usual. For example:

    # ...
    mount ScadaDb::Engine => "/scada_db"
    # ...

Since the Engine is mountable and namespaced, path helpers and class objects should always be prefixed with the engine namespace:

    # ...
    device = ScadaDb::Device.new
    # ...
